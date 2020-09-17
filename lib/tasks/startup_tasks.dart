import 'package:byr_mobile_app/configurations/configurations.dart';
import 'package:byr_mobile_app/customizations/board_info.dart';
import 'package:byr_mobile_app/customizations/theme.dart';
import 'package:byr_mobile_app/customizations/theme_controller.dart';
import 'package:byr_mobile_app/helper/helper.dart';
import 'package:byr_mobile_app/local_objects/local_storage.dart';
import 'package:byr_mobile_app/nforum/board_att_info.dart';
import 'package:byr_mobile_app/nforum/nforum_service.dart';
import 'package:byr_mobile_app/pages/message_page.dart';
import 'package:byr_mobile_app/reusable_components/refreshers.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class StartupTasks {
  static Future<void> makeDownloadDirectory() async {
    await Helper.makeDownloadDirectory();
  }

  static Future<void> initializeLocalStorage() async {
    await LocalStorage.initialization();
  }

  static Future<void> clearLocalStorage() async {
    await LocalStorage.clear();
  }

  static void initializeAppConfigs() {
    AppConfigs.initializeAppConfigs();
  }

  static void initializeLocale() {
    String localeStr = LocalStorage.getLocale();
    if (localeStr.length > 0) {
      List<String> localeStrSplit = localeStr.split('_');
      Get.updateLocale(Locale(localeStrSplit[0], localeStrSplit.length > 1 ? localeStrSplit[1] : null));
    }
  }

  static Future<void> initializeMessage() async {
    Get.put(MessageController());
  }

  static Future<void> initializeTheme() async {
    Get.put(ThemeController());
    BYRThemeManager.instance().mapAll();
    await BYRThemeManager.instance().mapLocal();
  }

  static Future<void> initializeRefresher() async {
    BYRRefresherManager.instance().mapAll();
    await BYRRefresherManager.instance().mapLocal();
  }

  static Future<void> initializeNForumLocalData() async {
    NForumSpecs.initializeNForumSpecs();
    NForumService.loadCurrentToken();
    await NForumService.loadMe().catchError((_) {});
  }

  static Future<void> startupAll() async {
    await initializeLocalStorage();
    await makeDownloadDirectory();
    initializeAppConfigs();
    initializeLocale();
    await initializeTheme();
    await initializeRefresher();
    await initializeNForumLocalData();
    await BoardInfo.load();
    await BoardAttInfo.load();
    initializeMessage();
  }
}
