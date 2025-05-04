import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Collection reference
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');

  // Get current user ID
  String? get currentUserId => _auth.currentUser?.uid;

  // Create or update user profile
  Future<void> createOrUpdateUser(UserModel user) async {
    try {
      await _usersCollection.doc(user.uid).set(
            user.toFirestore(),
            SetOptions(merge: true),
          );
    } catch (e) {
      print('Error creating/updating user: $e');
      rethrow;
    }
  }

  // Get user by ID
  Future<UserModel?> getUserById(String userId) async {
    try {
      DocumentSnapshot doc = await _usersCollection.doc(userId).get();

      if (doc.exists) {
        return UserModel.fromFirestore(
            doc.data() as Map<String, dynamic>, doc.id);
      }
      return null;
    } catch (e) {
      print('Error getting user: $e');
      return null;
    }
  }

  // Get current user
  Future<UserModel?> getCurrentUser() async {
    if (currentUserId == null) return null;
    return getUserById(currentUserId!);
  }

  // Update user profile
  Future<void> updateUserProfile({
    required String userId,
    String? displayName,
    String? photoURL,
  }) async {
    try {
      Map<String, dynamic> data = {};

      if (displayName != null) data['displayName'] = displayName;
      if (photoURL != null) data['photoURL'] = photoURL;
      data['lastActive'] = FieldValue.serverTimestamp();

      await _usersCollection.doc(userId).update(data);
    } catch (e) {
      print('Error updating user profile: $e');
      rethrow;
    }
  }

  // Update learning progress
  Future<void> updateLearningProgress({
    required String userId,
    required String category,
    required double progress,
  }) async {
    try {
      await _usersCollection.doc(userId).update({
        'learningProgress.$category': progress,
        'lastActive': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error updating learning progress: $e');
      rethrow;
    }
  }

  // Add achievement
  Future<void> addAchievement({
    required String userId,
    required String achievement,
  }) async {
    try {
      await _usersCollection.doc(userId).update({
        'achievements': FieldValue.arrayUnion([achievement]),
        'lastActive': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error adding achievement: $e');
      rethrow;
    }
  }

  // Update user preferences
  Future<void> updateUserPreferences({
    required String userId,
    required Map<String, dynamic> preferences,
  }) async {
    try {
      await _usersCollection.doc(userId).update({
        'preferences': preferences,
        'lastActive': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error updating user preferences: $e');
      rethrow;
    }
  }

  // Initialize user in Firestore after signup
  Future<void> initializeNewUser(User firebaseUser) async {
    try {
      // Check if user document exists
      final docSnapshot = await _usersCollection.doc(firebaseUser.uid).get();

      if (!docSnapshot.exists) {
        print("Creating new user document for ${firebaseUser.uid}");

        // Create initial user data
        final Map<String, dynamic> userData = {
          'uid': firebaseUser.uid,
          'email': firebaseUser.email ?? '',
          'displayName': firebaseUser.displayName,
          'photoURL': firebaseUser.photoURL,
          'createdAt': FieldValue.serverTimestamp(),
          'lastActive': FieldValue.serverTimestamp(),
          'learningProgress': {
            'alphabet': 0.0,
            'numbers': 0.0,
            'animals': 0.0,
            'fruits': 0.0,
            'vegetables': 0.0,
            'colors': 0.0,
            'shapes': 0.0,
            'birds': 0.0,
            'months': 0.0,
          },
          'achievements': ['first_login'],
          'preferences': {
            'notifications': true,
            'language': 'English',
            'speechRate': 0.5,
          },
        };

        // Set the user document with initial data
        await _usersCollection.doc(firebaseUser.uid).set(userData);
        print("User document created successfully for ${firebaseUser.uid}");
      } else {
        // Update last active timestamp for existing users
        await _usersCollection.doc(firebaseUser.uid).update({
          'lastActive': FieldValue.serverTimestamp(),
        });
        print("Updated lastActive for existing user ${firebaseUser.uid}");
      }
    } catch (e) {
      print("Error initializing user in Firestore: $e");
      // Don't rethrow to prevent auth flow interruption
    }
  }
}
