import 'package:flutter/material.dart';
import 'package:memorize_numbers/start/start.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Besieg die Zahlen',
        theme: ThemeData(
            textTheme: TextTheme(bodyText1: TextStyle(height: 1, fontSize: 32)),
            primarySwatch: Colors.green,
            buttonTheme: ButtonThemeData(buttonColor: Colors.grey)),
        home: StartPage());
  }
}
