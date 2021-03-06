import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:memorize_numbers/gamefield/gamefield_countdown.dart';
import 'package:memorize_numbers/shared/constants.dart';
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
            title: Text('RUNDE $_currentRound/${widget._rounds}',
                style: TextStyle(color: Constants.mainTextColor))),
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
              numberInputHead(
                  'Merke:',
                  Text(
                    '${this._generatedNumber}',
                    style: TextStyle(fontSize: 64, letterSpacing: 10),
                  )),
            ],
          ),
          Container(
            child: Countdown((this.widget._displayTime * 1000).toInt(), () {
              changeGamestate();
            }),
          ),
          Text('')
        ]);
  }

  Widget gamefieldInputNumber() {
    return Center(
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        numberInputHead(
          'Eingabe:',
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: hiddenNumber()),
        ),
        numberInputContainer(),
        Text('')
      ]),
    );
  }

  Widget numberInputHead(String text, Widget content) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
          child: Text(
            text,
            style: TextStyle(fontSize: 32),
          ),
        ),
        Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
            child: content),
      ],
    );
  }

  Widget numberInputContainer() {
    return Center(
      child: Container(
        width: 300,
        height: 400,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _BtnInputNumber(_TextInputNumber(1), () {
                  onBtnNumberPressed(1);
                }),
                _BtnInputNumber(_TextInputNumber(4), () {
                  onBtnNumberPressed(4);
                }),
                _BtnInputNumber(_TextInputNumber(7), () {
                  onBtnNumberPressed(7);
                }),
                _BtnInputNumber(
                    Icon(
                      Icons.backspace,
                      color: Constants.mainTextColor,
                    ), () {
                  onBtnBackPressed();
                }),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _BtnInputNumber(_TextInputNumber(2), () {
                  onBtnNumberPressed(2);
                }),
                _BtnInputNumber(_TextInputNumber(5), () {
                  onBtnNumberPressed(5);
                }),
                _BtnInputNumber(_TextInputNumber(8), () {
                  onBtnNumberPressed(8);
                }),
                _BtnInputNumber(_TextInputNumber(0), () {
                  onBtnNumberPressed(0);
                }),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _BtnInputNumber(_TextInputNumber(3), () {
                  onBtnNumberPressed(3);
                }),
                _BtnInputNumber(_TextInputNumber(6), () {
                  onBtnNumberPressed(6);
                }),
                _BtnInputNumber(_TextInputNumber(9), () {
                  onBtnNumberPressed(9);
                }),
                _BtnInputNumber(
                    Icon(Icons.done, color: Constants.mainTextColor), () {
                  onBtnSubmitPressed();
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget gamefieldResult() {
    String buttonText = '';
    if (this._currentRound == this.widget._rounds) {
      buttonText = 'Zum Hauptmen??';
    } else {
      buttonText = 'N??chste Runde';
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
                style:
                    TextStyle(fontSize: 32.0, color: Constants.mainTextColor),
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

class _TextInputNumber extends StatelessWidget {
  final int number;

  const _TextInputNumber(
    this.number, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(number.toString(),
        style: TextStyle(
          color: Constants.mainTextColor,
        ));
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
            fontSize: 64,
            color: isPressed ? Constants.mainBackgroundColor : Colors.black),
      ),
    );
  }
}

class _BtnInputNumber extends StatelessWidget {
  final _onPressed;

  final Widget value;

  _BtnInputNumber(
    this.value,
    this._onPressed, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
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
