import 'package:byr_mobile_app/configurations/configurations.dart';
import 'package:byr_mobile_app/customizations/theme_controller.dart';
import 'package:byr_mobile_app/customizations/translation.dart';
import 'package:byr_mobile_app/customizations/translator_manager.dart';
import 'package:byr_mobile_app/local_objects/local_storage.dart';
import 'package:byr_mobile_app/pages/pages.dart';
import 'package:byr_mobile_app/pages/refresher_settings_page.dart';
import 'package:byr_mobile_app/pages/theme_settings_page.dart';
import 'package:byr_mobile_app/reusable_components/adaptive_components.dart';
import 'package:byr_mobile_app/reusable_components/byr_app_bar.dart';
import 'package:byr_mobile_app/reusable_components/fullscreen_back_page_route.dart';
import 'package:byr_mobile_app/reusable_components/no_padding_list_tile.dart';
import 'package:byr_mobile_app/reusable_components/setting_item_cell.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
          color: E().otherPagePrimaryColor,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SettingItemCell(
                  title: "language".tr,
                  value: Translation.localeNames["translationName".tr],
                  showArrow: false,
                  onTap: () {
                    List<MapEntry<String, String>> translations = Translation.localeNames.entries.toList();
                    AdaptiveComponents.showBottomSheet(
                      context,
                      translations.map((value) => value.value).toList(),
                      textStyle: TextStyle(
                        color: E().settingItemCellMainColor,
                        fontSize: 16,
                      ),
                      onItemTap: (int index) {
                        BYRTranslatorManager.turnTranslator(translations[index].key);
                      },
                    );
                  },
                ),
                Divider(),
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
                Divider(),
                SettingItemCell(
                  title: "themeSettings".tr,
                  onTap: () {
                    Navigator.of(context).push(FullscreenBackPageRoute(builder: (_) => ThemeSettingsPage()));
                  },
                ),
                Divider(),
                SettingItemCell(
                  title: "refresherSettings".tr,
                  onTap: () {
                    Navigator.of(context).push(FullscreenBackPageRoute(builder: (_) => RefresherSettingsPage()));
                  },
                ),
                Divider(),
                SettingItemCell(
                  title: "appBarStyle".tr,
                  showArrow: false,
                  onTap: () {
                    AdaptiveComponents.showBottomWidget(context, AppBarChoosePanel());
                  },
                ),
                Divider(),
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
                if (UniversalPlatform.isAndroid) Divider(),
                if (UniversalPlatform.isAndroid)
                  NonPaddingListTile(
                    contentPadding: EdgeInsets.only(left: 15, right: 5),
                    title: Text(
                      "publicTesting".tr,
                      style: TextStyle(
                        color: E().otherPagePrimaryTextColor,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    trailing: Switch(
                        value: LocalStorage.getIsDevChannelEnabled(),
                        onChanged: (newValue) async {
                          await LocalStorage.setIsDevChannelEnabled(newValue);
                          setState(() {});
                        }),
                    onTap: null,
                  ),
                if (UniversalPlatform.isAndroid) Divider(),
                if (UniversalPlatform.isAndroid)
                  SettingItemCell(
                    title: "downgradeTrans".tr,
                    onTap: () {
                      Navigator.of(context).push(
                        FullscreenBackPageRoute(
                          builder: (_) => DowngradingPage(),
                        ),
                      );
                    },
                  ),
                Divider(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
