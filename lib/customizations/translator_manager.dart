import 'package:byr_mobile_app/customizations/translation.dart';
import 'package:byr_mobile_app/local_objects/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BYRTranslatorManager {
  static void turnTranslator(String translatorName) {
    if (Translation.localeNames[translatorName] != null) {
      Get.updateLocale(Locale(translatorName));
      LocalStorage.setLocale(translatorName);
    }
  }
}
