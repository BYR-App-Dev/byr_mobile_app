import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:byr_mobile_app/nforum/nforum_service.dart';
import 'package:byr_mobile_app/data_structures/image_file.dart';
import 'package:byr_mobile_app/helper/helper.dart';
import 'package:byr_mobile_app/local_objects/local_storage.dart';
import 'package:byr_mobile_app/shared_objects/shared_objects.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WelcomePageTasks {
  static Future<void> loadWelImg() async {
    NForumService.getWelcomeInfo().then((welcomeInfo) {
      var bytes1 = utf8.encode(welcomeInfo.url + "iosbyr#@!" + welcomeInfo.ver.toString());
      var digest1 = sha1.convert(bytes1);

      if (digest1.toString() == welcomeInfo.sign) {
        int welver = LocalStorage.getWelver();
        if (welver == -1 || welver != welcomeInfo.ver) {
          NForumService.getImage(welcomeInfo.url).then((imageInfo) {
            writeWelImg(imageInfo.bytes);
            LocalStorage.setWelver(welcomeInfo.ver);
          });
        }
      }
    });

    return readWelImg().then((welImg) {
      if (welImg.length > 0) {
        SharedObjects.welImage = MemoryImage(welImg);
      } else {
        SharedObjects.welImage = AssetImage(MediaQuery.of(Get.context).size.shortestSide > 600
            ? 'resources/welcome_page/ipad-2.jpg'
            : 'resources/welcome_page/bbs_ipxmax.png');
      }
      return SharedObjects.welImage;
    });
  }

  static Future<Uint8List> readWelImg() async {
    try {
      final file = await Helper.getLocalFile('welimg.jpg');
      Uint8List contents = await file.readAsBytes();
      SharedObjects.welImageInfo =
          ImageFile(bytes: contents, ext: file.path.substring(file.path.lastIndexOf('.') + 1), path: file.path);
      return contents;
    } catch (e) {
      return Uint8List.fromList([]);
    }
  }

  static Future<File> writeWelImg(Uint8List welImg) async {
    final file = await Helper.getLocalFile('welimg.jpg');
    return file.writeAsBytes(welImg);
  }
}
