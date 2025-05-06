import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'services/user_service.dart';
import 'dart:async'; // Add this import for TimeoutException

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // final GoogleSignIn _googleSignIn = GoogleSignIn();
  final UserService _userService = UserService();

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Stream of auth changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign in with email and password
  Future<UserCredential?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update last active timestamp
      if (credential.user != null) {
        await _userService.initializeNewUser(credential.user!);
      }

      return credential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Sign up with email and password
  Future<UserCredential?> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      // Check first if the email already exists
      try {
        final methods = await _auth.fetchSignInMethodsForEmail(email);
        if (methods.isNotEmpty) {
          throw FirebaseAuthException(
            code: 'email-already-in-use',
            message: 'Email is already in use.',
          );
        }
      } catch (e) {
        // If we can't check (e.g., network error), proceed with account creation anyway
        // The Firebase Auth itself will handle duplicate accounts
        if (e is! FirebaseAuthException || e.code != 'network-request-failed') {
          rethrow;
        }
      }
      
      // Set a timeout for the createUserWithEmailAndPassword operation
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      ).timeout(
        const Duration(seconds: 20),
        onTimeout: () {
          throw FirebaseAuthException(
            code: 'timeout',
            message: 'The connection timed out. Please try again.',
          );
        },
      );

      // Initialize user in Firestore
      if (credential.user != null) {
        await _userService.initializeNewUser(credential.user!);

        // Add first login achievement
        await _userService.addAchievement(
          userId: credential.user!.uid,
          achievement: 'first_login',
        );
      }

      return credential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      if (e.toString().contains('TimeoutException')) {
        throw 'Connection timed out. Please check your internet connection and try again.';
      }
      throw 'An unexpected error occurred: ${e.toString()}';
    }
  }

  // // Sign in with Google
  // Future<UserCredential?> signInWithGoogle() async {
  //   try {
  //     // Trigger the authentication flow
  //     final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
  //     if (googleUser == null) return null;

  //     // Obtain the auth details from the request
  //     final GoogleSignInAuthentication googleAuth =
  //         await googleUser.authentication;

  //     // Create a new credential
  //     final credential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth.accessToken,
  //       idToken: googleAuth.idToken,
  //     );

  //     // Sign in to Firebase with the Google credential
  //     final userCredential = await _auth.signInWithCredential(credential);

  //     // Initialize user in Firestore
  //     if (userCredential.user != null) {
  //       await _userService.initializeNewUser(userCredential.user!);

  //       // Check if this is a new user
  //       if (userCredential.additionalUserInfo?.isNewUser ?? false) {
  //         // Add first login achievement
  //         await _userService.addAchievement(
  //           userId: userCredential.user!.uid,
  //           achievement: 'first_login',
  //         );
  //       }
  //     }

  //     return userCredential;
  //   } on FirebaseAuthException catch (e) {
  //     throw _handleAuthException(e);
  //   }
  // }

  // // Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Sign out
  Future<void> signOut() async {
    // await _googleSignIn.signOut();
    await _auth.signOut();
  }

  // Handle authentication exceptions
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'email-already-in-use':
        return 'Email is already in use.';
      case 'invalid-email':
        return 'Email is invalid.';
      case 'weak-password':
        return 'Password is too weak.';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled.';
      case 'user-disabled':
        return 'This user has been disabled.';
      case 'network-request-failed':
        return 'Network error. Please check your internet connection.';
      case 'timeout':
        return 'The connection timed out. Please try again.';
      default:
        return 'An error occurred. Please try again.';
    }
  }
}
