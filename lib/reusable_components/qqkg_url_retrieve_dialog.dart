import 'package:byr_mobile_app/customizations/theme_controller.dart';
import 'package:byr_mobile_app/networking/http_request.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QQKGURLRetrieveDialog extends StatefulWidget {
  @override
  _QQKGURLRetrieveDialogState createState() => _QQKGURLRetrieveDialogState();
}

class _QQKGURLRetrieveDialogState extends State<QQKGURLRetrieveDialog> {
  final urlController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextField urlField = TextField(
      controller: urlController,
      autofocus: true,
      decoration: new InputDecoration(labelText: 'URL'),
      style: TextStyle(color: E().dialogContentColor),
    );
    return SimpleDialog(
      backgroundColor: E().dialogBackgroundColor,
      children: <Widget>[
        urlField,
        SimpleDialogOption(
          onPressed: () {
            Request.httpGet(urlController.text, {}).then((value) {
              RegExpMatch m = RegExp(r'"playurl":"(http(?:s?)://tx\.stream\.kg\.qq\.com/.+?)\?').firstMatch(value.body);
              if (m != null) {
                if (m.group(1) != null && m.group(1).length > 0 && m.group(1).startsWith("http")) {
                  navigator.pop(m.group(1).replaceFirst("http://", "https://"));
                  return;
                }
              }
              navigator.pop();
              return;
            }).catchError((e) {
              navigator.pop();
              return;
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
