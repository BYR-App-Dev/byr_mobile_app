import 'dart:async';
import 'dart:io';

import 'package:byr_mobile_app/configurations/configurations.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class Helper {
  static Future<String> get localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<String> get externalPath async {
    if (Platform.isIOS) {
      return localPath;
    }
    final directory = await getExternalStorageDirectory();
    return directory.path;
  }

  static Future<Directory> makeDownloadDirectory() async {
    return Directory(await externalPath + AppConfigs.relativeDownloadPath).create(recursive: true);
  }

  static Future<File> getLocalFile(String fileName) async {
    final path = await localPath;
    return File('$path/' + fileName);
  }

  static Future<File> getExternalFile(String fileName) async {
    final path = await externalPath;
    return File('$path/' + fileName);
  }

  static String convTimestampToRelative(int timestamp) {
    var now = DateTime.now();
    var today = DateTime(now.year, now.month, now.day, 23, 59, 59, 999, 999);
    var format = DateFormat.Hm();
    var ymdFormat = DateFormat("yyyy-MM-dd");
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    var diff = today.difference(date);
    var time = '';

    if (diff.inSeconds <= 0 ||
        diff.inSeconds > 0 && diff.inMinutes == 0 ||
        diff.inMinutes > 0 && diff.inHours == 0 ||
        diff.inHours > 0 && diff.inDays == 0) {
      time = "timeTodayTrans".trArgs([format.format(date)]);
    } else {
      if (diff.inDays == 1) {
        time = "timeYesterdayTrans".trArgs([format.format(date)]);
      } else {
        time = ymdFormat.format(date);
      }
    }

    return time;
  }

  static String convTimestampToRelativeIncludingSeconds(int timestamp) {
    var now = DateTime.now();
    var today = DateTime(now.year, now.month, now.day, 23, 59, 59, 999, 999);
    var format = DateFormat.Hms();
    var ymdFormat = DateFormat("yyyy-MM-dd");
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    var diff = today.difference(date);
    var time = '';

    if (diff.inSeconds <= 0 ||
        diff.inSeconds > 0 && diff.inMinutes == 0 ||
        diff.inMinutes > 0 && diff.inHours == 0 ||
        diff.inHours > 0 && diff.inDays == 0) {
      time = "timeTodayTrans".trArgs([format.format(date)]);
    } else {
      if (diff.inDays == 1) {
        time = "timeYesterdayTrans".trArgs([format.format(date)]);
      } else {
        time = ymdFormat.format(date);
      }
    }

    return time;
  }
}

TValue widgetCase<TOptionType, TValue>(
  TOptionType selectedOption,
  Map<TOptionType, TValue> branches, [
  TValue defaultValue,
]) {
  if (!branches.containsKey(selectedOption)) {
    return defaultValue;
  }

  return branches[selectedOption];
}
