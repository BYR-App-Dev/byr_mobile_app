import 'dart:convert';
import 'dart:math';

import 'package:byr_mobile_app/helper/helper.dart';
import 'package:byr_mobile_app/local_objects/local_storage.dart';
import 'package:byr_mobile_app/networking/http_request.dart';
import 'package:byr_mobile_app/reusable_components/aircon_summer_refresher.dart';
import 'package:byr_mobile_app/reusable_components/screenshot_footer.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'bupt_heart_beat_refresher.dart';
import 'custom_gif_refresher.dart';

export 'package:pull_to_refresh/pull_to_refresh.dart';

abstract class Refresher extends StatelessWidget {
  final RefreshController refreshController;
  final bool top;
  final bool bottom;
  final bool bottomScreenshot;
  final void Function() onTopRefresh;
  final void Function() onBottomRefresh;
  final Widget childWidget;
  Refresher(this.refreshController, this.top, this.bottom, this.onTopRefresh, this.onBottomRefresh, this.childWidget,
      {this.bottomScreenshot = false});
}

class AirconSummerRefresher extends Refresher {
  AirconSummerRefresher(RefreshController refreshController, bool top, bool bottom, void Function() onTopRefresh,
      void Function() onBottomRefresh, Widget childWidget, {bottomScreenshot = false})
      : super(refreshController, top, bottom, onTopRefresh, onBottomRefresh, childWidget,
            bottomScreenshot: bottomScreenshot);

  @override
  Widget build(BuildContext context) {
    return RefreshConfiguration(
      topHitBoundary: 0,
      bottomHitBoundary: 0,
      headerTriggerDistance: AirconSummerHeader.recommendedHeight,
      footerTriggerDistance:
          -(bottomScreenshot ? ScreenshotFooter.recommendedHeight : AirconSummerFooter.recommendedHeight) / 2,
      child: SmartRefresher(
        enablePullDown: top,
        enablePullUp: bottom,
        controller: refreshController,
        onRefresh: onTopRefresh,
        onLoading: onBottomRefresh,
        header: AirconSummerHeader(),
        footer: bottomScreenshot ? ScreenshotFooter() : AirconSummerFooter(),
        child: childWidget,
      ),
    );
  }
}

class BUPTHeartBeatRefresher extends Refresher {
  BUPTHeartBeatRefresher(RefreshController refreshController, bool top, bool bottom, void Function() onTopRefresh,
      void Function() onBottomRefresh, Widget childWidget, {bottomScreenshot = false})
      : super(refreshController, top, bottom, onTopRefresh, onBottomRefresh, childWidget,
            bottomScreenshot: bottomScreenshot);

  @override
  Widget build(BuildContext context) {
    return RefreshConfiguration(
      topHitBoundary: 0,
      bottomHitBoundary: 0,
      headerTriggerDistance: BUPTHeartBeatHeader.recommendedHeight,
      footerTriggerDistance:
          -(bottomScreenshot ? ScreenshotFooter.recommendedHeight : BUPTHeartBeatFooter.recommendedHeight) / 2,
      child: SmartRefresher(
        enablePullDown: top,
        enablePullUp: bottom,
        controller: refreshController,
        onRefresh: onTopRefresh,
        onLoading: onBottomRefresh,
        header: BUPTHeartBeatHeader(),
        footer: bottomScreenshot ? ScreenshotFooter() : BUPTHeartBeatFooter(),
        child: childWidget,
      ),
    );
  }
}

class CustomGifRefresher extends Refresher {
  CustomGifRefresher(
      this.topGif,
      this.bottomGif,
      RefreshController refreshController,
      bool top,
      bool bottom,
      void Function() onTopRefresh,
      void Function() onBottomRefresh,
      this.topFrameCount,
      this.bottomFrameCount,
      Widget childWidget,
      {bottomScreenshot = false})
      : super(refreshController, top, bottom, onTopRefresh, onBottomRefresh, childWidget,
            bottomScreenshot: bottomScreenshot);

  final String topGif;
  final String bottomGif;
  final int topFrameCount;
  final int bottomFrameCount;

  @override
  Widget build(BuildContext context) {
    return RefreshConfiguration(
      topHitBoundary: 0,
      bottomHitBoundary: 0,
      headerTriggerDistance: CustomGifHeader.recommendedHeight,
      footerTriggerDistance:
          -(bottomScreenshot ? ScreenshotFooter.recommendedHeight : CustomGifFooter.recommendedHeight) / 2,
      child: SmartRefresher(
        enablePullDown: top,
        enablePullUp: bottom,
        controller: refreshController,
        onRefresh: onTopRefresh,
        onLoading: onBottomRefresh,
        header: CustomGifHeader(topGif, topFrameCount),
        footer: bottomScreenshot ? ScreenshotFooter() : CustomGifFooter(bottomGif, bottomFrameCount),
        child: childWidget,
      ),
    );
  }
}

class RefresherFactory extends StatelessWidget {
  static int getFactor() {
    return Random().nextInt(100);
  }

  static int get count {
    return BYRRefresherManager.instance().refresherMap.entries.where((element) => element.value.enabled).length;
  }

  final RefreshController refreshController;
  final bool top;
  final bool bottom;
  final void Function() onTopRefresh;
  final void Function() onBottomRefresh;
  final Widget childWidget;
  final int factor;
  final bool bottomScreenshot;
  RefresherFactory(
    this.factor,
    this.refreshController,
    this.top,
    this.bottom,
    this.onTopRefresh,
    this.onBottomRefresh,
    this.childWidget, {
    this.bottomScreenshot = false,
  });

  @override
  Widget build(BuildContext context) {
    if (BYRRefresherManager.instance().refresherMap.entries.where((element) => element.value.enabled).length <= 0) {
      return BUPTHeartBeatRefresher(refreshController, top, bottom, onTopRefresh, onBottomRefresh, childWidget,
          bottomScreenshot: bottomScreenshot);
    }
    var refresher = BYRRefresherManager.instance().refresherMap[BYRRefresherManager.instance()
        .refresherMap
        .entries
        .where((element) => element.value.enabled)
        .toList()[factor % count]
        .key];
    if (refresher.refresherName == 'BUPTHeartBeat' || refresher.refresherName == 'AirconSummerBUPT') {
      switch (refresher.refresherName) {
        case "AirconSummerBUPT":
          return AirconSummerRefresher(refreshController, top, bottom, onTopRefresh, onBottomRefresh, childWidget,
              bottomScreenshot: bottomScreenshot);
        case "BUPTHeartBeat":
          return BUPTHeartBeatRefresher(refreshController, top, bottom, onTopRefresh, onBottomRefresh, childWidget,
              bottomScreenshot: bottomScreenshot);
        default:
          return BUPTHeartBeatRefresher(refreshController, top, bottom, onTopRefresh, onBottomRefresh, childWidget,
              bottomScreenshot: bottomScreenshot);
      }
    }
    return CustomGifRefresher(
      refresher.topGif,
      refresher.bottomGif,
      refreshController,
      top,
      bottom,
      onTopRefresh,
      onBottomRefresh,
      refresher.topFrameCount,
      refresher.bottomFrameCount,
      childWidget,
      bottomScreenshot: bottomScreenshot,
    );
  }
}

class CustomGifRefresherModel {
  final String refresherName;
  final String refresherDisplayName;
  bool enabled;
  final String topGif;
  final String bottomGif;
  final int topFrameCount;
  final int bottomFrameCount;
  CustomGifRefresherModel(this.refresherName, this.refresherDisplayName, this.topGif, this.bottomGif,
      this.topFrameCount, this.bottomFrameCount,
      {this.enabled = true});

  static CustomGifRefresherModel inputJson(Map<String, String> json, int topFrameCount, int bottomFrameCount,
      {bool enabled = true}) {
    return CustomGifRefresherModel(
      json["refresherName"] ?? null,
      json["refresherDisplayName"] ?? null,
      json["topGif"] ?? null,
      json["bottomGif"] ?? null,
      topFrameCount,
      bottomFrameCount,
      enabled: enabled,
    );
  }
}

class BYRRefresherManager {
  Map<String, CustomGifRefresherModel> refresherMap;

  static const int officialRefresherCount = 3;

  static BYRRefresherManager _singleton;

  static BYRRefresherManager instance() {
    if (BYRRefresherManager._singleton == null) {
      _singleton = BYRRefresherManager();
      return _singleton;
    } else {
      return _singleton;
    }
  }

  void mapAll() {
    refresherMap = Map<String, CustomGifRefresherModel>();

    List resultRefreshers = LocalStorage.getRefreshers();
    if (resultRefreshers == null || resultRefreshers.length == 0) {
      LocalStorage.setRefreshers(
        [
          {"loc": "", "refresherName": "BUPTHeartBeat", "enabled": "yes"},
          {"loc": "", "refresherName": "AirconSummerBUPT", "enabled": "yes"},
        ],
      );
    }
  }

  Future<void> mapLocal() async {
    List<Map> refreshers = LocalStorage.getRefreshers();
    for (int i = 0; i < refreshers.length; ++i) {
      if (refreshers[i]["refresherName"] == 'BUPTHeartBeat' || refreshers[i]["refresherName"] == 'AirconSummerBUPT') {
        switch (refreshers[i]["refresherName"]) {
          case "BUPTHeartBeat":
            refresherMap["BUPTHeartBeat"] = CustomGifRefresherModel("BUPTHeartBeat", "北邮心跳", "", "", 0, 0,
                enabled: refreshers[i]["enabled"] == "yes");
            break;
          case "AirconSummerBUPT":
            refresherMap["AirconSummerBUPT"] = CustomGifRefresherModel("AirconSummerBUPT", "有空调的北邮夏", "", "", 0, 0,
                enabled: refreshers[i]["enabled"] == "yes");
            break;
          default:
            refresherMap["BUPTHeartBeat"] = CustomGifRefresherModel("BUPTHeartBeat", "北邮心跳", "", "", 0, 0,
                enabled: refreshers[i]["enabled"] == "yes");
            break;
        }
      } else {
        await importLocalRefresher(refreshers[i]["loc"], null, refreshers[i]["enabled"] == "yes");
      }
    }
  }

  void enableRefresher(refresherName) {
    List<Map> refreshers = LocalStorage.getRefreshers();
    int i = refreshers.indexWhere((element) => element["refresherName"] == refresherName);
    if (i >= 0) {
      refreshers[i]["enabled"] = "yes";
    }
    LocalStorage.setRefreshers(refreshers);
    if (refresherMap[refresherName] != null) {
      refresherMap[refresherName].enabled = true;
    }
  }

  void disableRefresher(refresherName) {
    List<Map> refreshers = LocalStorage.getRefreshers();
    int i = refreshers.indexWhere((element) => element["refresherName"] == refresherName);
    if (i >= 0) {
      refreshers[i]["enabled"] = "no";
    }
    LocalStorage.setRefreshers(refreshers);
    if (refresherMap[refresherName] != null) {
      refresherMap[refresherName].enabled = false;
    }
  }

  Future<void> removeRefresher(refresherName) async {
    List<Map> refreshers = LocalStorage.getRefreshers();
    refreshers.removeWhere((element) => element["refresherName"] == refresherName);
    LocalStorage.setRefreshers(refreshers);
    BYRRefresherManager.instance().refresherMap.remove(refresherName);
  }

  Future<bool> importOnlineRefresher(refresherUrl, refresherParams) {
    return Request.httpGet(refresherUrl, refresherParams).then((response) {
      Map resultMap = jsonDecode(utf8.decode(response.bodyBytes));
      return PaintingBinding.instance
          .instantiateImageCodec(base64.decode(resultMap.cast<String, String>()["topGif"]).buffer.asUint8List())
          .then((codecTop) {
        return PaintingBinding.instance
            .instantiateImageCodec(base64.decode(resultMap.cast<String, String>()["bottomGif"]).buffer.asUint8List())
            .then((codecBottom) async {
          CustomGifRefresherModel refresher = CustomGifRefresherModel.inputJson(
              resultMap.cast<String, String>(), codecTop.frameCount, codecBottom.frameCount,
              enabled: true);
          if (refresher.refresherName == 'BUPTHeartBeat' ||
              refresher.refresherName == 'AirconSummerBUPT' ||
              refresher.refresherDisplayName == '北邮心跳' ||
              refresher.refresherDisplayName == '有空调的北邮夏') {
            return null;
          }
          if (refresherMap[refresher.refresherName] != null) {
            await removeRefresher(refresher.refresherName);
          }
          refresherMap[refresher.refresherName] = refresher;
          return resultMap;
        });
      });
    }).then((v) {
      if (v != null) {
        String ts = "refresher" + DateTime.now().millisecondsSinceEpoch.toString() + ".json";
        List<Map> refreshers = LocalStorage.getRefreshers();
        refreshers.add({"refresherName": v["refresherName"], "enabled": "yes", "loc": ts});
        LocalStorage.setRefreshers(refreshers);
        return exportLocalRefresher(ts, jsonEncode(v));
      } else {
        return false;
      }
    });
  }

  Future<String> readRefresher(refresherDir) async {
    try {
      final file = await Helper.getLocalFile(refresherDir);
      String contents = await file.readAsString();
      return contents;
    } catch (e) {
      return "";
    }
  }

  Future<bool> importLocalRefresher(refresherDir, refresherParams, bool enabled) {
    return readRefresher(refresherDir).then((jsonFile) {
      if (jsonFile.length > 0) {
        Map resultMap = jsonDecode(jsonFile);
        return PaintingBinding.instance
            .instantiateImageCodec(base64.decode(resultMap.cast<String, String>()["topGif"]).buffer.asUint8List())
            .then((codecTop) {
          return PaintingBinding.instance
              .instantiateImageCodec(base64.decode(resultMap.cast<String, String>()["bottomGif"]).buffer.asUint8List())
              .then((codecBottom) {
            CustomGifRefresherModel refresher = CustomGifRefresherModel.inputJson(
              resultMap.cast<String, String>(),
              codecTop.frameCount,
              codecBottom.frameCount,
              enabled: enabled,
            );
            if (refresher.refresherName == 'BUPTHeartBeat' ||
                refresher.refresherName == 'AirconSummerBUPT' ||
                refresher.refresherName == 'MemoryOfBUPT' ||
                refresher.refresherDisplayName == '北邮心跳' ||
                refresher.refresherDisplayName == '有空调的北邮夏') {
              return null;
            }
            refresherMap[refresher.refresherName] = refresher;
            return true;
          });
        });
      } else {
        return false;
      }
    });
  }

  Future<bool> exportLocalRefresher(refresherDir, content) async {
    final file = await Helper.getLocalFile(refresherDir);
    return file.writeAsString(content).then((v) {
      return true;
    });
  }
}
