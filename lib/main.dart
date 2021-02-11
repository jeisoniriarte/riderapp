import 'package:flutter/material.dart';
import 'package:riderapp/AllScreens/loginscreen.dart';
//import 'package:riderapp/AllScreens/mainscreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Taxi Rider App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Brand Regular",
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginScreen(),
    );
  }
}
