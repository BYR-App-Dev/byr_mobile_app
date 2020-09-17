import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

class BoardBasicInfo {
  String name;
  String description;
  bool allowAttachment = true;
  bool allowAnonymous = false;
  bool isReadOnly = false;
  bool allowPost = true;

  BoardBasicInfo(
      {this.name, this.description, this.allowAttachment, this.allowAnonymous, this.isReadOnly, this.allowPost});

  BoardBasicInfo.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    description = json['description'];
    if (json['allow_attachment'] != null) {
      allowAttachment = json['allow_attachment'];
    }
    if (json['allow_anonymous'] != null) {
      allowAnonymous = json['allow_anonymous'];
    }
    if (json['is_read_only'] != null) {
      isReadOnly = json['is_read_only'];
    }
    if (json['allow_post'] != null) {
      allowPost = json['allow_post'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['name'] = this.name;
    data['description'] = this.description;
    data['allow_attachment'] = this.allowAttachment;
    data['allow_anonymous'] = this.allowAnonymous;
    data['is_read_only'] = this.isReadOnly;
    data['allow_post'] = this.allowPost;
    return data;
  }
}

class BoardAttInfo {
  static Map<String, BoardBasicInfo> _boardMap = Map<String, BoardBasicInfo>();

  static Future<void> load() async {
    return rootBundle.loadString('resources/board/boards_info.json').then((data) {
      var jsonMap = json.decode(data.toString());
      if (jsonMap['boards'] != null) {
        jsonMap['boards'].forEach((v) {
          BoardBasicInfo board = BoardBasicInfo.fromJson(v);
          _boardMap[board.name] = board;
        });
      }
    });
  }

  static bool allowAttachment(String name) {
    return _boardMap[name].allowAttachment;
  }

  static String desc(String name) {
    return _boardMap[name]?.description ?? "";
  }
}
