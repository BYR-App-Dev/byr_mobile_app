import 'package:byr_mobile_app/customizations/theme.dart';
import 'package:get/get.dart';

BYRTheme E() {
  return Get.find<ThemeController>().theme();
}

class ThemeController extends GetxController {
  Rx<BYRTheme> currentTheme = BYRTheme.originLightTheme.obs;

  get theme => currentTheme;

  static turnTheme(BYRTheme theme) {
    Get.find<ThemeController>().theme.value = theme;
  }
}
