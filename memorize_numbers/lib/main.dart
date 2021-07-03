import 'package:flutter/material.dart';
import 'start/start.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Besieg die Zahlen',
      theme: ThemeData(
          primarySwatch: Colors.green,
          buttonTheme: ButtonThemeData(buttonColor: Colors.grey)),
      home: StartPage(),
    );
  }
}
