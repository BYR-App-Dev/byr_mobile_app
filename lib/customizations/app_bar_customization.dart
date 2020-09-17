import 'package:byr_mobile_app/local_objects/local_storage.dart';

class AppBarCustomization {
  static String getAppBarStyle() {
    return LocalStorage.getAppBarStyle() ?? '100';
  }

  static void saveAppBarStyle(String style) {
    LocalStorage.setAppBarStyle(style);
  }

  static bool appBarIsColorfulBg() {
    String style = getAppBarStyle();
    return style[2] == '1';
  }

  static bool appBarIsColorfulTitle() {
    String style = getAppBarStyle();
    return style[1] == '1';
  }
}
