import 'package:byr_mobile_app/customizations/theme_controller.dart';
import 'package:byr_mobile_app/reusable_components/refreshers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class ScreenshotFooter extends LoadIndicator {
  final VoidCallback onClick;
  ScreenshotFooter({this.onClick})
      : super(onClick: onClick, loadStyle: LoadStyle.ShowWhenLoading, height: recommendedHeight);

  static double recommendedHeight = 55;

  @override
  State<StatefulWidget> createState() {
    return _ScreenshotFooterState();
  }
}

class _ScreenshotFooterState extends LoadIndicatorState<ScreenshotFooter> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Future<void> endLoading() {
    return super.endLoading();
  }

  @override
  Future<void> readyToLoad() {
    return super.readyToLoad();
  }

  @override
  void resetValue() {
    super.resetValue();
  }

  @override
  Widget buildContent(BuildContext context, LoadStatus mode) {
    Widget body;
    if (mode == LoadStatus.idle) {
      body = Text(
        "pullUpToScreenshot".tr,
        style: TextStyle(
          color: E().threadListOtherTextColor,
        ),
      );
    } else if (mode == LoadStatus.loading) {
      body = Theme(
          data: ThemeData(
              cupertinoOverrideTheme: CupertinoThemeData(
            brightness: !E().isThemeDarkStyle ? Brightness.light : Brightness.dark,
          )),
          child: CupertinoActivityIndicator());
    } else if (mode == LoadStatus.canLoading) {
      body = Text(
        "releaseToScreenshot".tr,
        style: TextStyle(
          color: E().threadListOtherTextColor,
        ),
      );
    } else if (mode == LoadStatus.failed) {
      body = Text(
        "screenshotFailed".tr,
        style: TextStyle(
          color: E().threadListOtherTextColor,
        ),
      );
    } else {
      body = Text("");
    }
    return Container(
      height: 55.0,
      child: Center(child: body),
    );
  }
}
