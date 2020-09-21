import 'package:byr_mobile_app/customizations/theme_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tuple/tuple.dart';

class LoginDialog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginDialogState();
  }
}

class LoginDialogState extends State<LoginDialog> {
  final userIdController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    userIdController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextField userIdField = TextField(
      controller: userIdController,
      autofocus: true,
      decoration: InputDecoration(labelText: 'loginUsernameTrans'.tr),
      style: TextStyle(color: E().dialogContentColor),
    );
    TextField passwordField = TextField(
      controller: passwordController,
      autofocus: true,
      decoration: InputDecoration(labelText: 'loginPasswordTrans'.tr),
      style: TextStyle(color: E().dialogContentColor),
    );
    return SimpleDialog(
      backgroundColor: E().dialogBackgroundColor,
      title: Text(
        "login",
        style: TextStyle(
          fontSize: 17.0,
          color: E().dialogTitleColor,
        ),
      ),
      children: <Widget>[
        userIdField,
        passwordField,
        SimpleDialogOption(
          onPressed: () {
            navigator.pop(Tuple2(userIdController.text, passwordController.text));
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
