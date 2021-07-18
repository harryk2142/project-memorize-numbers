import 'package:flutter/material.dart';
import 'package:memorize_numbers/shared/constants.dart';
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
          iconTheme: IconThemeData(size: 32),
          buttonTheme: ButtonThemeData(height: 16),
          textTheme: TextTheme(
              bodyText1: TextStyle(height: 1, fontSize: 32),
              button: TextStyle(fontSize: 32)),
          primarySwatch: Constants.mainBackgroundColor,
        ),
        home: StartPage());
  }
}
