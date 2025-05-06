import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/foundation.dart';
import 'firebase_options.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'bottomnavigation.dart';
import 'login_screen.dart';
import 'signup_screen.dart';
import 'auth_service.dart';
import 'privacy_policy_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Initialize Firebase App Check based on environment
  try {
    if (kDebugMode) {
      // Use debug providers during development
      await FirebaseAppCheck.instance.activate(
        androidProvider: AndroidProvider.debug,
        appleProvider: AppleProvider.debug,
      );
    } else {
      // Use secure providers in production
      await FirebaseAppCheck.instance.activate(
        androidProvider: AndroidProvider.playIntegrity,
        appleProvider: AppleProvider.appAttest,
      );
    }
  } catch (e) {
    // If App Check activation fails, log the error but continue app initialization
    print('Error initializing Firebase App Check: $e');
    // Try with debug provider as fallback
    try {
      await FirebaseAppCheck.instance.activate(
        androidProvider: AndroidProvider.debug,
        appleProvider: AppleProvider.debug,
      );
    } catch (_) {
      // Continue even if this fails
    }
  }
  
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.deepPurple[500],
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontFamily: "arlrdbd",
            fontSize: 20,
          ),
        ),
        cardTheme: CardTheme(
          elevation: 4,
          color: Colors.purple[50],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(
            color: Colors.black,
            fontFamily: "arlrdbd",
          ),
          bodyMedium: TextStyle(
            color: Colors.black,
            fontFamily: "arlrdbd",
          ),
          titleLarge: TextStyle(
            color: Colors.black,
            fontFamily: "arlrdbd",
            fontSize: 18,
          ),
        ),
        colorScheme: ColorScheme.light(
          primary: Colors.deepPurple[500]!,
          secondary: Colors.purple[100]!,
          surface: Colors.purple[50]!,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => StreamBuilder<User?>(
              stream: _authService.authStateChanges,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(
                        color: Colors.deepPurple,
                      ),
                    ),
                  );
                }
                if (snapshot.hasData) {
                  // User is signed in
                  return BottomNav();
                }
                // User is not signed in
                return const LoginScreen();
              },
            ),
        '/signup': (context) => const SignupScreen(),
        '/privacy': (context) => PrivacyPolicyPage(),
      },
    );
  }
}
