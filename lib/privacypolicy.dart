import 'package:flutter/material.dart';
import 'profile_screen.dart';

// This file is kept for backward compatibility
// It now simply redirects to the new ProfileScreen
class PrivacyPolicy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ProfileScreen();
  }
}
