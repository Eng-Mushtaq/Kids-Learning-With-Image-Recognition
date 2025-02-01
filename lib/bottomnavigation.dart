import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'homeScreen.dart';
import 'privacypolicy.dart';
import 'setting.dart';

class BottomNav extends StatefulWidget {
  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _selectedIndex = 1;

  static final List<Widget> _pages = <Widget>[
    Setting(),
    const HomeScreen(),
    PrivacyPolicy(),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 32,
        selectedItemColor: const Color.fromARGB(255, 113, 0, 173),
        selectedIconTheme:
            const IconThemeData(color: Color.fromARGB(255, 150, 76, 230)),
        currentIndex: _selectedIndex, //New
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            //  icon: ImageIcon(AssetImage("assets/images/12Icon feather-settings.png")),
            icon: Icon(Icons.settings),
            label: 'Setting',
          ),
          BottomNavigationBarItem(
            // icon: ImageIcon(AssetImage("assets/images/12Group 1.png")),
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            // icon: ImageIcon(AssetImage("assets/images/privacy.png")),
            icon: Icon(Icons.privacy_tip_outlined),
            label: 'Privacy',
          ),
        ],
      ),
      body: Center(
        child: _pages.elementAt(_selectedIndex),
      ),
    );
  }
}
