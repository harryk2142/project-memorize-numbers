import 'dart:async';

import 'package:flutter/material.dart';

class Countdown extends StatefulWidget {
  final _milliseconds;

  final Function _onEnd;

  Countdown(this._milliseconds, this._onEnd);
  @override
  _CountdownState createState() => _CountdownState();
}

class _CountdownState extends State<Countdown>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Timer _timer;
  int seconds = 0;
  @override
  void initState() {
    _controller = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: this.widget._milliseconds));
    this.seconds = this.widget._milliseconds ~/ 1000;
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (this.mounted) {
        setState(() {
          this.seconds--;
        });
      }
      if (this.seconds <= 0) {
        _timer.cancel();
        this.widget._onEnd();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(this.seconds.toString(), style: TextStyle(fontSize: 32));
  }
}
