import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:memorize_numbers/gamefield/gamefield_countdown.dart';
import 'package:memorize_numbers/shared/countdown.dart';
import 'package:memorize_numbers/gamefield/digitgenerator.dart';
import 'package:memorize_numbers/gamefield/result.dart';
import 'package:memorize_numbers/start/start.dart';

enum GamefieldState { timer, showNumber, inputNumber, showResult }

class Gamefield extends StatefulWidget {
  final int _rounds;
  final int _digits;
  final double _displayTime;

  Gamefield(this._rounds, this._digits, this._displayTime, {Key? key})
      : super(key: key);

  @override
  _GamefieldState createState() => _GamefieldState();
}

class _GamefieldState extends State<Gamefield> {
  late GamefieldState _currentState;

  final PageController _pageController = PageController(initialPage: 0);
  final DigitGenerator _digitGenerator = DigitGenerator();
  int _currentRound = 1;
  late String _generatedNumber = '';
  final List<bool> inputPressed = [];
  final List<String> _inputList = [];
  String _input = '';
  int _correct = 0;
  int _wrong = 0;
  bool isCorrect = false;

  @override
  void initState() {
    this._currentState = GamefieldState.timer;
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
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
        body: PageView(
          controller: _pageController,
          physics: NeverScrollableScrollPhysics(),
          children: [
            gamefieldCountdown(),
            gamefieldShowNumber(),
            gamefieldInputNumber(),
            gamefieldResult(),
          ],
        ),
      ),
    );
  }

  Widget gamefieldCountdown() {
    return GamefieldCountdown(changeGamestate);
  }

  Widget gamefieldShowNumber() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
                child: Text(
                  'Merke:',
                  style: TextStyle(fontSize: 32),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: Text(
                  '${this._generatedNumber}',
                  style: TextStyle(fontSize: 32, letterSpacing: 10),
                ),
              ),
            ],
          ),
          Container(
            child: Countdown((this.widget._displayTime * 1000).toInt(), () {
              changeGamestate();
            }),
          ),
          Text(' ')
        ]);
  }

  Widget gamefieldInputNumber() {
    return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
        child: Text(
          'Eingabe:',
          style: TextStyle(fontSize: 32),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: hiddenNumber()),
      ),
      numberInputContainer(),
    ]);
  }

  Widget numberInputContainer() {
    return Container(
      width: 300,
      height: 400,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              BtnInputNumber(Text('1'), () {
                onBtnNumberPressed(1);
              }),
              BtnInputNumber(Text('4'), () {
                onBtnNumberPressed(4);
              }),
              BtnInputNumber(Text('7'), () {
                onBtnNumberPressed(7);
              }),
              BtnInputNumber(Icon(Icons.backspace), () {
                onBtnBackPressed();
              }),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              BtnInputNumber(Text('2'), () {
                onBtnNumberPressed(2);
              }),
              BtnInputNumber(Text('5'), () {
                onBtnNumberPressed(5);
              }),
              BtnInputNumber(Text('8'), () {
                onBtnNumberPressed(8);
              }),
              BtnInputNumber(Text('0'), () {
                onBtnNumberPressed(0);
              }),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              BtnInputNumber(Text('3'), () {
                onBtnNumberPressed(3);
              }),
              BtnInputNumber(Text('6'), () {
                onBtnNumberPressed(6);
              }),
              BtnInputNumber(Text('9'), () {
                onBtnNumberPressed(9);
              }),
              BtnInputNumber(Icon(Icons.done), () {
                onBtnSubmitPressed();
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget gamefieldResult() {
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
            child:
                ResultInfo(this._generatedNumber, this.isCorrect, this._input)),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: 300,
            height: 64,
            child: ElevatedButton(
              onPressed: () {
                changeGamestate();
                navigateToNext(context);
              },
              child: Text(
                buttonText,
                style: TextStyle(fontSize: 32.0),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void changeGamestate() {
    switch (this._currentState) {
      case GamefieldState.timer:
        this.setState(() {
          this._generatedNumber =
              this._digitGenerator.generateRandomInteger(this.widget._digits);
          this._currentState = GamefieldState.showNumber;
        });

        if (_pageController.hasClients) {
          _pageController.animateToPage(
            1,
            duration: const Duration(milliseconds: 100),
            curve: Curves.linear,
          );
        }
        break;
      case GamefieldState.showNumber:
        this.setState(() {
          this._currentState = GamefieldState.inputNumber;
          this._input = '';
          this._inputList.clear();
          this.inputPressed.clear();
        });
        if (_pageController.hasClients) {
          _pageController.jumpToPage(2);
        }
        break;
      case GamefieldState.inputNumber:
        this.setState(() {
          this._currentState = GamefieldState.showResult;
        });
        _pageController.animateToPage(
          3,
          duration: const Duration(milliseconds: 100),
          curve: Curves.linear,
        );
        break;
      case GamefieldState.showResult:
        this.setState(() {
          this._currentState = GamefieldState.timer;
          this._currentRound++;
        });

        break;
    }
  }

  List<Widget> hiddenNumber() {
    List<Widget> widgets = [];
    for (var i = 0; i < this.widget._digits; i++) {
      this.inputPressed.add(false);
      this._inputList.add('');
      widgets.add(_HiddenChar(this.inputPressed[i], this._inputList[i]));
    }
    return widgets;
  }

  onBtnNumberPressed(int number) {
    setState(() {
      if (_input.length < this.widget._digits) {
        this.inputPressed[_input.length] = true;
        this._inputList[_input.length] = number.toString();
        _input += number.toString();
      }
    });
  }

  onBtnBackPressed() {
    setState(() {
      if (_input.length > 0) {
        _input = _input.substring(0, _input.length - 1);
        this.inputPressed[_input.length] = false;
        this._inputList[_input.length] = '';
      }
    });
  }

  onBtnSubmitPressed() {
    checkInput();
    changeGamestate();
  }

  void checkInput() {
    if (this._input == this._generatedNumber) {
      setState(() {
        this._correct++;
        this.isCorrect = true;
      });
    } else {
      setState(() {
        this.isCorrect = false;
        this._wrong++;
      });
    }
  }

  navigateToNext(BuildContext context) {
    if (this._currentRound <= this.widget._rounds) {
      _pageController.animateToPage(
        0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.linear,
      );
      return;
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => StartPage()),
        (Route<dynamic> route) => false,
      );
      return;
    }
  }
}

class _HiddenChar extends StatelessWidget {
  final bool isPressed;
  final String input;

  _HiddenChar(
    this.isPressed,
    this.input, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        isPressed ? this.input : '*',
        style: TextStyle(
            letterSpacing: 16,
            fontSize: 32,
            color: isPressed ? Colors.green : Colors.black),
      ),
    );
  }
}

class BtnInputNumber extends StatelessWidget {
  final _onPressed;

  final Widget value;

  BtnInputNumber(
    this.value,
    this._onPressed, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 74,
      height: 74,
      color: Colors.black,
      margin: const EdgeInsets.all(2.0),
      padding: const EdgeInsets.all(2.0),
      child: FloatingActionButton(
        shape: RoundedRectangleBorder(),
        onPressed: _onPressed,
        child: value,
      ),
    );
  }
}

class BtnInput extends StatelessWidget {
  final _onPressed;

  final Icon _child;

  BtnInput(
    this._child,
    this._onPressed, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: _onPressed, child: _child);
  }
}
