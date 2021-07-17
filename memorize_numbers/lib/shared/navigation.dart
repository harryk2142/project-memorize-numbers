import 'package:flutter/material.dart';

class NaviButton extends StatelessWidget {
  final String text;
  final Widget target;

  final bool? enableBack;
  const NaviButton(this.text, this.target, {this.enableBack, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        width: 300,
        height: 64,
        child: ElevatedButton(
          onPressed: () {
            navigate(context);
          },
          child: Text(
            this.text,
            style: TextStyle(fontSize: 32.0),
          ),
        ),
      ),
    );
  }

  void navigate(BuildContext context) {
    bool isBackEnabled = enableBack ?? false;
    if (isBackEnabled) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => target));
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => target,
        ),
        (route) => false,
      );
    }
  }
}

class NaviBackButton extends StatelessWidget {
  final String text;

  const NaviBackButton(this.text, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        width: 300,
        height: 64,
        child: ElevatedButton(
          onPressed: () {
            navigateBack(context);
          },
          child: Text(
            this.text,
            style: TextStyle(fontSize: 32.0),
          ),
        ),
      ),
    );
  }

  navigateBack(BuildContext context) {
    Navigator.pop(context);
  }
}
