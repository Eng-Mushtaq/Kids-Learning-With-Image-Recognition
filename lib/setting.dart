import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kids_learning/privacypolicy.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

class Setting extends StatefulWidget {
  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  // Settings state
  bool _notificationsEnabled = true;
  String _selectedLanguage = 'English';
  double _speechRate = 0.5;

  // Open app in Play Store
  Future<void> _openPlayStore() async {
    const url = "https://play.google.com/store/apps/details?id=" + "";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not open Play Store'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Share app
  void _shareApp() {
    Share.share(
      'Check out this amazing Kids Learning app for children!',
      subject: 'Kids Learning App',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(color: Colors.white, fontFamily: "arlrdbd"),
        ),
        backgroundColor: Colors.deepPurple[500],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App header with logo
            Container(
              color: Colors.deepPurple[500],
              child: Container(
                padding: EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.deepPurple[500],
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(36),
                    bottomRight: Radius.circular(36),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Image.asset(
                        "assets/images/logo.png",
                        width: 80,
                        height: 80,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Kids",
                          style: TextStyle(
                            fontSize: 22,
                            fontFamily: "arlrdbd",
                            color: Colors.white,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            "Learning!",
                            style: TextStyle(
                              fontSize: 22,
                              fontFamily: "arlrdbd",
                              color: Color(0xFFF19335),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Settings sections
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'App Settings',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                  fontFamily: "arlrdbd",
                ),
              ),
            ),

            // Notifications toggle
            SwitchListTile(
              title: Text(
                'Notifications',
                style: TextStyle(
                  fontFamily: "arlrdbd",
                  fontSize: 16,
                ),
              ),
              subtitle: Text('Enable app notifications'),
              value: _notificationsEnabled,
              activeColor: Colors.deepPurple,
              onChanged: (value) {
                setState(() {
                  _notificationsEnabled = value;
                });
              },
            ),

            // Language dropdown
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Language',
                    style: TextStyle(
                      fontFamily: "arlrdbd",
                      fontSize: 16,
                    ),
                  ),
                  DropdownButton<String>(
                    value: _selectedLanguage,
                    items: ['English', 'Spanish', 'French', 'German']
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedLanguage = newValue!;
                      });
                    },
                  ),
                ],
              ),
            ),

            // Speech rate slider
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Speech Rate',
                    style: TextStyle(
                      fontFamily: "arlrdbd",
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Text('Slow'),
                      Expanded(
                        child: Slider(
                          value: _speechRate,
                          min: 0.1,
                          max: 1.0,
                          divisions: 9,
                          activeColor: Colors.deepPurple,
                          onChanged: (value) {
                            setState(() {
                              _speechRate = value;
                            });
                          },
                        ),
                      ),
                      Text('Fast'),
                    ],
                  ),
                ],
              ),
            ),

            Divider(),

            // Rate and Share buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: Icon(Icons.star),
                      label: Text('Rate Us'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.deepPurple,
                        side: BorderSide(color: Colors.deepPurple),
                        padding: EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: _openPlayStore,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: Icon(Icons.share),
                      label: Text('Share App'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.deepPurple,
                        side: BorderSide(color: Colors.deepPurple),
                        padding: EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: _shareApp,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 24),

            // App version
            Center(
              child: Text(
                'Version 2.0.0',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
