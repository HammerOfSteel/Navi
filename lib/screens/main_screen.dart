import 'package:flutter/material.dart';
import 'package:navi_app/screens/local_info_screen.dart';
import 'package:navi_app/screens/voice_commands_screen.dart';
//import 'package:navi_app/screens/settings_screen.dart';
//import 'package:navi_app/screens/ar_screen.dart';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      children: <Widget>[
        VoiceCommandScreen(),
        LocalInfoScreen(),
        //ArScreen(),  // Use the correct class name 'ArScreen'
        //SettingsScreen(),
      ],
    );
  }
}
