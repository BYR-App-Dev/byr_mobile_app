import 'package:byr_mobile_app/customizations/theme_manager.dart';
import 'package:byr_mobile_app/nforum/nforum_service.dart';
import 'package:byr_mobile_app/pages/login_page.dart';
import 'package:byr_mobile_app/reusable_components/page_initialization.dart';
import 'package:byr_mobile_app/shared_objects/shared_objects.dart';
import 'package:byr_mobile_app/tasks/startup_tasks.dart';
import 'package:byr_mobile_app/tasks/welcome_page_tasks.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:get/get.dart';
import 'package:transparent_image/transparent_image.dart';

class WelcomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return WelcomePageState();
  }
}

class WelcomePageState extends State<WelcomePage> {
  InitializationStatus initializationStatus;

  bool skipped = false;

  Future<void> startupApp() async {
    await StartupTasks.startupAll();
  }

  Future<void> initializePage() async {
    return await WelcomePageTasks.loadWelImg().then((value) {
      initializationStatus = InitializationStatus.Initialized;
      if (mounted) {
        setState(() {});
      }
    });
  }

  void skip() {
    skipped = true;
    if (NForumService.currentToken == null) {
      navigator.pushReplacementNamed("login_page", arguments: LoginPageRouteArg(isAddingMoreAccount: false));
    } else {
      navigator.pushReplacementNamed("home_page");
    }
  }

  @override
  void initState() {
    super.initState();
    initializationStatus = InitializationStatus.Initializing;
    if (mounted) {
      setState(() {});
    }
    FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE).then((_) => startupApp().then((value) {
          if (BYRThemeManager.instance().getIsAutoSwitchDarkModel() == true) {
            final Brightness brightness = MediaQuery.platformBrightnessOf(context);
            BYRThemeManager.instance().autoSwitchDarkMode(brightness);
          }
          initializePage().then((value) {
            Future.delayed(Duration(milliseconds: 1500), () {
              if (skipped == false) {
                if (NForumService.currentToken == null) {
                  navigator.pushReplacementNamed("login_page",
                      arguments: LoginPageRouteArg(isAddingMoreAccount: false));
                } else {
                  navigator.pushReplacementNamed("home_page");
                }
              }
            });
          });
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
        fit: BoxFit.cover,
        image: AssetImage(MediaQuery.of(Get.context).size.shortestSide > 600
            ? 'resources/welcome_page/ipad-2.jpg'
            : 'resources/welcome_page/bbs_ipxmax.png'),
      )),
      child: initializationStatus == InitializationStatus.Initialized
          ? Stack(
              children: [
                Positioned(
                  left: 0,
                  top: 0,
                  right: 0,
                  bottom: 0,
                  child: FadeInImage(
                    fadeInDuration: Duration(milliseconds: 100),
                    fit: BoxFit.fill,
                    placeholder: MemoryImage(kTransparentImage),
                    image: SharedObjects.welImage,
                  ),
                ),
                Positioned(
                  right: 30,
                  bottom: 30,
                  child: TextButton(
                    onPressed: () {
                      skip();
                    },
                    child: Text(
                      "skipTrans".tr,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 30,
                  bottom: 30,
                  child: TextButton(
                    onPressed: () {
                      skip();
                    },
                    child: Text(
                      "skipTrans".tr,
                      style: TextStyle(
                        fontSize: 18,
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 0.5
                          ..color = Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            )
          : Container(),
    );
  }
}
