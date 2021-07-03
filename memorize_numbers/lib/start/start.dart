import 'package:flutter/material.dart';
import 'package:memorize_numbers/training/training.dart';

class StartPage extends StatelessWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                StartIcon(),
                Title(),
              ],
            ),
            StartMenu()
          ],
        ),
      ),
    );
  }
}

class StartIcon extends StatelessWidget {
  const StartIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(
            top: 32.0, bottom: 16.0, left: 32.0, right: 32.0),
        child: Image(width: 128, image: AssetImage('assets/icons/icon.png')),
      ),
    );
  }
}

class Title extends StatelessWidget {
  const Title({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Text(
        'Besieg die Zahlen',
        style: TextStyle(fontSize: 32),
      ),
    );
  }
}

class StartMenu extends StatelessWidget {
  const StartMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          StartMenuButton('Training', (context) => onTrainingClick(context))
        ],
      ),
    );
  }

  void onTrainingClick(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => Training(),
      ),
      (route) => false,
    );
  }
}

class StartMenuButton extends StatelessWidget {
  final String text;
  final Function onClick;
  const StartMenuButton(this.text, this.onClick, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        width: 300,
        height: 64,
        child: ElevatedButton(
          onPressed: () => onClick,
          child: Text(
            this.text,
            style: TextStyle(fontSize: 32.0),
          ),
        ),
      ),
    );
  }
}
