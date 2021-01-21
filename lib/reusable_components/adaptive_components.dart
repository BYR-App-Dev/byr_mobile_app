import 'dart:io';
import 'package:byr_mobile_app/customizations/theme_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:toast/toast.dart';
import 'package:get/get.dart';
import 'package:tinycolor/tinycolor.dart';

enum AlertResult {
  confirm,
  cancel,
}

class AdaptiveComponents {
  static OverlayEntry _loadingOverlay;

  static void showLoading(
    BuildContext context, {
    String content,
    Color barrierColor = Colors.black12,
    bool barrierDismissible = true,
  }) {
    _loadingOverlay = OverlayEntry(
      builder: (context) {
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: barrierDismissible ? hideLoading : null,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            alignment: Alignment.center,
            color: barrierColor,
            child: Container(
              alignment: Alignment.center,
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Platform.isAndroid
                      ? CircularProgressIndicator()
                      : Theme(
                          data: ThemeData.dark(),
                          child: CupertinoActivityIndicator(
                            radius: 15,
                          ),
                        ),
                  if (content != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Material(
                        child: Text(
                          content,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        color: Colors.transparent,
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
    Overlay.of(context).insert(_loadingOverlay);
  }

  static void hideLoading() {
    if (_loadingOverlay != null) {
      _loadingOverlay?.remove();
      _loadingOverlay = null;
    }
  }

  static void showToast(
    BuildContext context,
    String msg,
  ) {
    Toast.show(
      msg,
      context,
      duration: 2,
      gravity: 1,
      backgroundColor: Colors.black54,
      backgroundRadius: 10,
    );
  }

  static void showAlertDialog(
    BuildContext context, {
    String title,
    Widget titleWidget,
    String content,
    Widget contentWidget,
    String confirm,
    String cancel,
    bool hideCancel = false,
    bool hideConfirm = false,
    bool barrierDismissible = false,
    void Function(AlertResult result) onDismiss,
  }) async {
    if (Platform.isAndroid) {
      showDialog<void>(
          context: context,
          barrierDismissible: barrierDismissible,
          builder: (BuildContext context) {
            return Theme(
              data: ThemeData(brightness: E().isThemeDarkStyle ? Brightness.dark : Brightness.light),
              child: AlertDialog(
                title: titleWidget ??
                    (title == null
                        ? null
                        : Text(
                            title,
                          )),
                content: contentWidget ??
                    (content == null
                        ? null
                        : Text(
                            content,
                          )),
                actions: <Widget>[
                  FlatButton(
                    child: Text(confirm ?? "confirmTrans".tr),
                    onPressed: () {
                      Navigator.of(context).pop();
                      if (onDismiss != null) onDismiss(AlertResult.confirm);
                    },
                  ),
                  FlatButton(
                    child: Text(cancel ?? "cancelTrans".tr),
                    onPressed: () {
                      Navigator.of(context).pop();
                      if (onDismiss != null) onDismiss(AlertResult.cancel);
                    },
                  ),
                ],
              ),
            );
          });
    } else {
      showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoTheme(
            data: CupertinoThemeData(brightness: E().isThemeDarkStyle ? Brightness.dark : Brightness.light),
            child: CupertinoAlertDialog(
              title: titleWidget ??
                  (title == null
                      ? null
                      : Text(
                          title,
                        )),
              content: contentWidget ??
                  (content == null
                      ? null
                      : Text(
                          content,
                        )),
              actions: <Widget>[
                if (!hideCancel)
                  CupertinoDialogAction(
                    child: Text(cancel ?? "cancelTrans".tr),
                    onPressed: () {
                      Navigator.of(context).pop();
                      if (onDismiss != null) onDismiss(AlertResult.cancel);
                    },
                  ),
                CupertinoDialogAction(
                  child: Text(confirm ?? "confirmTrans".tr),
                  onPressed: () {
                    Navigator.of(context).pop();
                    if (onDismiss != null) onDismiss(AlertResult.confirm);
                  },
                ),
              ],
            ),
          );
        },
      );
    }
  }

  static void showBottomWidget(
    BuildContext context,
    Widget child, {
    Color backgroundColor,
  }) {
    child = Material(
      child: SafeArea(child: child),
      color: backgroundColor ?? E().mePageBackgroundColor,
    );
    if (Platform.isAndroid) {
      showMaterialModalBottomSheet(context: context, builder: (context, scrollController) => child);
    } else {
      showCupertinoModalBottomSheet(context: context, builder: (context, scrollController) => child);
    }
  }

  static void showBottomSheet(
    BuildContext context,
    List<String> itemList, {
    TextStyle textStyle,
    void Function(int index) onItemTap,
  }) {
    List<Widget> widgetList = [];
    itemList.forEach((item) {
      int index = itemList.indexOf(item);
      widgetList.add(
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: E().dialogBackgroundColor.darken(5),
                width: 1,
              ),
            ),
          ),
          child: ListTile(
            title: Center(
              child: Text(
                item,
                style: textStyle,
              ),
            ),
            onTap: () {
              Navigator.of(context).pop();
              onItemTap(index);
            },
          ),
        ),
      );
    });

    widgetList.add(
      Container(
        height: 10,
        color: E().dialogBackgroundColor.darken(5),
      ),
    );
    widgetList.add(
      ListTile(
        title: Center(
          child: Text(
            "cancelTrans".tr,
            style: (textStyle ?? TextStyle()).copyWith(color: Colors.grey),
          ),
        ),
        onTap: () {
          Navigator.of(context).pop();
        },
      ),
    );
    Widget child = Material(
      color: E().dialogBackgroundColor,
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: widgetList,
        ),
      ),
    );
    showBottomWidget(context, child);
  }
}
