import 'dart:ui';

import 'package:byr_mobile_app/configurations/configurations.dart';
import 'package:byr_mobile_app/customizations/byr_icons.dart';
import 'package:byr_mobile_app/customizations/theme_controller.dart';
import 'package:byr_mobile_app/customizations/theme_manager.dart';
import 'package:byr_mobile_app/local_objects/local_storage.dart';
import 'package:byr_mobile_app/nforum/nforum_link_handler.dart';
import 'package:byr_mobile_app/nforum/nforum_service.dart';
import 'package:byr_mobile_app/pages/pages.dart';
import 'package:byr_mobile_app/reusable_components/custom_tabs.dart';
import 'package:byr_mobile_app/reusable_components/event_bus.dart';
import 'package:byr_mobile_app/reusable_components/ota_dialog.dart';
import 'package:byr_mobile_app/reusable_components/refreshers.dart';
import 'package:byr_mobile_app/reusable_components/tap_bottom_navigation_bar.dart';
import 'package:byr_mobile_app/tasks/startup_tasks.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_device_information/flutter_device_information.dart';
import 'package:get/get.dart';
import 'package:tinycolor/tinycolor.dart';
import 'package:uni_links/uni_links.dart';
import 'package:universal_platform/universal_platform.dart';

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

  void clipboardDetect() {
    if (!LocalStorage.getIsClipBoardDetectionEnabled()) {
      return;
    }
    Clipboard.getData(Clipboard.kTextPlain).then((value) {
      if (value != null && value.text != null) {
        if (NForumLinkHandler.isBYRLinkHandlable(value.text)) {
          showDialog<void>(
              context: context,
              builder: (BuildContext context) {
                return Theme(
                  data: ThemeData(brightness: E().isThemeDarkStyle ? Brightness.dark : Brightness.light),
                  child: AlertDialog(
                    title: Text(
                      "打开链接",
                    ),
                    content: Text(
                      value.text,
                    ),
                    actions: <Widget>[
                      FlatButton(
                        child: Text("confirmTrans".tr),
                        onPressed: () {
                          Navigator.of(context).pop();
                          Clipboard.setData(ClipboardData(text: ""));
                          handleLink(value.text);
                        },
                      ),
                      FlatButton(
                        child: Text("clearClipboard".tr),
                        onPressed: () {
                          Navigator.of(context).pop();
                          Clipboard.setData(ClipboardData(text: ""));
                        },
                      ),
                      FlatButton(
                        child: Text("cancelTrans".tr),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                );
              });
        }
      }
    }).catchError((error) {});
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
            jsonMap["latest_version"] != '22April2021' &&
            jsonMap["latest_version"] != AppConfigs.version &&
            jsonMap["latest_version"] != _ignoreVersion) {
          LocalStorage.setIgnoreVersion(null);
          String downloadLink;
          if (LocalStorage.getIsABIEnabled() && cpuAbi != null && jsonMap["download_link" + cpuAbi] != null) {
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

  void userAgreements() {}

  @override
  initState() {
    super.initState();
    eventBus.on(UPDATE_SIMPLE_HOME_SETTING, (event) {
      bool simpleHome = LocalStorage.getIsSimpleHomeEnabled();
      if (simpleHome) {
        selectedIndex = selectedIndex > 2 ? 2 : 0;
      } else {
        selectedIndex = selectedIndex > 1 ? 4 : 0;
      }
      setState(() {});
    });
    userAgreements();
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
    clipboardDetect();
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
            clipboardDetect();
            if (mounted) {
              setState(() {});
            }
            break;
          case "AppLifecycleState.paused":
            break;
          case "AppLifecycleState.inactive":
            break;
          case "AppLifecycleState.suspending":
            break;
          default:
            break;
        }
        return null;
      },
    );
  }

  void refreshCurrentPage(int index) {
    int pageIndex = -1;
    SmartRefresher refresher;
    Widget containerPage;

    void findSmartRefresher(Element element) {
      if (element.widget is SmartRefresher) {
        refresher = element.widget;
        return;
      }
      element.visitChildren(findSmartRefresher);
    }

    void findContainerPage(Element element) {
      if (element.widget == containerPage) {
        element.visitChildren(findSmartRefresher);
        return;
      }
      element.visitChildren(findContainerPage);
    }

    void findCustomTabBarView(Element element) {
      if (element.widget is CustomTabBarView) {
        pageIndex = (element.widget as CustomTabBarView).controller.index;
        containerPage = (element.widget as CustomTabBarView).children[pageIndex];
        element.visitChildren(findContainerPage);
        return;
      }
      element.visitChildren(findCustomTabBarView);
    }

    void findCurrentPage(Element element) {
      if (element.widget is FrontPage && index == 0) {
        element.visitChildren(findCustomTabBarView);
        return;
      }
      if (element.widget is DiscoverPage && index == 1) {
        element.visitChildren(findCustomTabBarView);
        return;
      }
      if (element.widget is MessagePage && index == 3) {
        element.visitChildren(findCustomTabBarView);
        return;
      }
      element.visitChildren(findCurrentPage);
    }

    (context as Element).visitChildren(findCurrentPage);
    refresher.controller.requestRefresh(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
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
    bool simpleHome = LocalStorage.getIsSimpleHomeEnabled();
    if (index == 2 - (simpleHome ? 1 : 0)) {
      Navigator.pushNamed(context, 'post_page', arguments: PostPageRouteArg());
      return;
    }
    if (oldIndex == index && index != 4 - (simpleHome ? 2 : 0)) {
      refreshCurrentPage(index);
    }
    selectedIndex = index;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    bool simpleHome = LocalStorage.getIsSimpleHomeEnabled();
    return Scaffold(
      body: IndexedStack(
        index: selectedIndex > (simpleHome ? 1 : 2) ? selectedIndex - 1 : selectedIndex,
        children: <Widget>[
          FrontPage(),
          if (!simpleHome) DiscoverPage(),
          if (!simpleHome) MessagePage(),
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
              if (!simpleHome)
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
              if (!simpleHome)
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
              if (simpleHome)
                BottomNavigationBarItem(
                  icon: Stack(
                    overflow: Overflow.visible,
                    children: <Widget>[
                      Icon(
                        selectedIndex == (simpleHome ? 2 : 4) ? BYRIcons.user_circle_solid : BYRIcons.user_circle,
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
                  title: Text("me".tr),
                )
              else
                BottomNavigationBarItem(
                  icon: Icon(
                    selectedIndex == (simpleHome ? 2 : 4) ? BYRIcons.user_circle_solid : BYRIcons.user_circle,
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
