import 'dart:convert';

import 'package:byr_mobile_app/customizations/theme_controller.dart';
import 'package:byr_mobile_app/nforum/nforum_service.dart';
import 'package:byr_mobile_app/nforum/nforum_structures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:get/get.dart';
import 'package:tinycolor/tinycolor.dart';

class BoardInfo {
  static List<Color> colors = [
    Color(0xffff2c40),
    Color(0xfff66395),
    Color(0xffc363d3),
    Color(0xff339ef4),
    Color(0xff41c0f9),
    Color(0xff00bcd4),
    Color(0xff00a293),
    Color(0xff4caf50),
    Color(0xff8bc34a),
    Color(0xffcddc39),
    Color(0xfff6be1a),
    Color(0xff90a4ae),
    Color(0xffa1887f),
  ];

  static Map<String, List<dynamic>> boardColorMap;

  static Future<void> load() async {
    boardColorMap = Map<String, List<dynamic>>();
    return rootBundle.loadString('resources/board/boards_list.json').then((j) {
      for (Map i in json.decode(j)['board']) {
        boardColorMap.putIfAbsent(i['name'], () => [int.parse(i['color']), i['name_cn_short'], i['name_cn']]);
      }
    });
  }

  static Color getBoardIconColor(name) {
    return getBoardColor(name);
  }

  static Color getBoardColor(name) {
    Color _c = boardColorMap[name] == null ? Colors.blueGrey : colors[boardColorMap[name][0] % colors.length];
    return E().isThemeDarkStyle ? _c.darken(15) : _c;
  }

  static String getBoardCnShort(name, desc) {
    return boardColorMap[name] == null ? desc[0].toUpperCase() : boardColorMap[name][1];
  }

  static String getBoardDesc(name) {
    return boardColorMap[name] == null ? "boardTrans".tr : boardColorMap[name][2];
  }
}

extension BoardModelInfoExtension on BoardModel {
  String getBoardCnShort() {
    return BoardInfo.boardColorMap[name] == null ? description[0].toUpperCase() : BoardInfo.boardColorMap[name][1];
  }

  bool addFavorite() {
    NForumService.addFavBoard(name);
    return true;
  }

  bool delFavorite() {
    NForumService.delFavBoard(name);
    return true;
  }
}
