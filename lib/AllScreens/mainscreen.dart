import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  // Identificador
  static const String idScreen = "mainscreen";

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Rider App"),
      ),
    );
  }
}
