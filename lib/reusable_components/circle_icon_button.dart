import 'package:flutter/material.dart';

class CircleIconButton extends StatelessWidget {
  final double size;
  final Function onPressed;
  final IconData icon;

  CircleIconButton({this.size = 30.0, this.icon = Icons.clear, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: this.onPressed,
        child: SizedBox(
            width: size,
            height: size,
            child: Stack(
              alignment: Alignment(0.0, 0.0),
              children: <Widget>[
                Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey[300]),
                ),
                Icon(
                  icon,
                  size: size * 0.6,
                )
              ],
            )));
  }
}
