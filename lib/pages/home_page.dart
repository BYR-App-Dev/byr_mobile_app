import 'dart:ui';

import 'package:byr_mobile_app/configurations/configurations.dart';
import 'package:byr_mobile_app/customizations/byr_icons.dart';
import 'package:byr_mobile_app/customizations/theme_controller.dart';
import 'package:byr_mobile_app/customizations/theme_manager.dart';
import 'package:byr_mobile_app/local_objects/local_storage.dart';
import 'package:byr_mobile_app/nforum/nforum_link_handler.dart';
import 'package:byr_mobile_app/nforum/nforum_service.dart';
import 'package:byr_mobile_app/pages/pages.dart';
import 'package:byr_mobile_app/reusable_components/ota_dialog.dart';
import 'package:byr_mobile_app/reusable_components/tap_bottom_navigation_bar.dart';
import 'package:byr_mobile_app/tasks/startup_tasks.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tinycolor/tinycolor.dart';
import 'package:uni_links/uni_links.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:flutter_device_information/flutter_device_information.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin, WidgetsBindingObserver {
  @override
  bool get wantKeepAlive => true;

  Future<Null> initUniLinks() async {
    try {
      String initialLink = await getInitialLink();
      handleLink(initialLink);
    } on PlatformException {}
    getLinksStream().listen((String link) {
      handleLink(link);
    }, onError: (err) {});
  }

  void handleLink(String link) {
    NForumLinkHandler.byrLinkHandler(link);
  }

  void androidCheckUpdate() {
    if (UniversalPlatform.isAndroid) {
      NForumService.getAndroidLatest().then((jsonMap) async {
        String cpuAbi;
        try {
          cpuAbi = await FlutterDeviceInformation.cpuAbis;
          if (cpuAbi.contains("arm64-v8a")) {
            cpuAbi = "arm64-v8a";
          } else if (cpuAbi.contains("armeabi-v7a")) {
            cpuAbi = "armeabi-v7a";
          } else if (cpuAbi.contains("x86_64")) {
            cpuAbi = "x86_64";
          }
        } on PlatformException {}
        String _ignoreVersion = LocalStorage.getIgnoreVersion();
        if (jsonMap != null &&
            jsonMap["latest_version"] != null &&
            jsonMap["latest_version"] != AppConfigs.version &&
            jsonMap["latest_version"] != _ignoreVersion) {
          LocalStorage.setIgnoreVersion(null);
          String downloadLink;
          if (cpuAbi != null && jsonMap["download_link" + cpuAbi] != null) {
            downloadLink = jsonMap["download_link" + cpuAbi];
          } else {
            downloadLink = jsonMap["download_link"];
          }
          showDialog<void>(
              context: context,
              builder: (BuildContext context) {
                return OTADialog(jsonMap["latest_version"], downloadLink, updateContent: jsonMap["update_content"]);
              });
        }
      });
    }
  }

  @override
  initState() {
    super.initState();
    selectedIndex = 0;
    StartupTasks.initializeMessage();
    initUniLinks();
    androidCheckUpdate();
    handleAppLifecycleState();
    WidgetsBinding.instance.addObserver(this);
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: E().statusBarColor,
        systemNavigationBarColor: E().systemBottomNavigationBarColor,
        systemNavigationBarIconBrightness: !E().isThemeDarkStyle ? Brightness.dark : Brightness.light,
      ),
    );
  }

  void handleAppLifecycleState() {
    SystemChannels.lifecycle.setMessageHandler(
      (msg) {
        switch (msg) {
          case "AppLifecycleState.resumed":
            if (BYRThemeManager.instance().getIsAutoSwitchDarkModel() == true) {
              final Brightness brightness = MediaQuery.platformBrightnessOf(context);
              BYRThemeManager.instance().autoSwitchDarkMode(brightness);
            }
            SystemChrome.setSystemUIOverlayStyle(
              SystemUiOverlayStyle(
                statusBarColor: E().statusBarColor,
                systemNavigationBarColor: E().systemBottomNavigationBarColor,
                systemNavigationBarIconBrightness: !E().isThemeDarkStyle ? Brightness.dark : Brightness.light,
              ),
            );
            if (mounted) {
              setState(() {});
            }
            break;
          case "AppLifecycleState.paused":
          case "AppLifecycleState.inactive":
          case "AppLifecycleState.suspending":
          default:
            break;
        }
        return null;
      },
    );
  }

  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();
    if (BYRThemeManager.instance().getIsAutoSwitchDarkModel() == true) {
      final Brightness brightness = WidgetsBinding.instance.window.platformBrightness;
      BYRThemeManager.instance().autoSwitchDarkMode(brightness);
    }
  }

  int selectedIndex;

  void onItemTapped(int index, int oldIndex) {
    if (index == 2) {
      Navigator.pushNamed(context, 'post_page', arguments: PostPageRouteArg());
      return;
    }
    selectedIndex = index;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: IndexedStack(
        index: selectedIndex > 2 ? selectedIndex - 1 : selectedIndex,
        children: <Widget>[
          FrontPage(),
          DiscoverPage(),
          MessagePage(),
          MePage(),
        ],
      ),
      bottomNavigationBar: Obx(
        () => Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: E().bottomBarBackgroundColor.darken(5), width: 1),
            ),
          ),
          child: TapBottomNavigationBar(
            iconSize: 28,
            elevation: 0,
            backgroundColor: E().bottomBarBackgroundColor,
            selectedItemColor: E().bottomBarIconSelectedColor,
            unselectedItemColor: E().bottomBarIconUnselectedColor,
            selectedIconTheme: IconThemeData(
              color: E().bottomBarIconSelectedColor,
            ),
            unselectedIconTheme: IconThemeData(
              color: E().bottomBarIconUnselectedColor,
            ),
            selectedLabelStyle: TextStyle(
              color: E().bottomBarTextSelectedColor,
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelStyle: TextStyle(
              color: E().bottomBarTextUnselectedColor,
            ),
            type: BottomNavigationBarType.fixed,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(
                  selectedIndex == 0 ? BYRIcons.circle_butterfly_solid : BYRIcons.circle_butterfly,
                ),
                title: Text(
                  "homePage".tr,
                ),
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  selectedIndex == 1 ? BYRIcons.dizzy_solid : BYRIcons.dizzy,
                ),
                title: Text("discover".tr),
              ),
              BottomNavigationBarItem(
                icon: Container(
                  width: 50,
                  height: 30,
                  decoration: BoxDecoration(
                    color: E().bottomBarPostIconBackgroundColor,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Icon(
                    Icons.add,
                    color: E().bottomBarPostIconFillColor,
                  ),
                ),
                title: Text(''),
              ),
              BottomNavigationBarItem(
                icon: Stack(
                  overflow: Overflow.visible,
                  children: <Widget>[
                    Icon(
                      selectedIndex == 3 ? BYRIcons.comment_dots_solid : BYRIcons.comment_dots,
                    ),
                    Get.find<MessageController>().allCount > 0
                        ? Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              padding: EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              constraints: BoxConstraints(
                                minWidth: 8,
                                minHeight: 8,
                              ),
                            ),
                          )
                        : SizedBox.shrink()
                  ],
                ),
                title: Text("messageTrans".tr),
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  selectedIndex == 4 ? BYRIcons.user_circle_solid : BYRIcons.user_circle,
                ),
                title: Text("me".tr),
              ),
            ],
            currentIndex: selectedIndex,
            onTap: onItemTapped,
          ),
        ),
      ),
    );
  }
}
