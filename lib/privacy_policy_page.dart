import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text(
          'Privacy Policy',
          style: TextStyle(color: Colors.white, fontFamily: "arlrdbd"),
        ),
        backgroundColor: Colors.deepPurple[500],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.shield,
              size: 48,
              color: Colors.deepPurple,
            ),
            const SizedBox(height: 16),
            const Text(
              'Privacy Policy',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
                fontFamily: "arlrdbd",
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Last updated: June 2023',
              style: TextStyle(
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('Information We Collect'),
            _buildSectionContent(
              'Our app collects minimal information necessary for its functionality. '
              'We do not collect or store any personal information from children. '
              'The app may use camera access for real-time object detection, but images are '
              'processed locally on your device and are not stored or transmitted.',
            ),
            _buildSectionTitle('How We Use Information'),
            _buildSectionContent(
              'The camera feed is used solely for real-time object detection to provide '
              'educational content about animals, vegetables, and fruits. '
              'No data is shared with third parties or used for advertising purposes.',
            ),
            _buildSectionTitle('Data Storage'),
            _buildSectionContent(
              'All processing happens on your device. We do not store or transmit '
              'images or video from your camera. The app may save basic settings '
              'preferences locally on your device.',
            ),
            _buildSectionTitle('Children\'s Privacy'),
            _buildSectionContent(
              'This app is designed for children\'s education. We comply with children\'s '
              'privacy laws and do not collect personal information from children. '
              'No advertising is displayed within the app.',
            ),
            _buildSectionTitle('Changes to This Policy'),
            _buildSectionContent(
              'We may update our Privacy Policy from time to time. We will notify '
              'you of any changes by posting the new Privacy Policy on this page.',
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.email_outlined),
                label: const Text('Contact Us'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                onPressed: () {
                  // Add contact functionality here
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Contact feature coming soon!'),
                      backgroundColor: Colors.deepPurple,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.deepPurple[700],
          fontFamily: "arlrdbd",
        ),
      ),
    );
  }

  Widget _buildSectionContent(String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        content,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black87,
          height: 1.5,
        ),
      ),
    );
  }
}
