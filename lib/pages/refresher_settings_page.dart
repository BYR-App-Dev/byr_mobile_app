import 'package:byr_mobile_app/customizations/theme_controller.dart';
import 'package:byr_mobile_app/pages/pages.dart';
import 'package:byr_mobile_app/reusable_components/byr_app_bar.dart';
import 'package:byr_mobile_app/reusable_components/refresher_import_dialog.dart';
import 'package:byr_mobile_app/reusable_components/refreshers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RefresherSettingsPage extends StatefulWidget {
  @override
  RefresherSettingsPageState createState() => RefresherSettingsPageState();
}

class RefresherSettingsPageState extends State<RefresherSettingsPage> {
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
            "refresherSettings".tr,
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.info_outline, color: E().otherPageTopBarButtonColor),
              onPressed: () async {
                await Navigator.of(context).pushNamed("thread_page", arguments: ThreadPageRouteArg("BBShelp", 22380));
                if (mounted) {
                  setState(() {});
                }
              },
            ),
            IconButton(
              icon: Icon(Icons.save_alt, color: E().otherPageTopBarButtonColor),
              onPressed: () async {
                await showDialog(context: context, builder: (context) => RefresherImporterDialog());
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
              itemCount: BYRRefresherManager.instance().refresherMap.length,
              itemBuilder: (context, index) {
                var entryList = BYRRefresherManager.instance().refresherMap.entries.toList();
                return ListTile(
                    title: Text(
                      entryList[index].value.refresherDisplayName,
                      style: TextStyle(color: E().otherPagePrimaryTextColor),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (!(entryList[index].key == 'BUPTHeartBeat' || entryList[index].key == 'AirconSummerBUPT'))
                          FlatButton(
                            child: Icon(
                              Icons.delete,
                              color: E().otherPageButtonColor,
                            ),
                            onPressed: () async {
                              await BYRRefresherManager.instance().removeRefresher(entryList[index].key);
                              if (mounted) {
                                setState(() {});
                              }
                            },
                          ),
                        Switch(
                            value: entryList[index].value.enabled,
                            onChanged: (bool v) {
                              if (v == true) {
                                BYRRefresherManager.instance().enableRefresher(entryList[index].key);
                              } else {
                                BYRRefresherManager.instance().disableRefresher(entryList[index].key);
                              }
                              if (mounted) {
                                setState(() {});
                              }
                            }),
                      ],
                    ));
              }),
        ),
      ),
    );
  }
}
