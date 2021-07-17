import 'package:flutter/material.dart';
import 'package:memorize_numbers/gamefield/gamefield.dart';
import 'package:memorize_numbers/shared/navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  void initState() {
    super.initState();
    loadSettings();
  }

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
                  updateSettings();
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
                  updateSettings();
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
                  updateSettings();
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
              NaviButton(
                'Start',
                Gamefield(this._rounds, this._digits, this._displayTime),
                enableBack: false,
              ),
              NaviBackButton('Zurück')
            ],
          )
        ],
      ),
    );
  }

  void loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('settings.training.rounds')) {
      prefs.setInt('settings.training.rounds', _rounds);
    } else {
      int rounds = prefs.getInt('settings.training.rounds') ?? _rounds;
      setState(() {
        _rounds = rounds;
      });
    }
    if (!prefs.containsKey('settings.training.digits')) {
      prefs.setInt('settings.training.digits', _digits);
    } else {
      int digits = prefs.getInt('settings.training.digits') ?? _digits;
      setState(() {
        _digits = digits;
      });
    }
    if (!prefs.containsKey('settings.training.displayTime')) {
      prefs.setDouble('settings.training.displayTime', _displayTime);
    } else {
      double displayTime =
          prefs.getDouble('settings.training.displayTime') ?? _displayTime;
      setState(() {
        _displayTime = displayTime;
      });
    }
    print('first values saved');
  }

  void updateSettings() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('settings.training.rounds', _rounds);

    prefs.setInt('settings.training.digits', _digits);

    prefs.setDouble('settings.training.displayTime', _displayTime);
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
