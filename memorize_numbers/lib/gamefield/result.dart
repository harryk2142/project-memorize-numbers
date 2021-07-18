import 'package:flutter/material.dart';

class ResultInfo extends StatelessWidget {
  final _inputCorrect;
  final _generatedNumber;
  final _inputNumber;

  ResultInfo(this._generatedNumber, this._inputCorrect, this._inputNumber);

  @override
  Widget build(BuildContext context) {
    return buildResultWidget();
  }

  Widget buildResultWidget() {
    Widget result = Container();
    if (this._inputCorrect) {
      result = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              Icon(
                Icons.sentiment_satisfied,
                color: Colors.green,
                size: 128,
              ),
              Text(
                'Zahl ist korrekt',
                style: TextStyle(fontSize: 32),
              ),
            ],
          ),
        ],
      );
    } else {
      result = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              Icon(
                Icons.sentiment_dissatisfied,
                color: Colors.red,
                size: 128,
              ),
              Text(
                'Zahl ist falsch',
                style: TextStyle(fontSize: 32),
              ),
              Text(
                'Einabe ist: ${this._inputNumber}',
                style: TextStyle(fontSize: 32),
              ),
              Text(
                'Richtig wäre: ${this._generatedNumber}',
                style: TextStyle(fontSize: 32),
              ),
            ],
          ),
        ],
      );
    }
    return result;
  }
}

class ResultRow extends StatelessWidget {
  final _correct;
  final _wrong;
  ResultRow(this._correct, this._wrong);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.sentiment_satisfied,
              color: Colors.green,
              size: 128,
            ),
            Text(
              '${this._correct}',
              style: TextStyle(fontSize: 32),
            ),
          ],
        ),
        Column(
          children: [
            Icon(
              Icons.sentiment_dissatisfied,
              color: Colors.red,
              size: 128,
            ),
            Text(
              '${this._wrong}',
              style: TextStyle(fontSize: 32),
            ),
          ],
        )
      ],
    );
  }
}
