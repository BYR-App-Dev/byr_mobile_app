import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:byr_mobile_app/configurations/configurations.dart';
import 'package:flutter/cupertino.dart';
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

  static Color colorFromString(String s) {
    return Color(
      int.tryParse(s ?? "") ?? 0,
    );
  }

  static MainAxisAlignment mainAxisAlignmentFromString(String s) {
    switch (s) {
      case "start":
        return MainAxisAlignment.start;
      case "center":
        return MainAxisAlignment.center;
      case "end":
        return MainAxisAlignment.end;
      case "spaceAround":
        return MainAxisAlignment.spaceAround;
      case "spaceBetween":
        return MainAxisAlignment.spaceBetween;
      case "spaceEvenly":
        return MainAxisAlignment.spaceEvenly;
      default:
        return MainAxisAlignment.start;
    }
  }

  static CrossAxisAlignment crossAxisAlignmentFromString(String s) {
    switch (s) {
      case "start":
        return CrossAxisAlignment.start;
      case "center":
        return CrossAxisAlignment.center;
      case "end":
        return CrossAxisAlignment.end;
      case "stretch":
        return CrossAxisAlignment.stretch;
      case "baseline":
        return CrossAxisAlignment.baseline;
      default:
        return CrossAxisAlignment.center;
    }
  }

  static MainAxisSize mainAxisSizeFromString(String s) {
    switch (s) {
      case "min":
        return MainAxisSize.min;
      case "max":
        return MainAxisSize.max;
      default:
        return MainAxisSize.min;
    }
  }

  static AlignmentGeometry alignmentGeometryFromString(String s) {
    switch (s) {
      case "center":
        return Alignment.center;
      case "topLeft":
        return Alignment.topLeft;
      case "topCenter":
        return Alignment.topCenter;
      case "topRight":
        return Alignment.topRight;
      case "centerLeft":
        return Alignment.centerLeft;
      case "centerRight":
        return Alignment.centerRight;
      case "bottomLeft":
        return Alignment.bottomLeft;
      case "bottomCenter":
        return Alignment.bottomCenter;
      case "bottomRight":
        return Alignment.bottomRight;
      default:
        return Alignment.center;
    }
  }

  static TextAlign textAlignFromString(String s) {
    switch (s) {
      case "center":
        return TextAlign.center;
      case "left":
        return TextAlign.left;
      case "right":
        return TextAlign.right;
      case "justify":
        return TextAlign.justify;
      case "start":
        return TextAlign.start;
      case "end":
        return TextAlign.end;
      default:
        return TextAlign.start;
    }
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
