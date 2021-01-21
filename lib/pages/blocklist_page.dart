import 'package:byr_mobile_app/customizations/theme_controller.dart';
import 'package:byr_mobile_app/local_objects/local_models.dart';
import 'package:byr_mobile_app/pages/pages.dart';
import 'package:byr_mobile_app/reusable_components/about_page_user_widget.dart';
import 'package:byr_mobile_app/reusable_components/adaptive_components.dart';
import 'package:byr_mobile_app/reusable_components/byr_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BlocklistPage extends StatefulWidget {
  @override
  BlocklistPageState createState() => BlocklistPageState();
}

class BlocklistPageState extends State<BlocklistPage> {
  @override
  void initState() {
    super.initState();
  }

  final userIdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: BYRAppBar(
          title: Text(
            "blocklist".tr,
          ),
          actions: <Widget>[
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
                      maxLines: 1,
                    ),
                    color: Colors.transparent,
                  ),
                  onDismiss: (result) {
                    if (result == AlertResult.confirm) {
                      Blocklist.addBlocklistItem(userIdController.text);
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
        body: Container(
          color: E().otherPagePrimaryColor,
          child: GridView.builder(
            itemCount: Blocklist.getBlocklist().length,
            itemBuilder: (context, index) {
              return GestureDetector(
                behavior: HitTestBehavior.translucent,
                onLongPress: () {
                  AdaptiveComponents.showAlertDialog(
                    context,
                    title: "removeBlocklistEntry".tr + ": " + Blocklist.getBlocklist().entries.toList()[index].key,
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
    );
  }
}
