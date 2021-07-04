import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:memorize_numbers/gamefield/countdown.dart';
import 'package:memorize_numbers/gamefield/digitgenerator.dart';
import 'package:memorize_numbers/gamefield/result.dart';
import 'package:memorize_numbers/shared/navigation.dart';
import 'package:memorize_numbers/start/start.dart';

enum GameFieldState { timer, showNumber, inputNumber, showResult }

class GameField extends StatefulWidget {
  final int _rounds;
  final double _displayTime;
  final int _digits;

  final DigitGenerator digitGenerator = DigitGenerator();
  GameField(this._rounds, this._digits, this._displayTime, {Key? key})
      : super(key: key);
  @override
  _GameFieldState createState() {
    return _GameFieldState();
  }
}

class _GameFieldState extends State<GameField> {
  GameFieldState? _currentState;
  bool _inputCorrect = false;
  String _generatedNumber = '';
  int _correct = 0;
  int _wrong = 0;
  int _currentRound = 1;
  String _inputNumber = '';
  late Widget _body;

  @override
  void initState() {
    _currentState = GameFieldState.timer;
    _body = getWidget();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: Text('RUNDE $_currentRound/${widget._rounds}'),
          ),
          body: _body),
    );
  }

  Widget getWidget() {
    switch (this._currentState) {
      case GameFieldState.timer:
        this.setState(() {
          this._generatedNumber = this
              .widget
              .digitGenerator
              .generateRandomInteger(this.widget._digits);
        });
        return showTimer();
      case GameFieldState.showNumber:
        return showNumberWidget();
      case GameFieldState.inputNumber:
        return inputNumberWidget();
      case GameFieldState.showResult:
        return showResultWidget();
      default:
        return showBackWidget();
    }
  }

  Widget showNumberWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Countdown((this.widget._displayTime * 1000).toInt(), updateValues),
          Text(
            'Merke: ${this._generatedNumber}',
            style: TextStyle(fontSize: 32),
          ),
        ],
      ),
    );
  }

  void updateValues() {
    this.setState(() {
      this._currentState = GameFieldState.inputNumber;
      this._body = getWidget();
    });
  }

  navigateToTimer(BuildContext context) {
    this.setState(() {
      this._currentRound++;
    });

    if (this._currentRound > this.widget._rounds) {
      print('backToStart');
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => StartPage()));
    } else {
      print('navigateToTimer');
      this.setState(() {
        this._currentState = GameFieldState.timer;
        this._body = getWidget();
      });
    }
  }

  Widget inputNumberWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextField(
          decoration: new InputDecoration(labelText: 'Zahl eingeben'),
          autofocus: true,
          maxLength: this.widget._digits,
          keyboardType: TextInputType.number,
          style: TextStyle(fontSize: 32.0, height: 1.0, color: Colors.black),
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
          onSubmitted: (value) =>
              checkInput(value), // Only numbers can be entered
        ),
      ],
    );
  }

  Widget showResultWidget() {
    String buttonText = '';
    if (this._currentRound == this.widget._rounds) {
      buttonText = 'Zum Hauptmenü';
    } else {
      buttonText = 'Nächste Runde';
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          padding: const EdgeInsets.all(16.0),
          child: ResultRow(this._correct, this._wrong),
        ),
        Container(
            padding: const EdgeInsets.all(16.0),
            child: ResultInfo(
                this._generatedNumber, this._inputCorrect, this._inputNumber)),
        NavigationButton(buttonText, navigateToTimer)
      ],
    );
  }

  Widget showBackWidget() {
    return Center(
        child: TextButton(
      onPressed: () => {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (BuildContext context) => StartPage()))
      },
      child: Text(
        "Zurück zum Start",
        style: TextStyle(height: 1, fontSize: 32),
      ),
    ));
  }

  void checkInput(String input) {
    this.setState(() {
      _inputCorrect = this._generatedNumber == input;
      this._inputNumber = input;
      _currentState = GameFieldState.showResult;
      if (_inputCorrect) {
        _correct++;
      } else {
        _wrong++;
      }
      this._body = getWidget();
    });
  }

  Widget showTimer() {
    this.setState(() {
      String number =
          widget.digitGenerator.generateRandomInteger(this.widget._digits);
      this._generatedNumber = number;
    });
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Runde startet in',
            style: TextStyle(fontSize: 32),
          ),
          Countdown(3000, this.startRound),
        ],
      ),
    );
  }

  startRound() {
    this.setState(() {
      this._currentState = GameFieldState.showNumber;
      this._body = getWidget();
    });
  }
}
