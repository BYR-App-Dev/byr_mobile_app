import 'package:byr_mobile_app/customizations/theme_controller.dart';
import 'package:byr_mobile_app/nforum/nforum_service.dart';
import 'package:byr_mobile_app/reusable_components/adaptive_components.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchUserDialog extends StatefulWidget {
  @override
  _SearchUserDialogState createState() => _SearchUserDialogState();
}

class _SearchUserDialogState extends State<SearchUserDialog> {
  final userIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    userIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextField userIdField = TextField(
      controller: userIdController,
      autofocus: true,
      decoration: InputDecoration(labelText: 'id'),
      style: TextStyle(color: E().dialogContentColor),
    );
    return SimpleDialog(
      backgroundColor: E().dialogBackgroundColor,
      title: Text(
        "search".tr + " " + "loginUsernameTrans".tr,
        style: TextStyle(
          fontSize: 17.0,
          color: E().dialogTitleColor,
        ),
      ),
      children: <Widget>[
        userIdField,
        SimpleDialogOption(
          onPressed: () {
            NForumService.getUserInfo(userIdController.text).then((value) {
              navigator.pushNamed("profile_page", arguments: value);
            }).catchError((e) {
              AdaptiveComponents.showToast(context, e.toString());
            });
          },
          child: Text(
            "confirmTrans".tr,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 17.0,
              color: E().dialogButtonTextColor,
            ),
          ),
        ),
      ],
    );
  }
}
