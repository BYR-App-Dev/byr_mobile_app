import 'package:byr_mobile_app/customizations/theme_controller.dart';
import 'package:byr_mobile_app/customizations/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeImporterDialog extends StatefulWidget {
  @override
  _ThemeImporterDialogState createState() => _ThemeImporterDialogState();
}

class _ThemeImporterDialogState extends State<ThemeImporterDialog> {
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
      decoration: InputDecoration(labelText: 'URL'),
      style: TextStyle(color: E().dialogContentColor),
    );
    return SimpleDialog(
      backgroundColor: E().dialogBackgroundColor,
      title: Text(
        "themeAdd".tr,
        style: TextStyle(
          fontSize: 17.0,
          color: E().dialogTitleColor,
        ),
      ),
      children: <Widget>[
        urlField,
        SimpleDialogOption(
          onPressed: () {
            BYRThemeManager.instance()
                .importOnlineTheme(urlController.text, null, BYRTheme.originLightTheme)
                .then((succeeded) {
              if (succeeded) {
                String currentThemeName = BYRThemeManager.instance().currentTheme.themeName;
                BYRThemeManager.instance().turnTheme(currentThemeName);
                Navigator.pop(context);
                showDialog(
                    context: context,
                    builder: (context) => SimpleDialog(
                          backgroundColor: E().dialogBackgroundColor,
                          title: Text(
                            "succeed".tr,
                            style: TextStyle(
                              fontSize: 17.0,
                              color: E().dialogTitleColor,
                            ),
                          ),
                          titlePadding: EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 24.0),
                        ));
              } else {
                showDialog(
                    context: context,
                    builder: (context) => SimpleDialog(
                          backgroundColor: E().dialogBackgroundColor,
                          title: Text(
                            "fail".tr,
                            style: TextStyle(
                              fontSize: 17.0,
                              color: E().dialogTitleColor,
                            ),
                          ),
                          titlePadding: EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 24.0),
                        ));
              }
            }).catchError((handleError) {
              showDialog(
                  context: context,
                  builder: (context) => SimpleDialog(
                        backgroundColor: E().dialogBackgroundColor,
                        title: Text(
                          "fail".tr,
                          style: TextStyle(
                            fontSize: 17.0,
                            color: E().dialogTitleColor,
                          ),
                        ),
                        titlePadding: EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 24.0),
                      ));
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
