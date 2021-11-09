import 'package:byr_mobile_app/configurations/configurations.dart';
import 'package:byr_mobile_app/customizations/theme_controller.dart';
import 'package:byr_mobile_app/customizations/translation.dart';
import 'package:byr_mobile_app/customizations/translator_manager.dart';
import 'package:byr_mobile_app/helper/helper.dart';
import 'package:byr_mobile_app/local_objects/local_storage.dart';
import 'package:byr_mobile_app/nforum/nforum_structures.dart';
import 'package:byr_mobile_app/pages/about_page.dart';
import 'package:byr_mobile_app/pages/pages.dart';
import 'package:byr_mobile_app/pages/refresher_settings_page.dart';
import 'package:byr_mobile_app/pages/theme_settings_page.dart';
import 'package:byr_mobile_app/reusable_components/adaptive_components.dart';
import 'package:byr_mobile_app/reusable_components/byr_app_bar.dart';
import 'package:byr_mobile_app/reusable_components/event_bus.dart';
import 'package:byr_mobile_app/reusable_components/fullscreen_back_page_route.dart';
import 'package:byr_mobile_app/reusable_components/no_padding_list_tile.dart';
import 'package:byr_mobile_app/reusable_components/setting_item_cell.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:universal_platform/universal_platform.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SettingsPageState();
  }
}

class SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: BYRAppBar(
          title: Text(
            "settings".tr,
          ),
        ),
        backgroundColor: E().otherPagePrimaryColor,
        body: Container(
          // color: E().otherPagePrimaryColor,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // SettingItemCell(
                //   title: "language".tr,
                //   value: Translation.localeNames["translationName".tr],
                //   showArrow: false,
                //   onTap: () {
                //     List<MapEntry<String, String>> translations = Translation.localeNames.entries.toList();
                //     AdaptiveComponents.showBottomSheet(
                //       context,
                //       translations.map((value) => value.value).toList(),
                //       textStyle: TextStyle(
                //         color: E().settingItemCellMainColor,
                //         fontSize: 16,
                //       ),
                //       onItemTap: (int index) {
                //         BYRTranslatorManager.turnTranslator(translations[index].key);
                //       },
                //     );
                //   },
                // ),
                // Divider(height: 1),
                SettingItemCell(
                  title: "networkType".tr,
                  value: AppConfigs.isIPv6Used ? "useIPv6".tr : "useIPv4".tr,
                  showArrow: false,
                  onTap: () {
                    List<String> networkType = ["useIPv4".tr, "useIPv6".tr];
                    AdaptiveComponents.showBottomSheet(
                      context,
                      networkType,
                      textStyle: TextStyle(
                        color: E().settingItemCellMainColor,
                        fontSize: 16,
                      ),
                      onItemTap: (int index) {
                        if (index == 0) {
                          AppConfigs.useIPv6(false);
                        } else {
                          AppConfigs.useIPv6(true);
                        }
                        if (mounted) {
                          setState(() {});
                        }
                      },
                    );
                  },
                ),
                // Divider(height: 1),
                // SettingItemCell(
                //   title: "themeSettings".tr,
                //   onTap: () {
                //     Navigator.of(context).push(FullscreenBackPageRoute(builder: (_) => ThemeSettingsPage()));
                //   },
                // ),
                // Divider(height: 1),
                // SettingItemCell(
                //   title: "refresherSettings".tr,
                //   onTap: () {
                //     Navigator.of(context).push(FullscreenBackPageRoute(builder: (_) => RefresherSettingsPage()));
                //   },
                // ),
                Divider(height: 1),
                SettingItemCell(
                  title: "appBarStyle".tr,
                  showArrow: false,
                  onTap: () {
                    AdaptiveComponents.showBottomWidget(context, AppBarChoosePanel());
                  },
                ),
                Divider(height: 1),
                NonPaddingListTile(
                  contentPadding: EdgeInsets.only(left: 15, right: 5),
                  title: Text(
                    "toptenScreenshotTrans".tr,
                    style: TextStyle(
                      color: E().otherPagePrimaryTextColor,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  trailing: Switch(
                      value: LocalStorage.getIsToptenScreenshotEnabled(),
                      onChanged: (newValue) async {
                        await LocalStorage.setIsToptenScreenshotEnabled(newValue);
                        setState(() {});
                      }),
                  onTap: null,
                ),
                Divider(height: 1),
                NonPaddingListTile(
                  contentPadding: EdgeInsets.only(left: 15, right: 5),
                  title: Text(
                    "fullscreenBackGesture".tr,
                    style: TextStyle(
                      color: E().otherPagePrimaryTextColor,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  trailing: Switch(
                      value: LocalStorage.getIsFullscreenBackEnabled(),
                      onChanged: (newValue) async {
                        if (newValue && LocalStorage.firstEnableFullscreenBack()) {
                          await LocalStorage.setIsFullscreenBackEnabled(newValue);
                          AdaptiveComponents.showAlertDialog(
                            context,
                            title: "viewInstr".tr,
                            confirm: "open".tr,
                            hideCancel: true,
                            onDismiss: (value) async {
                              if (value == AlertResult.confirm) {
                                await Navigator.of(context)
                                    .pushNamed("thread_page", arguments: ThreadPageRouteArg("BBShelp", 22557));
                                if (mounted) {
                                  setState(() {});
                                }
                              }
                            },
                          );
                        } else {
                          await LocalStorage.setIsFullscreenBackEnabled(newValue);
                          setState(() {});
                        }
                      }),
                  onTap: null,
                ),
                Divider(height: 1),
                NonPaddingListTile(
                  contentPadding: EdgeInsets.only(left: 15, right: 5),
                  title: Text(
                    "simpleHome".tr,
                    style: TextStyle(
                      color: E().otherPagePrimaryTextColor,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  trailing: Switch(
                      value: LocalStorage.getIsSimpleHomeEnabled(),
                      onChanged: (newValue) async {
                        await LocalStorage.setIsSimpleHomeEnabled(newValue);
                        eventBus.emit(UPDATE_SIMPLE_HOME_SETTING);
                        setState(() {});
                      }),
                  onTap: null,
                ),
                NonPaddingListTile(
                  contentPadding: EdgeInsets.only(left: 15, right: 5),
                  title: Text(
                    "clipBoardDetection".tr,
                    style: TextStyle(
                      color: E().otherPagePrimaryTextColor,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  trailing: Switch(
                      value: LocalStorage.getIsClipBoardDetectionEnabled(),
                      onChanged: (newValue) async {
                        await LocalStorage.setIsClipBoardDetectionEnabled(newValue);
                        setState(() {});
                      }),
                  onTap: null,
                ),
                if (UniversalPlatform.isAndroid) Divider(height: 1),
                // if (UniversalPlatform.isAndroid)
                //   SettingItemCell(
                //     title: "downgradeTrans".tr,
                //     onTap: () {
                //       Navigator.of(context).push(
                //         FullscreenBackPageRoute(
                //           builder: (_) => DowngradingPage(),
                //         ),
                //       );
                //     },
                //   ),
                // Divider(height: 1),
                SettingItemCell(
                  // height: 50,
                  // leading: Icon(Icons.local_post_office, color: E().settingItemCellMainColor),
                  title: "feedbackTrans".tr,
                  onTap: () {
                    navigator.pushNamed(
                      'post_page',
                      arguments: PostPageRouteArg(
                        board: BoardModel(
                          name: 'Advice',
                          description: '意见与建议',
                          allowAnonymous: false,
                          allowPost: true,
                          allowAttachment: true,
                        ),
                      ),
                    );
                  },
                ),
                Divider(height: 1),
                SettingItemCell(
                  // height: 50,
                  // leading: Icon(FontAwesomeIcons.exclamationCircle, color: E().settingItemCellMainColor),
                  title: "aboutButtonTrans".tr,
                  onTap: () {
                    navigator.push(FullscreenBackPageRoute(builder: (_) => AboutPage()));
                  },
                ),
                Divider(height: 1),
                SettingItemCell(
                  // height: 50,
                  // leading: Icon(FontAwesomeIcons.exclamationCircle, color: E().settingItemCellMainColor),
                  title: "logoutAll".tr,
                  onTap: () async {
                    Map<String, String> tokenMap = {};
                    await LocalStorage.setTokensWithIds(tokenMap);
                    await LocalStorage.setCurrentToken('');
                    Navigator.of(context).pushNamedAndRemoveUntil('login_page', (Route<dynamic> route) => false,
                        arguments: LoginPageRouteArg());
                  },
                ),
                Divider(height: 1),
                SettingItemCell(
                  title: "clearCache".tr,
                  showArrow: false,
                  onTap: () {
                    AdaptiveComponents.showAlertDialog(
                      context,
                      title: "clearCache".tr,
                      onDismiss: (value) async {
                        if (value == AlertResult.confirm) {
                          await Helper.deleteAppDir();
                          await Helper.deleteCacheDir();
                          if (mounted) {
                            setState(() {});
                          }
                        }
                      },
                    );
                  },
                ),
                Divider(height: 1),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
