import 'dart:io';

import 'package:byr_mobile_app/nforum/nforum_service.dart';
import 'package:byr_mobile_app/nforum/nforum_structures.dart';
import 'package:characters/characters.dart';
import 'package:fast_gbk/fast_gbk.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NForumTextParser {
  static RegExp bbPattern = RegExp(r'\[(.+?)(=.*?)?\]((?:.|[\n\r])*?)\[\/\1\]');
  static RegExp emPattern = RegExp(r'\[(em.*?)\]');
  static RegExp byrPattern = RegExp(r"(?:http(s)?:\/\/)(bbs(6?)|m)\.byr\.cn\/\S+");
  static RegExp byrStartPattern = RegExp(r"^(?:http(s)?:\/\/)(bbs(6?)|m)\.byr\.cn\/.+$");
  static RegExp urlPattern = RegExp(r"(?:http(s)?:\/\/)[\w-]+(?:\.[\w-]+)+[\w\-\._~:/?#[\]@!\$&'`\*\+%,;=.]+");
  static RegExp threadPattern = RegExp(r'article\/(\w+)\/(\d+)');
  static RegExp betPattern = RegExp(r'bet\/view\/(\d+)');
  static RegExp votePattern = RegExp(r'vote\/view\/(\d+)');
  static RegExp boardPattern = RegExp(r'board\/(\w+)\/*$');
  static RegExp emojiPattern = RegExp(r'\[bbsemoji([0-9|,]*?)\]');
  static RegExp quotePattern = RegExp(r'【 ?在.*的大作中提到: ?】 ?(\n:.*)*');

  static String stripText(String str) {
    var strs = str;
    var bb = [
      r'\/?b',
      r'\/?i',
      r'\/?u',
      r'size=.*?',
      r'\/size',
      r'color=.*?',
      r'\/color',
      r'\/?md',
      r'em.*?',
      r'upload=.*?',
      r'\/upload',
    ];

    RegExp rg = RegExp(r'\[(.*?)\]');

    var rgm = rg.firstMatch(strs);

    if (rgm != null && rgm.group(1) != null) {
      for (final b in bb) {
        var rgmm = RegExp(b).firstMatch(rgm.group(1));
        if (rgmm != null) {
          return strs.substring(0, rgm.start) + stripText(strs.substring(rgm.end));
        }
      }
      return strs.substring(0, rgm.end) + stripText(strs.substring(rgm.end));
    }
    return strs;
  }

  static String stripEmojis(String str) {
    String joinedEmoji = Characters(str).map((subs) {
      if (subs.length > 1) {
        return '[bbsemoji' + subs.codeUnits.join(',') + ']';
      } else {
        if (gbk.decode(gbk.encode(subs)).runes.first == 59315) {
          return '[bbsemoji' + subs.codeUnits.join(',') + ']';
        }
        return subs;
      }
    }).join('');

    return joinedEmoji;
  }

  static retrieveEmojis(String str) {
    return String.fromCharCodes(str.replaceAllMapped(emojiPattern, (match) {
      return String.fromCharCodes(match.group(1).split(',').map((emojiCode) {
        return int.parse(emojiCode);
      }));
    }).codeUnits);
  }

  static List<String> getImageURLs(AttachmentModel attachmentModel) {
    List<String> imageUrls = [];
    for (UploadedModel uploadedModel in attachmentModel.file) {
      if (uploadedModel.thumbnailMiddle != null) {
        imageUrls.add(
          uploadedModel.thumbnailMiddle,
        );
      }
    }
    return imageUrls;
  }

  static String getArticlePositionName(int position) {
    switch (position) {
      case 0:
        return "positionTransAuthor".tr;
      case 1:
        return "positionTrans1".tr;
      case 2:
        return "positionTrans2".tr;
      default:
        return "positionTransFallback".tr.trArgs([position.toString()]);
    }
  }

  static String computeEmojiStr(String str) {
    return str.replaceAllMapped(emojiPattern, (match) {
      return String.fromCharCodes(match.group(1).split(',').map((emojiCode) {
        return int.parse(emojiCode);
      }));
    });
  }

  static String makeReplyQuote(String username, String s) {
    String t = removeBBSQuote(s);
    String ttt = (t.length > 180 ? t.substring(0, t.indexOf('\n', 180)) : t);
    String tttt = ttt.length < 250 ? ttt : ttt.substring(0, ttt.lastIndexOf('\n'));
    tttt = tttt.length > 250 ? tttt.substring(0, 250) : tttt;
    return "\n【 在 " +
        username +
        " 的大作中提到: 】\n: " +
        (tttt + '\n............')
            .replaceAll(RegExp(r'\n+'), '\n')
            .replaceAll(RegExp(r'\n$'), '')
            .replaceAll('\n', '\n: ');
  }

  static String removeBBSQuote(String s) {
    int index = s.indexOf(RegExp(r'【\s?在.*的大作中提到:\s?】'));
    return index == -1 ? s : s.substring(0, index);
  }

  static String getEnumValue(dynamic t) {
    return t.toString().split('.').last;
  }

  static String getStrippedEnumValue(dynamic t) {
    return getEnumValue(t).split('_').last;
  }
}

class PreviewUpload {
  final String path;
  final int type;
  bool used;
  PreviewUpload(this.path, this.type, {this.used = false});
}

abstract class UploadedExtractor<T> {
  ImageProvider getProvider(T upload);
  bool getIsGroupShowable(T upload);
  bool getIsImage(T upload);
  bool getIsAudio(T upload);
  bool getIsTheme(T upload);
  bool getIsRefresher(T upload);
  String getAudioLoc(T upload);
  bool getIsAudioLocal(T upload);
  String getImgThumbnail(T upload);
  String getShowUrl(T upload);
  bool getIsPreview(T upload);
  bool getIsUsed(T upload);
  String getFileName(T upload);
  void setIsUsed(T upload, bool afterValue);
}

class PreviewUploadedExtractor extends UploadedExtractor<PreviewUpload> {
  @override
  ImageProvider getProvider(PreviewUpload upload) {
    String imagePath = upload.path;
    ImageProvider imageProvider;
    if (imagePath.contains('file://')) {
      final file = File.fromUri(Uri.parse(imagePath));
      imageProvider = FileImage(file);
    } else {
      imageProvider = NetworkImage(imagePath);
    }
    return imageProvider;
  }

  @override
  bool getIsGroupShowable(PreviewUpload upload) {
    return false;
  }

  @override
  bool getIsImage(PreviewUpload upload) {
    return upload.type == 1;
  }

  @override
  String getShowUrl(PreviewUpload upload) {
    return upload.path;
  }

  @override
  bool getIsUsed(PreviewUpload upload) {
    return upload.used;
  }

  @override
  void setIsUsed(PreviewUpload upload, bool afterValue) {
    upload.used = afterValue;
  }

  @override
  bool getIsAudio(PreviewUpload upload) {
    return upload.type == 2;
  }

  @override
  String getAudioLoc(PreviewUpload upload) {
    return upload.path;
  }

  @override
  bool getIsAudioLocal(PreviewUpload upload) {
    String path = upload.path;
    if (path.contains('file://')) {
      return true;
    } else {
      return false;
    }
  }

  @override
  bool getIsPreview(PreviewUpload upload) {
    return true;
  }

  @override
  String getImgThumbnail(PreviewUpload upload) {
    return upload.path;
  }

  @override
  bool getIsTheme(PreviewUpload upload) {
    String path = upload.path;
    if (path.contains('file://') && path.endsWith('.byrapptheme')) {
      return true;
    } else {
      return false;
    }
  }

  @override
  String getFileName(PreviewUpload upload) {
    return " ";
  }

  @override
  bool getIsRefresher(PreviewUpload upload) {
    String path = upload.path;
    if (path.contains('file://') && path.endsWith('.byrapprefresher')) {
      return true;
    } else {
      return false;
    }
  }
}

class UploadedModelUploadedExtractor extends UploadedExtractor<UploadedModel> {
  @override
  ImageProvider getProvider(UploadedModel upload) {
    if (upload.thumbnailMiddle == "") {
      return null;
    } else {
      String _curPicUrl = NForumService.makeGetAttachmentURL(upload.url);
      return NetworkImage(_curPicUrl);
    }
  }

  @override
  bool getIsGroupShowable(UploadedModel upload) {
    if (upload.thumbnailMiddle == "") {
      return false;
    } else {
      return true;
    }
  }

  @override
  bool getIsImage(UploadedModel upload) {
    if (upload.thumbnailMiddle == "") {
      return false;
    } else {
      return true;
    }
  }

  @override
  String getShowUrl(UploadedModel upload) {
    return NForumService.makeGetAttachmentURL(upload.url);
  }

  @override
  bool getIsUsed(UploadedModel upload) {
    return upload.used;
  }

  @override
  void setIsUsed(UploadedModel upload, bool afterValue) {
    upload.used = afterValue;
  }

  @override
  bool getIsAudio(UploadedModel upload) {
    return upload.name.length > 4 &&
        (upload.name.endsWith(".mp3") || upload.name.endsWith(".m4a") || upload.name.endsWith(".aac"));
  }

  @override
  String getAudioLoc(UploadedModel upload) {
    return NForumService.makeGetAttachmentURL(upload.url);
  }

  @override
  bool getIsAudioLocal(UploadedModel upload) {
    return false;
  }

  @override
  bool getIsPreview(UploadedModel upload) {
    return false;
  }

  @override
  String getImgThumbnail(UploadedModel upload) {
    return NForumService.makeGetAttachmentURL(upload.thumbnailMiddle);
  }

  @override
  bool getIsTheme(UploadedModel upload) {
    return upload.name.endsWith(".byrapptheme");
  }

  @override
  bool getIsRefresher(UploadedModel upload) {
    return upload.name.endsWith(".byrapprefresher");
  }

  @override
  String getFileName(UploadedModel upload) {
    return upload.name ?? " ";
  }
}
