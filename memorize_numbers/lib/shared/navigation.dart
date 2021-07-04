import 'package:flutter/material.dart';

class NavigationButton extends StatelessWidget {
  final String text;
  final Function(BuildContext context) onClickAction;
  const NavigationButton(this.text, this.onClickAction, {Key? key})
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
            onClickAction(context);
          },
          child: Text(
            this.text,
            style: TextStyle(fontSize: 32.0),
          ),
        ),
      ),
    );
  }
}
