import 'dart:convert';
import 'dart:ui';

import 'package:byr_mobile_app/customizations/theme_controller.dart';
import 'package:byr_mobile_app/helper/helper.dart';
import 'package:byr_mobile_app/local_objects/local_storage.dart';
import 'package:byr_mobile_app/networking/http_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'theme.dart';

export 'theme.dart';

class BYRThemeManager {
  static BYRThemeManager _singleton;

  static BYRThemeManager instance() {
    if (BYRThemeManager._singleton == null) {
      _singleton = BYRThemeManager();
      return _singleton;
    } else {
      return _singleton;
    }
  }

  BYRTheme currentTheme;

  Map<String, BYRTheme> themeMap;

  void mapAll() {
    themeMap = Map<String, BYRTheme>();

    BYRTheme aLightTheme = BYRTheme.generate(
      themeName: 'Light Theme',
      themeDisplayName: '🌞',
    );
    aLightTheme.fillBy(BYRTheme.originLightTheme);
    themeMap[aLightTheme.themeName] = aLightTheme;

    BYRTheme aDarkTheme = BYRTheme.generate(
      themeName: 'Dark Theme',
      themeDisplayName: '🌙',
    );
    aDarkTheme.fillBy(BYRTheme.originDarkTheme);
    themeMap[aDarkTheme.themeName] = aDarkTheme;

    currentTheme = themeMap["Light Theme"];
  }

  Future<void> mapLocal() async {
    Map<String, String> tss = LocalStorage.getLocalThemes();
    if (tss != null) {
      for (final ts in tss.entries) {
        await importLocalTheme(ts.value, null, BYRTheme.originLightTheme);
      }
    }
    BYRThemeManager.instance().turnTheme(LocalStorage.getCurrentTheme());
  }

  Future<void> removeTheme(themeName) async {
    if (themeName == currentTheme.themeName) {
      BYRThemeManager.instance().setAutoSwitchDarkModeOn();
      BYRThemeManager.instance().turnTheme('Light Theme');
    }
    Map<String, String> tss = LocalStorage.getLocalThemes();
    if (tss[themeName] != null) {
      final file = await Helper.getLocalFile(tss[themeName]);
      file.delete();
      tss.remove(themeName);
    }
    await LocalStorage.setLocalThemes(tss);
    BYRThemeManager.instance().themeMap.remove(themeName);
  }

  Future<bool> importOnlineTheme(themeUrl, themeParams, baseTheme) {
    return Request.httpGet(themeUrl, themeParams).then((response) async {
      Map resultMap = jsonDecode(utf8.decode(response.bodyBytes));
      BYRTheme anOnlineTheme = BYRTheme.generate(
        themeName: themeUrl + resultMap['themeName'],
        themeDisplayName: resultMap['themeDisplayName'],
      );
      BYRTheme jsonTheme = BYRTheme.inputJson(resultMap);
      if (jsonTheme.themeName == 'Dark Theme' ||
          jsonTheme.themeName == 'Light Theme' ||
          jsonTheme.themeDisplayName == '🌞' ||
          jsonTheme.themeDisplayName == '🌙') {
        return null;
      }
      anOnlineTheme.fillBy(baseTheme);
      anOnlineTheme.replaceBy(jsonTheme);
      if (themeMap[anOnlineTheme.themeName] != null) {
        await removeTheme(anOnlineTheme.themeName);
      }
      themeMap[anOnlineTheme.themeName] = anOnlineTheme;
      resultMap["themeName"] = anOnlineTheme.themeName;
      resultMap["themeDisplayName"] = anOnlineTheme.themeDisplayName;
      return resultMap;
    }).then((v) async {
      if (v != null) {
        String ts = "theme" + DateTime.now().millisecondsSinceEpoch.toString() + ".json";
        Map<String, String> tss = LocalStorage.getLocalThemes();
        if (tss[v["themeName"]] != null) {
          final file = await Helper.getLocalFile(tss[v["themeName"]]);
          file.delete();
        }
        tss[v["themeName"]] = ts;
        await LocalStorage.setLocalThemes(tss);
        return exportLocalTheme(ts, jsonEncode(v));
      } else {
        return false;
      }
    });
  }

  Future<String> readTheme(themeDir) async {
    try {
      final file = await Helper.getLocalFile(themeDir);
      String contents = await file.readAsString();
      return contents;
    } catch (e) {
      return "";
    }
  }

  Future<bool> importLocalTheme(themeDir, themeParams, baseTheme) {
    return readTheme(themeDir).then((jsonFile) {
      if (jsonFile.length > 0) {
        Map resultMap = jsonDecode(jsonFile);
        BYRTheme anOnlineTheme = BYRTheme.generate(
          themeName: resultMap['themeName'],
          themeDisplayName: resultMap['themeDisplayName'],
        );
        BYRTheme jsonTheme = BYRTheme.inputJson(resultMap);
        if (jsonTheme.themeName == 'Dark Theme' ||
            jsonTheme.themeName == 'Light Theme' ||
            jsonTheme.themeDisplayName == '🌞' ||
            jsonTheme.themeDisplayName == '🌙') {
          return false;
        }
        anOnlineTheme.fillBy(baseTheme);
        anOnlineTheme.replaceBy(jsonTheme);
        themeMap[anOnlineTheme.themeName] = anOnlineTheme;
        return true;
      } else {
        return false;
      }
    });
  }

  Future<bool> exportLocalTheme(themeDir, content) async {
    final file = await Helper.getLocalFile(themeDir);
    return file.writeAsString(content).then((v) {
      return true;
    });
  }

  Future<void> autoSwitchDarkMode(Brightness brightness) async {
    if (brightness == Brightness.light && currentTheme.themeName != "Light Theme") {
      await turnTheme('Light Theme');
    } else if (brightness == Brightness.dark && currentTheme.themeName != "Dark Theme") {
      await turnTheme('Dark Theme');
    }
    setAutoSwitchDarkModeOn();
  }

  bool getIsAutoSwitchDarkModel() {
    return LocalStorage.getIsAutoTheme() ?? false;
  }

  Future<void> setAutoSwitchDarkModeOn() async {
    await LocalStorage.setIsAutoTheme(true);
  }

  Future<void> setAutoSwitchDarkModeOff() async {
    await LocalStorage.setIsAutoTheme(false);
  }

  Future<void> turnTheme(String themeName) async {
    if (themeMap[themeName] != null) {
      currentTheme = themeMap[themeName];
      await LocalStorage.setCurrentTheme(themeName);
      ThemeController.turnTheme(themeMap[themeName]);
      updateNonWidgetParts();
    }
  }

  void updateNonWidgetParts() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: currentTheme.statusBarColor,
        systemNavigationBarColor: currentTheme.systemBottomNavigationBarColor,
        systemNavigationBarIconBrightness: !currentTheme.isThemeDarkStyle ? Brightness.dark : Brightness.light,
      ),
    );
  }
}
