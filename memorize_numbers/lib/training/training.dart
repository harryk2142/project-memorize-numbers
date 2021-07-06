import 'package:flutter/material.dart';
import 'package:memorize_numbers/gamefield/gamefield.dart';
import 'package:memorize_numbers/shared/navigation.dart';

class TrainingPage extends StatefulWidget {
  const TrainingPage({Key? key}) : super(key: key);

  @override
  _TrainingPageState createState() => _TrainingPageState();
}

class _TrainingPageState extends State<TrainingPage> {
  int _rounds = 1;
  int _digits = 5;
  double _displayTime = 2.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('Training'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Center(),
          Column(
            children: [
              CustomDivider(),
              Slider(
                value: _rounds.toDouble(),
                min: 1,
                max: 10,
                activeColor: Colors.green,
                divisions: 10,
                onChanged: (double value) {
                  setState(() {
                    _rounds = value.toInt();
                  });
                },
              ),
              Text(
                'Runden: $_rounds',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              CustomDivider(),
              Slider(
                value: _digits.toDouble(),
                min: 1,
                max: 10,
                activeColor: Colors.green,
                divisions: 10,
                onChanged: (double value) {
                  setState(() {
                    _digits = value.toInt();
                  });
                },
              ),
              Text(
                'Ziffern: $_digits',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              CustomDivider(),
              Slider(
                value: _displayTime,
                min: 0.5,
                max: 6,
                activeColor: Colors.green,
                divisions: 11,
                onChanged: (double value) {
                  setState(() {
                    _displayTime = value;
                  });
                },
              ),
              Text(
                'Sekunden: $_displayTime',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              CustomDivider(),
            ],
          ),
          Column(
            children: [
              NavigationButton('Start', navigateToGame),
              NavigationButton('Zurück', navigateBack)
            ],
          )
        ],
      ),
    );
  }

  navigateToGame(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => GameField(_rounds, _digits, _displayTime)));
  }

  navigateBack(BuildContext context) {
    Navigator.pop(context);
  }
}

class CustomDivider extends StatelessWidget {
  const CustomDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Divider(
      thickness: 2.0,
      color: Colors.green,
    );
  }
}
