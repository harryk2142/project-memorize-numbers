import 'package:flutter/widgets.dart';
import 'package:memorize_numbers/shared/countdown.dart';

class GamefieldCountdown extends StatelessWidget {
  final VoidCallback doAction;

  const GamefieldCountdown(this.doAction, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Runde startet in',
            style: TextStyle(fontSize: 32),
          ),
          Countdown(3000, doAction)
        ],
      ),
    );
  }
}
