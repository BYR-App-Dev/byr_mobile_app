import 'package:byr_mobile_app/customizations/theme.dart';
import 'package:byr_mobile_app/customizations/theme_controller.dart';
import 'package:byr_mobile_app/pages/pages.dart';
import 'package:byr_mobile_app/reusable_components/byr_app_bar.dart';
import 'package:byr_mobile_app/reusable_components/theme_import_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeSettingsPage extends StatefulWidget {
  @override
  ThemeSettingsPageState createState() => ThemeSettingsPageState();
}

class ThemeSettingsPageState extends State<ThemeSettingsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: BYRAppBar(
          title: Text(
            "themeSettings".tr,
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.info_outline, color: E().otherPageTopBarButtonColor),
              onPressed: () async {
                await Navigator.of(context).pushNamed("thread_page", arguments: ThreadPageRouteArg("BBShelp", 22362));
                if (mounted) {
                  setState(() {});
                }
              },
            ),
            IconButton(
              icon: Icon(Icons.save_alt, color: E().otherPageTopBarButtonColor),
              onPressed: () async {
                await showDialog(context: context, builder: (context) => ThemeImporterDialog());
                if (mounted) {
                  setState(() {});
                }
              },
            ),
          ],
        ),
        body: Container(
          color: E().otherPagePrimaryColor,
          child: ListView.builder(
              itemCount: BYRThemeManager.instance().themeMap.length,
              itemBuilder: (context, index) {
                var entryList = BYRThemeManager.instance().themeMap.entries.toList();
                return ListTile(
                    title: Text(
                      entryList[index].value.themeDisplayName,
                      style: TextStyle(color: E().otherPagePrimaryTextColor),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (!(entryList[index].key == 'Light Theme' || entryList[index].key == 'Dark Theme'))
                          FlatButton(
                            child: Icon(
                              Icons.delete,
                              color: E().otherPageButtonColor,
                            ),
                            onPressed: () {
                              BYRThemeManager.instance().removeTheme(entryList[index].key);
                              if (mounted) {
                                setState(() {});
                              }
                            },
                          ),
                      ],
                    ));
              }),
        ),
      ),
    );
  }
}
