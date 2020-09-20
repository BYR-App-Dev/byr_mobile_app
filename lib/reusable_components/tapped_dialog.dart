import 'package:byr_mobile_app/customizations/theme_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TappedDialog extends StatelessWidget {
  TappedDialog({
    this.timeToReach = 1,
    this.action,
    this.content,
  });
  final int timeToReach;
  final Function action;
  final Widget content;
  int times = 0;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      backgroundColor: E().mePageBackgroundColor,
      children: <Widget>[
        GestureDetector(
          onTap: () {
            times += 1;
            if (times < timeToReach) {
              return;
            }
            action();
          },
          child: content,
        ),
      ],
    );
  }
}
