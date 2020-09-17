import 'dart:ui';

import 'package:byr_mobile_app/customizations/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class BottomActionSheet {
  static show(BuildContext context, List<String> data, {String title, Function(int) callBack}) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Flexible(
                      child: Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    decoration: BoxDecoration(
                      color: E().dialogBackgroundColor,
                      borderRadius: BorderRadius.all(Radius.circular(14)),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        title != null
                            ? Container(
                                height: 40,
                                alignment: Alignment.center,
                                child: Text(
                                  title,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: E().dialogTitleColor),
                                ),
                              )
                            : Container(),
                        Divider(
                          height: 1,
                          color: E().otherPageSecondaryColor,
                        ),
                        Flexible(
                            child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: <Widget>[
                                ListTile(
                                  onTap: () {
                                    Navigator.pop(context);
                                    callBack(index);
                                  },
                                  title: Text(
                                    data[index],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: E().dialogContentColor),
                                  ),
                                ),
                                index == data.length - 1
                                    ? Container()
                                    : Divider(
                                        height: 1,
                                        color: E().otherPageSecondaryColor,
                                      ),
                              ],
                            );
                          },
                        )),
                      ],
                    ),
                  )),
                  SizedBox(
                    height: 9,
                  ),
                  Container(
                    height: 56,
                    width: double.infinity,
                    margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: E().dialogButtonBackgroundColor,
                      borderRadius: BorderRadius.all(Radius.circular(14)),
                    ),
                    child: ListTile(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      title: Text("cancelTrans".tr,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: E().dialogButtonTextColor,
                            fontSize: 17.0,
                          )),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
