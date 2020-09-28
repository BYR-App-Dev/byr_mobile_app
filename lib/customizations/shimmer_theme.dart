import 'package:byr_mobile_app/customizations/theme_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerTheme extends StatelessWidget {
  final Widget child;

  const ShimmerTheme({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: E().isThemeDarkStyle ? Colors.grey[800] : Colors.grey[300],
      highlightColor: E().isThemeDarkStyle ? Colors.grey[600] : Colors.grey[100],
      enabled: true,
      child: child,
    );
  }
}
