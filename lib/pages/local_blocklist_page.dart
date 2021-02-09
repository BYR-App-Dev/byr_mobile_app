import 'package:byr_mobile_app/customizations/theme_controller.dart';
import 'package:byr_mobile_app/local_objects/local_models.dart';
import 'package:byr_mobile_app/pages/pages.dart';
import 'package:byr_mobile_app/reusable_components/about_page_user_widget.dart';
import 'package:byr_mobile_app/reusable_components/adaptive_components.dart';
import 'package:byr_mobile_app/reusable_components/byr_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class LocalBlocklistPage extends StatefulWidget {
  @override
  LocalBlocklistPageState createState() => LocalBlocklistPageState();
}

class LocalBlocklistPageState extends State<LocalBlocklistPage> {
  @override
  void initState() {
    super.initState();
  }

  final userIdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        // appBar: BYRAppBar(
        //   title: Text(
        //     "blocklist".tr,
        //   ),
        // ),
        body: Container(
          child: Column(
            children: [
              Container(
                color: E().otherPagePrimaryColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      padding: EdgeInsets.all(0.0),
                      icon: Icon(
                        Icons.copy,
                        size: 28,
                      ),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: Blocklist.getBlocklist().keys.toList().join("\n")));
                        AdaptiveComponents.showToast(context, "已复制到剪贴板");
                      },
                    ),
                    IconButton(
                      padding: EdgeInsets.all(0.0),
                      icon: Icon(
                        Icons.add,
                        size: 28,
                      ),
                      onPressed: () {
                        AdaptiveComponents.showAlertDialog(
                          context,
                          title: "addBlocklistEntry".tr,
                          barrierDismissible: false,
                          contentWidget: Material(
                            child: TextField(
                              autofocus: true,
                              controller: userIdController,
                              decoration: InputDecoration(labelText: 'id'),
                              style: TextStyle(color: E().dialogContentColor),
                              maxLines: null,
                            ),
                            color: Colors.transparent,
                          ),
                          onDismiss: (result) {
                            if (result == AlertResult.confirm) {
                              userIdController.text.split(RegExp(r'[\s\n\r]')).forEach((element) {
                                if (element != null && element.length > 0) {
                                  Blocklist.addBlocklistItem(element);
                                }
                              });
                              userIdController.clear();
                              setState(() {});
                            } else {
                              userIdController.clear();
                            }
                          },
                        );
                      },
                    ),
                    IconButton(
                      padding: EdgeInsets.all(0.0),
                      icon: Icon(
                        Icons.delete_forever,
                        size: 28,
                      ),
                      onPressed: () {
                        AdaptiveComponents.showAlertDialog(
                          context,
                          title: "clearBlocklist".tr,
                          barrierDismissible: false,
                          onDismiss: (result) {
                            if (result == AlertResult.confirm) {
                              Blocklist.clearBlocklist();
                              setState(() {});
                            } else {}
                          },
                        );
                      },
                    ),
                    Switch(
                      onChanged: (v) {
                        Blocklist.setIsBlocked(v);
                        if (mounted) {
                          setState(() {});
                        }
                      },
                      value: Blocklist.getIsBlocked(),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  color: E().otherPagePrimaryColor,
                  child: GridView.builder(
                    itemCount: Blocklist.getBlocklist().length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onLongPress: () {
                          AdaptiveComponents.showAlertDialog(
                            context,
                            title:
                                "removeBlocklistEntry".tr + ": " + Blocklist.getBlocklist().entries.toList()[index].key,
                            onDismiss: (result) {
                              if (result == AlertResult.confirm) {
                                Blocklist.removeBlocklistItem(Blocklist.getBlocklist().entries.toList()[index].key);
                                if (mounted) {
                                  setState(() {});
                                }
                              }
                            },
                          );
                        },
                        child: AboutPageUserWidget(id: Blocklist.getBlocklist().entries.toList()[index].key),
                      );
                    },
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: (Blocklist.getBlocklist().length ?? 0) == 0 ? 1 : 2,
                      mainAxisSpacing: 0.0,
                      crossAxisSpacing: 0.0,
                      childAspectRatio: 3.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
