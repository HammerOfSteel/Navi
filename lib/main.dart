import 'package:flutter/material.dart';
import 'package:navi_app/screens/main_screen.dart';

void main() {
  runApp(NaviApp());
}

class NaviApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Navi Smart Assistant',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MainScreen(),
    );
  }
}
