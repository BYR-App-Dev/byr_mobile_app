import 'package:byr_mobile_app/configurations/configurations.dart';
import 'package:byr_mobile_app/customizations/theme_controller.dart';
import 'package:byr_mobile_app/local_objects/local_storage.dart';
import 'package:byr_mobile_app/nforum/nforum_service.dart';
import 'package:byr_mobile_app/reusable_components/byr_app_bar.dart';
import 'package:byr_mobile_app/reusable_components/ota_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DowngradingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return DowngradingPageState();
  }
}

class DowngradingPageState extends State<DowngradingPage> {
  Map _resultMap;
  @override
  void initState() {
    super.initState();
    NForumService.getAndroidVersions().then((resultMap) {
      _resultMap = resultMap;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BYRAppBar(
        title: Text(
          "downgradeTrans".tr,
        ),
      ),
      backgroundColor: E().otherPagePrimaryColor,
      body: _resultMap == null
          ? Container()
          : SingleChildScrollView(
              child: Column(
                children: List.generate(_resultMap["versions"].length, (index) {
                  return Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  _resultMap["versions"][index]["version"].toString(),
                                  style: TextStyle(color: E().otherPagePrimaryTextColor),
                                ),
                                if (!(_resultMap["versions"][index]["version"].toString() == AppConfigs.version))
                                  FlatButton(
                                    child: Icon(
                                      Icons.system_update,
                                      color: E().otherPageButtonColor,
                                    ),
                                    onPressed: () {
                                      LocalStorage.setIgnoreVersion(null);
                                      showDialog<void>(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return OTADialog(
                                              _resultMap["versions"][index]["version"].toString(),
                                              _resultMap["versions"][index]["url"].toString(),
                                              updateContent: "- " +
                                                  _resultMap["versions"][index]["changelog"]
                                                      .toString()
                                                      .replaceAll(";", "\n")
                                                      .split("\n")
                                                      .join("\n- "),
                                            );
                                          });
                                    },
                                  ),
                              ],
                            ),
                            Text(
                              "- " +
                                  _resultMap["versions"][index]["changelog"]
                                      .toString()
                                      .replaceAll(";", "\n")
                                      .split("\n")
                                      .join("\n- "),
                              textAlign: TextAlign.left,
                              style: TextStyle(color: E().otherPagePrimaryTextColor),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        color: E().otherPageDividerColor,
                        height: 1,
                      ),
                    ],
                  );
                }),
              ),
            ),
    );
  }
}
