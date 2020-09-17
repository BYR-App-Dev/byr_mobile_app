import 'dart:ui';

import 'package:byr_mobile_app/customizations/theme_controller.dart';

class ConstColors {
  static Color getUsernameColor(String gender) {
    return gender == null
        ? E().otherUserIdColor
        : (gender == 'f' ? E().femaleUserIdColor : (gender == 'm' ? E().maleUserIdColor : E().otherUserIdColor));
  }
}
