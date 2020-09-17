import 'dart:ui';

import 'package:flutter/material.dart';

export 'theme_manager.dart';

class BYRTheme {
  factory BYRTheme.fromJson(Map<String, dynamic> json) => inputJson(json);

  Map<String, dynamic> toJson() => outputJson(this);
  String themeName;
  String themeDisplayName;
  bool isBoardDefaultColorsUsed;
  bool isThemeDarkStyle;
  Color statusBarColor;
  Color systemBottomNavigationBarColor;
  Color bottomBarBackgroundColor;
  Color bottomBarIconUnselectedColor;
  Color bottomBarIconSelectedColor;
  Color bottomBarPostIconBackgroundColor;
  Color bottomBarPostIconFillColor;
  Color bottomBarTextUnselectedColor;
  Color bottomBarTextSelectedColor;
  Color topBarBackgroundColor;
  Color topBarTitleNormalColor;
  Color topBarTitleUnSelectedColor;
  Color tabPageTopBarSliderColor;
  Color tabPageTopBarButtonColor;
  Color threadListTileTitleColor;
  Color threadListTileContentColor;
  Color threadListOtherTextColor;
  Color threadListDividerColor;
  Color threadListBackgroundColor;
  Color voteBetListBackgroundColor;
  Color voteBetListOptionSelectedColor;
  Color voteBetListOptionUnselectedColor;
  Color voteBetListOptionDividerColor;
  Color notificationListTileTitleColor;
  Color notificationListTileOtherTextColor;
  Color settingItemCellMainColor;
  Color settingItemCellSubColor;
  Color mePageBackgroundColor;
  Color mePageTextColor;
  Color mePageIconColor;
  Color mePageUserIdColor;
  Color mePageUsernameColor;
  Color mePageSelectedColor;
  Color sectionPageBackgroundColor;
  Color sectionPageContentColor;
  Color voteBetTitleColor;
  Color voteBetOtherTextColor;
  Color voteBetOptionTextColor;
  Color voteBetBarBaseColor;
  Color voteBetBarFillColor;
  Color voteBetOptionTickUnselectedColor;
  Color voteBetOptionTickSelectedColor;
  Color voteBetOptionPercentageTextColor;
  Color voteBetOptionTickedBarFillColor;
  Color voteBetOptionResultBarFillColor;
  Color voteBetOptionButtonBackgroundColor;
  Color voteBetOptionButtonTextColor;
  Color threadPageTopBarButtonColor;
  Color threadPageTopBarMenuColor;
  Color threadPageBackgroundColor;
  Color threadPageDividerColor;
  Color threadPageButtonUnselectedColor;
  Color threadPageButtonSelectedColor;
  Color threadPageTextUnselectedColor;
  Color threadPageTextSelectedColor;
  Color threadPageVoteUpDownUnpickedColor;
  Color threadPageVoteUpPickedColor;
  Color threadPageVoteDownPickedColor;
  Color threadPageVoteUpDownNumberColor;
  Color threadPageTitleColor;
  Color threadPageContentColor;
  Color threadPageQuoteColor;
  Color threadPageOtherTextColor;
  Color threadPageReplyBarBackgroundColor;
  Color threadPageReplyBarButtonBackgroundColor;
  Color threadPageReplyBarInputBackgroundColor;
  Color threadPagePageNumberBackgroundColor;
  Color threadPagePageNumberTextColor;
  Color emoticonPanelTopBarTitleSelectedBackgroundColor;
  Color emoticonPanelTopBarTitleUnselectedBackgroundColor;
  Color emoticonPanelTopBarTitleSelectedTextColor;
  Color emoticonPanelTopBarTitleUnselectedTextColor;
  Color editPageTopBarButtonColor;
  Color editPageBackgroundColor;
  Color editPagePlaceholderColor;
  Color editPageButtonIconColor;
  Color editPageButtonTextColor;
  Color inMailTopBarButtonColor;
  Color inMailBackgroundColor;
  Color inMailTitleColor;
  Color inMailContentColor;
  Color dialogBackgroundColor;
  Color dialogTitleColor;
  Color dialogContentColor;
  Color dialogButtonBackgroundColor;
  Color dialogButtonTextColor;
  Color maleUserIdColor;
  Color femaleUserIdColor;
  Color otherUserIdColor;
  Color userPagePrimaryBackgroundColor;
  Color userPageSecondaryBackgroundColor;
  Color userPageTextColor;
  Color userPageButtonBackgroundColor;
  Color userPageButtonFillColor;
  Color otherPageTopBarButtonColor;
  Color otherPageTopBarMenuColor;
  Color otherPagePrimaryColor;
  Color otherPageSecondaryColor;
  Color otherPageButtonColor;
  Color otherPageDividerColor;
  Color otherPagePrimaryTextColor;
  Color otherPageSecondaryTextColor;

  BYRTheme(
    this.themeName,
    this.themeDisplayName,
    this.isBoardDefaultColorsUsed,
    this.isThemeDarkStyle,
    this.statusBarColor,
    this.systemBottomNavigationBarColor,
    this.bottomBarBackgroundColor,
    this.bottomBarIconUnselectedColor,
    this.bottomBarIconSelectedColor,
    this.bottomBarPostIconBackgroundColor,
    this.bottomBarPostIconFillColor,
    this.bottomBarTextUnselectedColor,
    this.bottomBarTextSelectedColor,
    this.topBarBackgroundColor,
    this.topBarTitleNormalColor,
    this.topBarTitleUnSelectedColor,
    this.tabPageTopBarSliderColor,
    this.tabPageTopBarButtonColor,
    this.threadListTileTitleColor,
    this.threadListTileContentColor,
    this.threadListOtherTextColor,
    this.threadListDividerColor,
    this.threadListBackgroundColor,
    this.voteBetListBackgroundColor,
    this.voteBetListOptionSelectedColor,
    this.voteBetListOptionUnselectedColor,
    this.voteBetListOptionDividerColor,
    this.notificationListTileTitleColor,
    this.notificationListTileOtherTextColor,
    this.settingItemCellMainColor,
    this.settingItemCellSubColor,
    this.mePageBackgroundColor,
    this.mePageTextColor,
    this.mePageIconColor,
    this.mePageUserIdColor,
    this.mePageUsernameColor,
    this.mePageSelectedColor,
    this.sectionPageBackgroundColor,
    this.sectionPageContentColor,
    this.voteBetTitleColor,
    this.voteBetOtherTextColor,
    this.voteBetOptionTextColor,
    this.voteBetBarBaseColor,
    this.voteBetBarFillColor,
    this.voteBetOptionTickUnselectedColor,
    this.voteBetOptionTickSelectedColor,
    this.voteBetOptionPercentageTextColor,
    this.voteBetOptionTickedBarFillColor,
    this.voteBetOptionResultBarFillColor,
    this.voteBetOptionButtonBackgroundColor,
    this.voteBetOptionButtonTextColor,
    this.threadPageTopBarButtonColor,
    this.threadPageTopBarMenuColor,
    this.threadPageBackgroundColor,
    this.threadPageDividerColor,
    this.threadPageButtonUnselectedColor,
    this.threadPageButtonSelectedColor,
    this.threadPageTextUnselectedColor,
    this.threadPageTextSelectedColor,
    this.threadPageVoteUpDownUnpickedColor,
    this.threadPageVoteUpPickedColor,
    this.threadPageVoteDownPickedColor,
    this.threadPageVoteUpDownNumberColor,
    this.threadPageTitleColor,
    this.threadPageContentColor,
    this.threadPageQuoteColor,
    this.threadPageOtherTextColor,
    this.threadPageReplyBarBackgroundColor,
    this.threadPageReplyBarButtonBackgroundColor,
    this.threadPageReplyBarInputBackgroundColor,
    this.threadPagePageNumberBackgroundColor,
    this.threadPagePageNumberTextColor,
    this.emoticonPanelTopBarTitleSelectedBackgroundColor,
    this.emoticonPanelTopBarTitleUnselectedBackgroundColor,
    this.emoticonPanelTopBarTitleSelectedTextColor,
    this.emoticonPanelTopBarTitleUnselectedTextColor,
    this.editPageTopBarButtonColor,
    this.editPageBackgroundColor,
    this.editPagePlaceholderColor,
    this.editPageButtonIconColor,
    this.editPageButtonTextColor,
    this.inMailTopBarButtonColor,
    this.inMailBackgroundColor,
    this.inMailTitleColor,
    this.inMailContentColor,
    this.dialogBackgroundColor,
    this.dialogTitleColor,
    this.dialogContentColor,
    this.dialogButtonBackgroundColor,
    this.dialogButtonTextColor,
    this.maleUserIdColor,
    this.femaleUserIdColor,
    this.otherUserIdColor,
    this.userPagePrimaryBackgroundColor,
    this.userPageSecondaryBackgroundColor,
    this.userPageTextColor,
    this.userPageButtonBackgroundColor,
    this.userPageButtonFillColor,
    this.otherPageTopBarButtonColor,
    this.otherPageTopBarMenuColor,
    this.otherPagePrimaryColor,
    this.otherPageSecondaryColor,
    this.otherPageButtonColor,
    this.otherPageDividerColor,
    this.otherPagePrimaryTextColor,
    this.otherPageSecondaryTextColor,
  );

  BYRTheme.generate({
    this.themeName,
    this.themeDisplayName,
    this.isBoardDefaultColorsUsed,
    this.isThemeDarkStyle,
    this.statusBarColor,
    this.systemBottomNavigationBarColor,
    this.bottomBarBackgroundColor,
    this.bottomBarIconUnselectedColor,
    this.bottomBarIconSelectedColor,
    this.bottomBarPostIconBackgroundColor,
    this.bottomBarPostIconFillColor,
    this.bottomBarTextUnselectedColor,
    this.bottomBarTextSelectedColor,
    this.topBarBackgroundColor,
    this.topBarTitleNormalColor,
    this.topBarTitleUnSelectedColor,
    this.tabPageTopBarSliderColor,
    this.tabPageTopBarButtonColor,
    this.threadListTileTitleColor,
    this.threadListTileContentColor,
    this.threadListOtherTextColor,
    this.threadListDividerColor,
    this.threadListBackgroundColor,
    this.voteBetListBackgroundColor,
    this.voteBetListOptionSelectedColor,
    this.voteBetListOptionUnselectedColor,
    this.voteBetListOptionDividerColor,
    this.notificationListTileTitleColor,
    this.notificationListTileOtherTextColor,
    this.settingItemCellMainColor,
    this.settingItemCellSubColor,
    this.mePageBackgroundColor,
    this.mePageTextColor,
    this.mePageIconColor,
    this.mePageUserIdColor,
    this.mePageUsernameColor,
    this.mePageSelectedColor,
    this.sectionPageBackgroundColor,
    this.sectionPageContentColor,
    this.voteBetTitleColor,
    this.voteBetOtherTextColor,
    this.voteBetOptionTextColor,
    this.voteBetBarBaseColor,
    this.voteBetBarFillColor,
    this.voteBetOptionTickUnselectedColor,
    this.voteBetOptionTickSelectedColor,
    this.voteBetOptionPercentageTextColor,
    this.voteBetOptionTickedBarFillColor,
    this.voteBetOptionResultBarFillColor,
    this.voteBetOptionButtonBackgroundColor,
    this.voteBetOptionButtonTextColor,
    this.threadPageTopBarButtonColor,
    this.threadPageTopBarMenuColor,
    this.threadPageBackgroundColor,
    this.threadPageDividerColor,
    this.threadPageButtonUnselectedColor,
    this.threadPageButtonSelectedColor,
    this.threadPageTextUnselectedColor,
    this.threadPageTextSelectedColor,
    this.threadPageVoteUpDownUnpickedColor,
    this.threadPageVoteUpPickedColor,
    this.threadPageVoteDownPickedColor,
    this.threadPageVoteUpDownNumberColor,
    this.threadPageTitleColor,
    this.threadPageContentColor,
    this.threadPageQuoteColor,
    this.threadPageOtherTextColor,
    this.threadPageReplyBarBackgroundColor,
    this.threadPageReplyBarButtonBackgroundColor,
    this.threadPageReplyBarInputBackgroundColor,
    this.threadPagePageNumberBackgroundColor,
    this.threadPagePageNumberTextColor,
    this.emoticonPanelTopBarTitleSelectedBackgroundColor,
    this.emoticonPanelTopBarTitleUnselectedBackgroundColor,
    this.emoticonPanelTopBarTitleSelectedTextColor,
    this.emoticonPanelTopBarTitleUnselectedTextColor,
    this.editPageTopBarButtonColor,
    this.editPageBackgroundColor,
    this.editPagePlaceholderColor,
    this.editPageButtonIconColor,
    this.editPageButtonTextColor,
    this.inMailTopBarButtonColor,
    this.inMailBackgroundColor,
    this.inMailTitleColor,
    this.inMailContentColor,
    this.dialogBackgroundColor,
    this.dialogTitleColor,
    this.dialogContentColor,
    this.dialogButtonBackgroundColor,
    this.dialogButtonTextColor,
    this.maleUserIdColor,
    this.femaleUserIdColor,
    this.otherUserIdColor,
    this.userPagePrimaryBackgroundColor,
    this.userPageSecondaryBackgroundColor,
    this.userPageTextColor,
    this.userPageButtonBackgroundColor,
    this.userPageButtonFillColor,
    this.otherPageTopBarButtonColor,
    this.otherPageTopBarMenuColor,
    this.otherPagePrimaryColor,
    this.otherPageSecondaryColor,
    this.otherPageButtonColor,
    this.otherPageDividerColor,
    this.otherPagePrimaryTextColor,
    this.otherPageSecondaryTextColor,
  });

  static BYRTheme inputJson(Map<String, dynamic> json) {
    return BYRTheme(
      json['themeName'] as String,
      json['themeDisplayName'] as String,
      json['isBoardDefaultColorsUsed'] as bool,
      json['isThemeDarkStyle'] as bool,
      (json['statusBarColor'] != null && int.tryParse('0x' + json['statusBarColor']) != null)
          ? Color(int.parse('0x' + json['statusBarColor']))
          : null,
      (json['systemBottomNavigationBarColor'] != null &&
              int.tryParse('0x' + json['systemBottomNavigationBarColor']) != null)
          ? Color(int.parse('0x' + json['systemBottomNavigationBarColor']))
          : null,
      (json['bottomBarBackgroundColor'] != null && int.tryParse('0x' + json['bottomBarBackgroundColor']) != null)
          ? Color(int.parse('0x' + json['bottomBarBackgroundColor']))
          : null,
      (json['bottomBarIconUnselectedColor'] != null &&
              int.tryParse('0x' + json['bottomBarIconUnselectedColor']) != null)
          ? Color(int.parse('0x' + json['bottomBarIconUnselectedColor']))
          : null,
      (json['bottomBarIconSelectedColor'] != null && int.tryParse('0x' + json['bottomBarIconSelectedColor']) != null)
          ? Color(int.parse('0x' + json['bottomBarIconSelectedColor']))
          : null,
      (json['bottomBarPostIconBackgroundColor'] != null &&
              int.tryParse('0x' + json['bottomBarPostIconBackgroundColor']) != null)
          ? Color(int.parse('0x' + json['bottomBarPostIconBackgroundColor']))
          : null,
      (json['bottomBarPostIconFillColor'] != null && int.tryParse('0x' + json['bottomBarPostIconFillColor']) != null)
          ? Color(int.parse('0x' + json['bottomBarPostIconFillColor']))
          : null,
      (json['bottomBarTextUnselectedColor'] != null &&
              int.tryParse('0x' + json['bottomBarTextUnselectedColor']) != null)
          ? Color(int.parse('0x' + json['bottomBarTextUnselectedColor']))
          : null,
      (json['bottomBarTextSelectedColor'] != null && int.tryParse('0x' + json['bottomBarTextSelectedColor']) != null)
          ? Color(int.parse('0x' + json['bottomBarTextSelectedColor']))
          : null,
      (json['topBarBackgroundColor'] != null && int.tryParse('0x' + json['topBarBackgroundColor']) != null)
          ? Color(int.parse('0x' + json['topBarBackgroundColor']))
          : null,
      (json['topBarTitleNormalColor'] != null && int.tryParse('0x' + json['topBarTitleNormalColor']) != null)
          ? Color(int.parse('0x' + json['topBarTitleNormalColor']))
          : null,
      (json['topBarTitleUnSelectedColor'] != null && int.tryParse('0x' + json['topBarTitleUnSelectedColor']) != null)
          ? Color(int.parse('0x' + json['topBarTitleUnSelectedColor']))
          : null,
      (json['tabPageTopBarSliderColor'] != null && int.tryParse('0x' + json['tabPageTopBarSliderColor']) != null)
          ? Color(int.parse('0x' + json['tabPageTopBarSliderColor']))
          : null,
      (json['tabPageTopBarButtonColor'] != null && int.tryParse('0x' + json['tabPageTopBarButtonColor']) != null)
          ? Color(int.parse('0x' + json['tabPageTopBarButtonColor']))
          : null,
      (json['threadListTileTitleColor'] != null && int.tryParse('0x' + json['threadListTileTitleColor']) != null)
          ? Color(int.parse('0x' + json['threadListTileTitleColor']))
          : null,
      (json['threadListTileContentColor'] != null && int.tryParse('0x' + json['threadListTileContentColor']) != null)
          ? Color(int.parse('0x' + json['threadListTileContentColor']))
          : null,
      (json['threadListOtherTextColor'] != null && int.tryParse('0x' + json['threadListOtherTextColor']) != null)
          ? Color(int.parse('0x' + json['threadListOtherTextColor']))
          : null,
      (json['threadListDividerColor'] != null && int.tryParse('0x' + json['threadListDividerColor']) != null)
          ? Color(int.parse('0x' + json['threadListDividerColor']))
          : null,
      (json['threadListBackgroundColor'] != null && int.tryParse('0x' + json['threadListBackgroundColor']) != null)
          ? Color(int.parse('0x' + json['threadListBackgroundColor']))
          : null,
      (json['voteBetListBackgroundColor'] != null && int.tryParse('0x' + json['voteBetListBackgroundColor']) != null)
          ? Color(int.parse('0x' + json['voteBetListBackgroundColor']))
          : null,
      (json['voteBetListOptionSelectedColor'] != null &&
              int.tryParse('0x' + json['voteBetListOptionSelectedColor']) != null)
          ? Color(int.parse('0x' + json['voteBetListOptionSelectedColor']))
          : null,
      (json['voteBetListOptionUnselectedColor'] != null &&
              int.tryParse('0x' + json['voteBetListOptionUnselectedColor']) != null)
          ? Color(int.parse('0x' + json['voteBetListOptionUnselectedColor']))
          : null,
      (json['voteBetListOptionDividerColor'] != null &&
              int.tryParse('0x' + json['voteBetListOptionDividerColor']) != null)
          ? Color(int.parse('0x' + json['voteBetListOptionDividerColor']))
          : null,
      (json['notificationListTileTitleColor'] != null &&
              int.tryParse('0x' + json['notificationListTileTitleColor']) != null)
          ? Color(int.parse('0x' + json['notificationListTileTitleColor']))
          : null,
      (json['notificationListTileOtherTextColor'] != null &&
              int.tryParse('0x' + json['notificationListTileOtherTextColor']) != null)
          ? Color(int.parse('0x' + json['notificationListTileOtherTextColor']))
          : null,
      (json['settingItemCellMainColor'] != null && int.tryParse('0x' + json['settingItemCellMainColor']) != null)
          ? Color(int.parse('0x' + json['settingItemCellMainColor']))
          : null,
      (json['settingItemCellSubColor'] != null && int.tryParse('0x' + json['settingItemCellSubColor']) != null)
          ? Color(int.parse('0x' + json['settingItemCellSubColor']))
          : null,
      (json['mePageBackgroundColor'] != null && int.tryParse('0x' + json['mePageBackgroundColor']) != null)
          ? Color(int.parse('0x' + json['mePageBackgroundColor']))
          : null,
      (json['mePageTextColor'] != null && int.tryParse('0x' + json['mePageTextColor']) != null)
          ? Color(int.parse('0x' + json['mePageTextColor']))
          : null,
      (json['mePageIconColor'] != null && int.tryParse('0x' + json['mePageIconColor']) != null)
          ? Color(int.parse('0x' + json['mePageIconColor']))
          : null,
      (json['mePageUserIdColor'] != null && int.tryParse('0x' + json['mePageUserIdColor']) != null)
          ? Color(int.parse('0x' + json['mePageUserIdColor']))
          : null,
      (json['mePageUsernameColor'] != null && int.tryParse('0x' + json['mePageUsernameColor']) != null)
          ? Color(int.parse('0x' + json['mePageUsernameColor']))
          : null,
      (json['mePageSelectedColor'] != null && int.tryParse('0x' + json['mePageSelectedColor']) != null)
          ? Color(int.parse('0x' + json['mePageSelectedColor']))
          : null,
      (json['sectionPageBackgroundColor'] != null && int.tryParse('0x' + json['sectionPageBackgroundColor']) != null)
          ? Color(int.parse('0x' + json['sectionPageBackgroundColor']))
          : null,
      (json['sectionPageContentColor'] != null && int.tryParse('0x' + json['sectionPageContentColor']) != null)
          ? Color(int.parse('0x' + json['sectionPageContentColor']))
          : null,
      (json['voteBetTitleColor'] != null && int.tryParse('0x' + json['voteBetTitleColor']) != null)
          ? Color(int.parse('0x' + json['voteBetTitleColor']))
          : null,
      (json['voteBetOtherTextColor'] != null && int.tryParse('0x' + json['voteBetOtherTextColor']) != null)
          ? Color(int.parse('0x' + json['voteBetOtherTextColor']))
          : null,
      (json['voteBetOptionTextColor'] != null && int.tryParse('0x' + json['voteBetOptionTextColor']) != null)
          ? Color(int.parse('0x' + json['voteBetOptionTextColor']))
          : null,
      (json['voteBetBarBaseColor'] != null && int.tryParse('0x' + json['voteBetBarBaseColor']) != null)
          ? Color(int.parse('0x' + json['voteBetBarBaseColor']))
          : null,
      (json['voteBetBarFillColor'] != null && int.tryParse('0x' + json['voteBetBarFillColor']) != null)
          ? Color(int.parse('0x' + json['voteBetBarFillColor']))
          : null,
      (json['voteBetOptionTickUnselectedColor'] != null &&
              int.tryParse('0x' + json['voteBetOptionTickUnselectedColor']) != null)
          ? Color(int.parse('0x' + json['voteBetOptionTickUnselectedColor']))
          : null,
      (json['voteBetOptionTickSelectedColor'] != null &&
              int.tryParse('0x' + json['voteBetOptionTickSelectedColor']) != null)
          ? Color(int.parse('0x' + json['voteBetOptionTickSelectedColor']))
          : null,
      (json['voteBetOptionPercentageTextColor'] != null &&
              int.tryParse('0x' + json['voteBetOptionPercentageTextColor']) != null)
          ? Color(int.parse('0x' + json['voteBetOptionPercentageTextColor']))
          : null,
      (json['voteBetOptionTickedBarFillColor'] != null &&
              int.tryParse('0x' + json['voteBetOptionTickedBarFillColor']) != null)
          ? Color(int.parse('0x' + json['voteBetOptionTickedBarFillColor']))
          : null,
      (json['voteBetOptionResultBarFillColor'] != null &&
              int.tryParse('0x' + json['voteBetOptionResultBarFillColor']) != null)
          ? Color(int.parse('0x' + json['voteBetOptionResultBarFillColor']))
          : null,
      (json['voteBetOptionButtonBackgroundColor'] != null &&
              int.tryParse('0x' + json['voteBetOptionButtonBackgroundColor']) != null)
          ? Color(int.parse('0x' + json['voteBetOptionButtonBackgroundColor']))
          : null,
      (json['voteBetOptionButtonTextColor'] != null &&
              int.tryParse('0x' + json['voteBetOptionButtonTextColor']) != null)
          ? Color(int.parse('0x' + json['voteBetOptionButtonTextColor']))
          : null,
      (json['threadPageTopBarButtonColor'] != null && int.tryParse('0x' + json['threadPageTopBarButtonColor']) != null)
          ? Color(int.parse('0x' + json['threadPageTopBarButtonColor']))
          : null,
      (json['threadPageTopBarMenuColor'] != null && int.tryParse('0x' + json['threadPageTopBarMenuColor']) != null)
          ? Color(int.parse('0x' + json['threadPageTopBarMenuColor']))
          : null,
      (json['threadPageBackgroundColor'] != null && int.tryParse('0x' + json['threadPageBackgroundColor']) != null)
          ? Color(int.parse('0x' + json['threadPageBackgroundColor']))
          : null,
      (json['threadPageDividerColor'] != null && int.tryParse('0x' + json['threadPageDividerColor']) != null)
          ? Color(int.parse('0x' + json['threadPageDividerColor']))
          : null,
      (json['threadPageButtonUnselectedColor'] != null &&
              int.tryParse('0x' + json['threadPageButtonUnselectedColor']) != null)
          ? Color(int.parse('0x' + json['threadPageButtonUnselectedColor']))
          : null,
      (json['threadPageButtonSelectedColor'] != null &&
              int.tryParse('0x' + json['threadPageButtonSelectedColor']) != null)
          ? Color(int.parse('0x' + json['threadPageButtonSelectedColor']))
          : null,
      (json['threadPageTextUnselectedColor'] != null &&
              int.tryParse('0x' + json['threadPageTextUnselectedColor']) != null)
          ? Color(int.parse('0x' + json['threadPageTextUnselectedColor']))
          : null,
      (json['threadPageTextSelectedColor'] != null && int.tryParse('0x' + json['threadPageTextSelectedColor']) != null)
          ? Color(int.parse('0x' + json['threadPageTextSelectedColor']))
          : null,
      (json['threadPageVoteUpDownUnpickedColor'] != null &&
              int.tryParse('0x' + json['threadPageVoteUpDownUnpickedColor']) != null)
          ? Color(int.parse('0x' + json['threadPageVoteUpDownUnpickedColor']))
          : null,
      (json['threadPageVoteUpPickedColor'] != null && int.tryParse('0x' + json['threadPageVoteUpPickedColor']) != null)
          ? Color(int.parse('0x' + json['threadPageVoteUpPickedColor']))
          : null,
      (json['threadPageVoteDownPickedColor'] != null &&
              int.tryParse('0x' + json['threadPageVoteDownPickedColor']) != null)
          ? Color(int.parse('0x' + json['threadPageVoteDownPickedColor']))
          : null,
      (json['threadPageVoteUpDownNumberColor'] != null &&
              int.tryParse('0x' + json['threadPageVoteUpDownNumberColor']) != null)
          ? Color(int.parse('0x' + json['threadPageVoteUpDownNumberColor']))
          : null,
      (json['threadPageTitleColor'] != null && int.tryParse('0x' + json['threadPageTitleColor']) != null)
          ? Color(int.parse('0x' + json['threadPageTitleColor']))
          : null,
      (json['threadPageContentColor'] != null && int.tryParse('0x' + json['threadPageContentColor']) != null)
          ? Color(int.parse('0x' + json['threadPageContentColor']))
          : null,
      (json['threadPageQuoteColor'] != null && int.tryParse('0x' + json['threadPageQuoteColor']) != null)
          ? Color(int.parse('0x' + json['threadPageQuoteColor']))
          : null,
      (json['threadPageOtherTextColor'] != null && int.tryParse('0x' + json['threadPageOtherTextColor']) != null)
          ? Color(int.parse('0x' + json['threadPageOtherTextColor']))
          : null,
      (json['threadPageReplyBarBackgroundColor'] != null &&
              int.tryParse('0x' + json['threadPageReplyBarBackgroundColor']) != null)
          ? Color(int.parse('0x' + json['threadPageReplyBarBackgroundColor']))
          : null,
      (json['threadPageReplyBarButtonBackgroundColor'] != null &&
              int.tryParse('0x' + json['threadPageReplyBarButtonBackgroundColor']) != null)
          ? Color(int.parse('0x' + json['threadPageReplyBarButtonBackgroundColor']))
          : null,
      (json['threadPageReplyBarInputBackgroundColor'] != null &&
              int.tryParse('0x' + json['threadPageReplyBarInputBackgroundColor']) != null)
          ? Color(int.parse('0x' + json['threadPageReplyBarInputBackgroundColor']))
          : null,
      (json['threadPagePageNumberBackgroundColor'] != null &&
              int.tryParse('0x' + json['threadPagePageNumberBackgroundColor']) != null)
          ? Color(int.parse('0x' + json['threadPagePageNumberBackgroundColor']))
          : null,
      (json['threadPagePageNumberTextColor'] != null &&
              int.tryParse('0x' + json['threadPagePageNumberTextColor']) != null)
          ? Color(int.parse('0x' + json['threadPagePageNumberTextColor']))
          : null,
      (json['emoticonPanelTopBarTitleSelectedBackgroundColor'] != null &&
              int.tryParse('0x' + json['emoticonPanelTopBarTitleSelectedBackgroundColor']) != null)
          ? Color(int.parse('0x' + json['emoticonPanelTopBarTitleSelectedBackgroundColor']))
          : null,
      (json['emoticonPanelTopBarTitleUnselectedBackgroundColor'] != null &&
              int.tryParse('0x' + json['emoticonPanelTopBarTitleUnselectedBackgroundColor']) != null)
          ? Color(int.parse('0x' + json['emoticonPanelTopBarTitleUnselectedBackgroundColor']))
          : null,
      (json['emoticonPanelTopBarTitleSelectedTextColor'] != null &&
              int.tryParse('0x' + json['emoticonPanelTopBarTitleSelectedTextColor']) != null)
          ? Color(int.parse('0x' + json['emoticonPanelTopBarTitleSelectedTextColor']))
          : null,
      (json['emoticonPanelTopBarTitleUnselectedTextColor'] != null &&
              int.tryParse('0x' + json['emoticonPanelTopBarTitleUnselectedTextColor']) != null)
          ? Color(int.parse('0x' + json['emoticonPanelTopBarTitleUnselectedTextColor']))
          : null,
      (json['editPageTopBarButtonColor'] != null && int.tryParse('0x' + json['editPageTopBarButtonColor']) != null)
          ? Color(int.parse('0x' + json['editPageTopBarButtonColor']))
          : null,
      (json['editPageBackgroundColor'] != null && int.tryParse('0x' + json['editPageBackgroundColor']) != null)
          ? Color(int.parse('0x' + json['editPageBackgroundColor']))
          : null,
      (json['editPagePlaceholderColor'] != null && int.tryParse('0x' + json['editPagePlaceholderColor']) != null)
          ? Color(int.parse('0x' + json['editPagePlaceholderColor']))
          : null,
      (json['editPageButtonIconColor'] != null && int.tryParse('0x' + json['editPageButtonIconColor']) != null)
          ? Color(int.parse('0x' + json['editPageButtonIconColor']))
          : null,
      (json['editPageButtonTextColor'] != null && int.tryParse('0x' + json['editPageButtonTextColor']) != null)
          ? Color(int.parse('0x' + json['editPageButtonTextColor']))
          : null,
      (json['inMailTopBarButtonColor'] != null && int.tryParse('0x' + json['inMailTopBarButtonColor']) != null)
          ? Color(int.parse('0x' + json['inMailTopBarButtonColor']))
          : null,
      (json['inMailBackgroundColor'] != null && int.tryParse('0x' + json['inMailBackgroundColor']) != null)
          ? Color(int.parse('0x' + json['inMailBackgroundColor']))
          : null,
      (json['inMailTitleColor'] != null && int.tryParse('0x' + json['inMailTitleColor']) != null)
          ? Color(int.parse('0x' + json['inMailTitleColor']))
          : null,
      (json['inMailContentColor'] != null && int.tryParse('0x' + json['inMailContentColor']) != null)
          ? Color(int.parse('0x' + json['inMailContentColor']))
          : null,
      (json['dialogBackgroundColor'] != null && int.tryParse('0x' + json['dialogBackgroundColor']) != null)
          ? Color(int.parse('0x' + json['dialogBackgroundColor']))
          : null,
      (json['dialogTitleColor'] != null && int.tryParse('0x' + json['dialogTitleColor']) != null)
          ? Color(int.parse('0x' + json['dialogTitleColor']))
          : null,
      (json['dialogContentColor'] != null && int.tryParse('0x' + json['dialogContentColor']) != null)
          ? Color(int.parse('0x' + json['dialogContentColor']))
          : null,
      (json['dialogButtonBackgroundColor'] != null && int.tryParse('0x' + json['dialogButtonBackgroundColor']) != null)
          ? Color(int.parse('0x' + json['dialogButtonBackgroundColor']))
          : null,
      (json['dialogButtonTextColor'] != null && int.tryParse('0x' + json['dialogButtonTextColor']) != null)
          ? Color(int.parse('0x' + json['dialogButtonTextColor']))
          : null,
      (json['maleUserIdColor'] != null && int.tryParse('0x' + json['maleUserIdColor']) != null)
          ? Color(int.parse('0x' + json['maleUserIdColor']))
          : null,
      (json['femaleUserIdColor'] != null && int.tryParse('0x' + json['femaleUserIdColor']) != null)
          ? Color(int.parse('0x' + json['femaleUserIdColor']))
          : null,
      (json['otherUserIdColor'] != null && int.tryParse('0x' + json['otherUserIdColor']) != null)
          ? Color(int.parse('0x' + json['otherUserIdColor']))
          : null,
      (json['userPagePrimaryBackgroundColor'] != null &&
              int.tryParse('0x' + json['userPagePrimaryBackgroundColor']) != null)
          ? Color(int.parse('0x' + json['userPagePrimaryBackgroundColor']))
          : null,
      (json['userPageSecondaryBackgroundColor'] != null &&
              int.tryParse('0x' + json['userPageSecondaryBackgroundColor']) != null)
          ? Color(int.parse('0x' + json['userPageSecondaryBackgroundColor']))
          : null,
      (json['userPageTextColor'] != null && int.tryParse('0x' + json['userPageTextColor']) != null)
          ? Color(int.parse('0x' + json['userPageTextColor']))
          : null,
      (json['userPageButtonBackgroundColor'] != null &&
              int.tryParse('0x' + json['userPageButtonBackgroundColor']) != null)
          ? Color(int.parse('0x' + json['userPageButtonBackgroundColor']))
          : null,
      (json['userPageButtonFillColor'] != null && int.tryParse('0x' + json['userPageButtonFillColor']) != null)
          ? Color(int.parse('0x' + json['userPageButtonFillColor']))
          : null,
      (json['otherPageTopBarButtonColor'] != null && int.tryParse('0x' + json['otherPageTopBarButtonColor']) != null)
          ? Color(int.parse('0x' + json['otherPageTopBarButtonColor']))
          : null,
      (json['otherPageTopBarMenuColor'] != null && int.tryParse('0x' + json['otherPageTopBarMenuColor']) != null)
          ? Color(int.parse('0x' + json['otherPageTopBarMenuColor']))
          : null,
      (json['otherPagePrimaryColor'] != null && int.tryParse('0x' + json['otherPagePrimaryColor']) != null)
          ? Color(int.parse('0x' + json['otherPagePrimaryColor']))
          : null,
      (json['otherPageSecondaryColor'] != null && int.tryParse('0x' + json['otherPageSecondaryColor']) != null)
          ? Color(int.parse('0x' + json['otherPageSecondaryColor']))
          : null,
      (json['otherPageButtonColor'] != null && int.tryParse('0x' + json['otherPageButtonColor']) != null)
          ? Color(int.parse('0x' + json['otherPageButtonColor']))
          : null,
      (json['otherPageDividerColor'] != null && int.tryParse('0x' + json['otherPageDividerColor']) != null)
          ? Color(int.parse('0x' + json['otherPageDividerColor']))
          : null,
      (json['otherPagePrimaryTextColor'] != null && int.tryParse('0x' + json['otherPagePrimaryTextColor']) != null)
          ? Color(int.parse('0x' + json['otherPagePrimaryTextColor']))
          : null,
      (json['otherPageSecondaryTextColor'] != null && int.tryParse('0x' + json['otherPageSecondaryTextColor']) != null)
          ? Color(int.parse('0x' + json['otherPageSecondaryTextColor']))
          : null,
    );
  }

  static Map<String, dynamic> outputJson(BYRTheme instance) {
    return <String, dynamic>{
      'themeName': instance.themeName,
      'themeDisplayName': instance.themeDisplayName,
      'isBoardDefaultColorsUsed': instance.isBoardDefaultColorsUsed,
      'isThemeDarkStyle': instance.isThemeDarkStyle,
      'statusBarColor': instance.statusBarColor.value.toRadixString(16),
      'systemBottomNavigationBarColor': instance.systemBottomNavigationBarColor.value.toRadixString(16),
      'bottomBarBackgroundColor': instance.bottomBarBackgroundColor.value.toRadixString(16),
      'bottomBarIconUnselectedColor': instance.bottomBarIconUnselectedColor.value.toRadixString(16),
      'bottomBarIconSelectedColor': instance.bottomBarIconSelectedColor.value.toRadixString(16),
      'bottomBarPostIconBackgroundColor': instance.bottomBarPostIconBackgroundColor.value.toRadixString(16),
      'bottomBarPostIconFillColor': instance.bottomBarPostIconFillColor.value.toRadixString(16),
      'bottomBarTextUnselectedColor': instance.bottomBarTextUnselectedColor.value.toRadixString(16),
      'bottomBarTextSelectedColor': instance.bottomBarTextSelectedColor.value.toRadixString(16),
      'topBarBackgroundColor': instance.topBarBackgroundColor.value.toRadixString(16),
      'topBarTitleNormalColor': instance.topBarTitleNormalColor.value.toRadixString(16),
      'topBarTitleUnSelectedColor': instance.topBarTitleUnSelectedColor.value.toRadixString(16),
      'tabPageTopBarSliderColor': instance.tabPageTopBarSliderColor.value.toRadixString(16),
      'tabPageTopBarButtonColor': instance.tabPageTopBarButtonColor.value.toRadixString(16),
      'threadListTileTitleColor': instance.threadListTileTitleColor.value.toRadixString(16),
      'threadListTileContentColor': instance.threadListTileContentColor.value.toRadixString(16),
      'threadListOtherTextColor': instance.threadListOtherTextColor.value.toRadixString(16),
      'threadListDividerColor': instance.threadListDividerColor.value.toRadixString(16),
      'threadListBackgroundColor': instance.threadListBackgroundColor.value.toRadixString(16),
      'voteBetListBackgroundColor': instance.voteBetListBackgroundColor.value.toRadixString(16),
      'voteBetListOptionSelectedColor': instance.voteBetListOptionSelectedColor.value.toRadixString(16),
      'voteBetListOptionUnselectedColor': instance.voteBetListOptionUnselectedColor.value.toRadixString(16),
      'voteBetListOptionDividerColor': instance.voteBetListOptionDividerColor.value.toRadixString(16),
      'notificationListTileTitleColor': instance.notificationListTileTitleColor.value.toRadixString(16),
      'notificationListTileOtherTextColor': instance.notificationListTileOtherTextColor.value.toRadixString(16),
      'settingItemCellMainColor': instance.settingItemCellMainColor.value.toRadixString(16),
      'settingItemCellSubColor': instance.settingItemCellSubColor.value.toRadixString(16),
      'mePageBackgroundColor': instance.mePageBackgroundColor.value.toRadixString(16),
      'mePageTextColor': instance.mePageTextColor.value.toRadixString(16),
      'mePageIconColor': instance.mePageIconColor.value.toRadixString(16),
      'mePageUserIdColor': instance.mePageUserIdColor.value.toRadixString(16),
      'mePageUsernameColor': instance.mePageUsernameColor.value.toRadixString(16),
      'mePageSelectedColor': instance.mePageSelectedColor.value.toRadixString(16),
      'sectionPageBackgroundColor': instance.sectionPageBackgroundColor.value.toRadixString(16),
      'sectionPageContentColor': instance.sectionPageContentColor.value.toRadixString(16),
      'voteBetTitleColor': instance.voteBetTitleColor.value.toRadixString(16),
      'voteBetOtherTextColor': instance.voteBetOtherTextColor.value.toRadixString(16),
      'voteBetOptionTextColor': instance.voteBetOptionTextColor.value.toRadixString(16),
      'voteBetBarBaseColor': instance.voteBetBarBaseColor.value.toRadixString(16),
      'voteBetBarFillColor': instance.voteBetBarFillColor.value.toRadixString(16),
      'voteBetOptionTickUnselectedColor': instance.voteBetOptionTickUnselectedColor.value.toRadixString(16),
      'voteBetOptionTickSelectedColor': instance.voteBetOptionTickSelectedColor.value.toRadixString(16),
      'voteBetOptionPercentageTextColor': instance.voteBetOptionPercentageTextColor.value.toRadixString(16),
      'voteBetOptionTickedBarFillColor': instance.voteBetOptionTickedBarFillColor.value.toRadixString(16),
      'voteBetOptionResultBarFillColor': instance.voteBetOptionResultBarFillColor.value.toRadixString(16),
      'voteBetOptionButtonBackgroundColor': instance.voteBetOptionButtonBackgroundColor.value.toRadixString(16),
      'voteBetOptionButtonTextColor': instance.voteBetOptionButtonTextColor.value.toRadixString(16),
      'threadPageTopBarButtonColor': instance.threadPageTopBarButtonColor.value.toRadixString(16),
      'threadPageTopBarMenuColor': instance.threadPageTopBarMenuColor.value.toRadixString(16),
      'threadPageBackgroundColor': instance.threadPageBackgroundColor.value.toRadixString(16),
      'threadPageDividerColor': instance.threadPageDividerColor.value.toRadixString(16),
      'threadPageButtonUnselectedColor': instance.threadPageButtonUnselectedColor.value.toRadixString(16),
      'threadPageButtonSelectedColor': instance.threadPageButtonSelectedColor.value.toRadixString(16),
      'threadPageTextUnselectedColor': instance.threadPageTextUnselectedColor.value.toRadixString(16),
      'threadPageTextSelectedColor': instance.threadPageTextSelectedColor.value.toRadixString(16),
      'threadPageVoteUpDownUnpickedColor': instance.threadPageVoteUpDownUnpickedColor.value.toRadixString(16),
      'threadPageVoteUpPickedColor': instance.threadPageVoteUpPickedColor.value.toRadixString(16),
      'threadPageVoteDownPickedColor': instance.threadPageVoteDownPickedColor.value.toRadixString(16),
      'threadPageVoteUpDownNumberColor': instance.threadPageVoteUpDownNumberColor.value.toRadixString(16),
      'threadPageTitleColor': instance.threadPageTitleColor.value.toRadixString(16),
      'threadPageContentColor': instance.threadPageContentColor.value.toRadixString(16),
      'threadPageQuoteColor': instance.threadPageQuoteColor.value.toRadixString(16),
      'threadPageOtherTextColor': instance.threadPageOtherTextColor.value.toRadixString(16),
      'threadPageReplyBarBackgroundColor': instance.threadPageReplyBarBackgroundColor.value.toRadixString(16),
      'threadPageReplyBarButtonBackgroundColor':
          instance.threadPageReplyBarButtonBackgroundColor.value.toRadixString(16),
      'threadPageReplyBarInputBackgroundColor': instance.threadPageReplyBarInputBackgroundColor.value.toRadixString(16),
      'threadPagePageNumberBackgroundColor': instance.threadPagePageNumberBackgroundColor.value.toRadixString(16),
      'threadPagePageNumberTextColor': instance.threadPagePageNumberTextColor.value.toRadixString(16),
      'emoticonPanelTopBarTitleSelectedBackgroundColor':
          instance.emoticonPanelTopBarTitleSelectedBackgroundColor.value.toRadixString(16),
      'emoticonPanelTopBarTitleUnselectedBackgroundColor':
          instance.emoticonPanelTopBarTitleUnselectedBackgroundColor.value.toRadixString(16),
      'emoticonPanelTopBarTitleSelectedTextColor':
          instance.emoticonPanelTopBarTitleSelectedTextColor.value.toRadixString(16),
      'emoticonPanelTopBarTitleUnselectedTextColor':
          instance.emoticonPanelTopBarTitleUnselectedTextColor.value.toRadixString(16),
      'editPageTopBarButtonColor': instance.editPageTopBarButtonColor.value.toRadixString(16),
      'editPageBackgroundColor': instance.editPageBackgroundColor.value.toRadixString(16),
      'editPagePlaceholderColor': instance.editPagePlaceholderColor.value.toRadixString(16),
      'editPageButtonIconColor': instance.editPageButtonIconColor.value.toRadixString(16),
      'editPageButtonTextColor': instance.editPageButtonTextColor.value.toRadixString(16),
      'inMailTopBarButtonColor': instance.inMailTopBarButtonColor.value.toRadixString(16),
      'inMailBackgroundColor': instance.inMailBackgroundColor.value.toRadixString(16),
      'inMailTitleColor': instance.inMailTitleColor.value.toRadixString(16),
      'inMailContentColor': instance.inMailContentColor.value.toRadixString(16),
      'dialogBackgroundColor': instance.dialogBackgroundColor.value.toRadixString(16),
      'dialogTitleColor': instance.dialogTitleColor.value.toRadixString(16),
      'dialogContentColor': instance.dialogContentColor.value.toRadixString(16),
      'dialogButtonBackgroundColor': instance.dialogButtonBackgroundColor.value.toRadixString(16),
      'dialogButtonTextColor': instance.dialogButtonTextColor.value.toRadixString(16),
      'maleUserIdColor': instance.maleUserIdColor.value.toRadixString(16),
      'femaleUserIdColor': instance.femaleUserIdColor.value.toRadixString(16),
      'otherUserIdColor': instance.otherUserIdColor.value.toRadixString(16),
      'userPagePrimaryBackgroundColor': instance.userPagePrimaryBackgroundColor.value.toRadixString(16),
      'userPageSecondaryBackgroundColor': instance.userPageSecondaryBackgroundColor.value.toRadixString(16),
      'userPageTextColor': instance.userPageTextColor.value.toRadixString(16),
      'userPageButtonBackgroundColor': instance.userPageButtonBackgroundColor.value.toRadixString(16),
      'userPageButtonFillColor': instance.userPageButtonFillColor.value.toRadixString(16),
      'otherPageTopBarButtonColor': instance.otherPageTopBarButtonColor.value.toRadixString(16),
      'otherPageTopBarMenuColor': instance.otherPageTopBarMenuColor.value.toRadixString(16),
      'otherPagePrimaryColor': instance.otherPagePrimaryColor.value.toRadixString(16),
      'otherPageSecondaryColor': instance.otherPageSecondaryColor.value.toRadixString(16),
      'otherPageButtonColor': instance.otherPageButtonColor.value.toRadixString(16),
      'otherPageDividerColor': instance.otherPageDividerColor.value.toRadixString(16),
      'otherPagePrimaryTextColor': instance.otherPagePrimaryTextColor.value.toRadixString(16),
      'otherPageSecondaryTextColor': instance.otherPageSecondaryTextColor.value.toRadixString(16),
    };
  }

  void fillBy(BYRTheme bTheme) {
    this.themeName ??= bTheme.themeName;
    this.themeDisplayName ??= bTheme.themeDisplayName;
    this.isBoardDefaultColorsUsed ??= bTheme.isBoardDefaultColorsUsed;
    this.isThemeDarkStyle ??= bTheme.isThemeDarkStyle;
    this.statusBarColor ??= bTheme.statusBarColor;
    this.systemBottomNavigationBarColor ??= bTheme.systemBottomNavigationBarColor;
    this.bottomBarBackgroundColor ??= bTheme.bottomBarBackgroundColor;
    this.bottomBarIconUnselectedColor ??= bTheme.bottomBarIconUnselectedColor;
    this.bottomBarIconSelectedColor ??= bTheme.bottomBarIconSelectedColor;
    this.bottomBarPostIconBackgroundColor ??= bTheme.bottomBarPostIconBackgroundColor;
    this.bottomBarPostIconFillColor ??= bTheme.bottomBarPostIconFillColor;
    this.bottomBarTextUnselectedColor ??= bTheme.bottomBarTextUnselectedColor;
    this.bottomBarTextSelectedColor ??= bTheme.bottomBarTextSelectedColor;
    this.topBarBackgroundColor ??= bTheme.topBarBackgroundColor;
    this.topBarTitleNormalColor ??= bTheme.topBarTitleNormalColor;
    this.topBarTitleUnSelectedColor ??= bTheme.topBarTitleUnSelectedColor;
    this.tabPageTopBarSliderColor ??= bTheme.tabPageTopBarSliderColor;
    this.tabPageTopBarButtonColor ??= bTheme.tabPageTopBarButtonColor;
    this.threadListTileTitleColor ??= bTheme.threadListTileTitleColor;
    this.threadListTileContentColor ??= bTheme.threadListTileContentColor;
    this.threadListOtherTextColor ??= bTheme.threadListOtherTextColor;
    this.threadListDividerColor ??= bTheme.threadListDividerColor;
    this.threadListBackgroundColor ??= bTheme.threadListBackgroundColor;
    this.voteBetListBackgroundColor ??= bTheme.voteBetListBackgroundColor;
    this.voteBetListOptionSelectedColor ??= bTheme.voteBetListOptionSelectedColor;
    this.voteBetListOptionUnselectedColor ??= bTheme.voteBetListOptionUnselectedColor;
    this.voteBetListOptionDividerColor ??= bTheme.voteBetListOptionDividerColor;
    this.notificationListTileTitleColor ??= bTheme.notificationListTileTitleColor;
    this.notificationListTileOtherTextColor ??= bTheme.notificationListTileOtherTextColor;
    this.settingItemCellMainColor ??= bTheme.settingItemCellMainColor;
    this.settingItemCellSubColor ??= bTheme.settingItemCellSubColor;
    this.mePageBackgroundColor ??= bTheme.mePageBackgroundColor;
    this.mePageTextColor ??= bTheme.mePageTextColor;
    this.mePageIconColor ??= bTheme.mePageIconColor;
    this.mePageUserIdColor ??= bTheme.mePageUserIdColor;
    this.mePageUsernameColor ??= bTheme.mePageUsernameColor;
    this.mePageSelectedColor ??= bTheme.mePageSelectedColor;
    this.sectionPageBackgroundColor ??= bTheme.sectionPageBackgroundColor;
    this.sectionPageContentColor ??= bTheme.sectionPageContentColor;
    this.voteBetTitleColor ??= bTheme.voteBetTitleColor;
    this.voteBetOtherTextColor ??= bTheme.voteBetOtherTextColor;
    this.voteBetOptionTextColor ??= bTheme.voteBetOptionTextColor;
    this.voteBetBarBaseColor ??= bTheme.voteBetBarBaseColor;
    this.voteBetBarFillColor ??= bTheme.voteBetBarFillColor;
    this.voteBetOptionTickUnselectedColor ??= bTheme.voteBetOptionTickUnselectedColor;
    this.voteBetOptionTickSelectedColor ??= bTheme.voteBetOptionTickSelectedColor;
    this.voteBetOptionPercentageTextColor ??= bTheme.voteBetOptionPercentageTextColor;
    this.voteBetOptionTickedBarFillColor ??= bTheme.voteBetOptionTickedBarFillColor;
    this.voteBetOptionResultBarFillColor ??= bTheme.voteBetOptionResultBarFillColor;
    this.voteBetOptionButtonBackgroundColor ??= bTheme.voteBetOptionButtonBackgroundColor;
    this.voteBetOptionButtonTextColor ??= bTheme.voteBetOptionButtonTextColor;
    this.threadPageTopBarButtonColor ??= bTheme.threadPageTopBarButtonColor;
    this.threadPageTopBarMenuColor ??= bTheme.threadPageTopBarMenuColor;
    this.threadPageBackgroundColor ??= bTheme.threadPageBackgroundColor;
    this.threadPageDividerColor ??= bTheme.threadPageDividerColor;
    this.threadPageButtonUnselectedColor ??= bTheme.threadPageButtonUnselectedColor;
    this.threadPageButtonSelectedColor ??= bTheme.threadPageButtonSelectedColor;
    this.threadPageTextUnselectedColor ??= bTheme.threadPageTextUnselectedColor;
    this.threadPageTextSelectedColor ??= bTheme.threadPageTextSelectedColor;
    this.threadPageVoteUpDownUnpickedColor ??= bTheme.threadPageVoteUpDownUnpickedColor;
    this.threadPageVoteUpPickedColor ??= bTheme.threadPageVoteUpPickedColor;
    this.threadPageVoteDownPickedColor ??= bTheme.threadPageVoteDownPickedColor;
    this.threadPageVoteUpDownNumberColor ??= bTheme.threadPageVoteUpDownNumberColor;
    this.threadPageTitleColor ??= bTheme.threadPageTitleColor;
    this.threadPageContentColor ??= bTheme.threadPageContentColor;
    this.threadPageQuoteColor ??= bTheme.threadPageQuoteColor;
    this.threadPageOtherTextColor ??= bTheme.threadPageOtherTextColor;
    this.threadPageReplyBarBackgroundColor ??= bTheme.threadPageReplyBarBackgroundColor;
    this.threadPageReplyBarButtonBackgroundColor ??= bTheme.threadPageReplyBarButtonBackgroundColor;
    this.threadPageReplyBarInputBackgroundColor ??= bTheme.threadPageReplyBarInputBackgroundColor;
    this.threadPagePageNumberBackgroundColor ??= bTheme.threadPagePageNumberBackgroundColor;
    this.threadPagePageNumberTextColor ??= bTheme.threadPagePageNumberTextColor;
    this.emoticonPanelTopBarTitleSelectedBackgroundColor ??= bTheme.emoticonPanelTopBarTitleSelectedBackgroundColor;
    this.emoticonPanelTopBarTitleUnselectedBackgroundColor ??= bTheme.emoticonPanelTopBarTitleUnselectedBackgroundColor;
    this.emoticonPanelTopBarTitleSelectedTextColor ??= bTheme.emoticonPanelTopBarTitleSelectedTextColor;
    this.emoticonPanelTopBarTitleUnselectedTextColor ??= bTheme.emoticonPanelTopBarTitleUnselectedTextColor;
    this.editPageTopBarButtonColor ??= bTheme.editPageTopBarButtonColor;
    this.editPageBackgroundColor ??= bTheme.editPageBackgroundColor;
    this.editPagePlaceholderColor ??= bTheme.editPagePlaceholderColor;
    this.editPageButtonIconColor ??= bTheme.editPageButtonIconColor;
    this.editPageButtonTextColor ??= bTheme.editPageButtonTextColor;
    this.inMailTopBarButtonColor ??= bTheme.inMailTopBarButtonColor;
    this.inMailBackgroundColor ??= bTheme.inMailBackgroundColor;
    this.inMailTitleColor ??= bTheme.inMailTitleColor;
    this.inMailContentColor ??= bTheme.inMailContentColor;
    this.dialogBackgroundColor ??= bTheme.dialogBackgroundColor;
    this.dialogTitleColor ??= bTheme.dialogTitleColor;
    this.dialogContentColor ??= bTheme.dialogContentColor;
    this.dialogButtonBackgroundColor ??= bTheme.dialogButtonBackgroundColor;
    this.dialogButtonTextColor ??= bTheme.dialogButtonTextColor;
    this.maleUserIdColor ??= bTheme.maleUserIdColor;
    this.femaleUserIdColor ??= bTheme.femaleUserIdColor;
    this.otherUserIdColor ??= bTheme.otherUserIdColor;
    this.userPagePrimaryBackgroundColor ??= bTheme.userPagePrimaryBackgroundColor;
    this.userPageSecondaryBackgroundColor ??= bTheme.userPageSecondaryBackgroundColor;
    this.userPageTextColor ??= bTheme.userPageTextColor;
    this.userPageButtonBackgroundColor ??= bTheme.userPageButtonBackgroundColor;
    this.userPageButtonFillColor ??= bTheme.userPageButtonFillColor;
    this.otherPageTopBarButtonColor ??= bTheme.otherPageTopBarButtonColor;
    this.otherPageTopBarMenuColor ??= bTheme.otherPageTopBarMenuColor;
    this.otherPagePrimaryColor ??= bTheme.otherPagePrimaryColor;
    this.otherPageSecondaryColor ??= bTheme.otherPageSecondaryColor;
    this.otherPageButtonColor ??= bTheme.otherPageButtonColor;
    this.otherPageDividerColor ??= bTheme.otherPageDividerColor;
    this.otherPagePrimaryTextColor ??= bTheme.otherPagePrimaryTextColor;
    this.otherPageSecondaryTextColor ??= bTheme.otherPageSecondaryTextColor;
  }

  void replaceBy(BYRTheme bTheme) {
    this.themeName = bTheme.themeName ?? this.themeName;
    this.themeDisplayName = bTheme.themeDisplayName ?? this.themeDisplayName;
    this.isBoardDefaultColorsUsed = bTheme.isBoardDefaultColorsUsed ?? this.isBoardDefaultColorsUsed;
    this.isThemeDarkStyle = bTheme.isThemeDarkStyle ?? this.isThemeDarkStyle;
    this.statusBarColor = bTheme.statusBarColor ?? this.statusBarColor;
    this.systemBottomNavigationBarColor = bTheme.systemBottomNavigationBarColor ?? this.systemBottomNavigationBarColor;
    this.bottomBarBackgroundColor = bTheme.bottomBarBackgroundColor ?? this.bottomBarBackgroundColor;
    this.bottomBarIconUnselectedColor = bTheme.bottomBarIconUnselectedColor ?? this.bottomBarIconUnselectedColor;
    this.bottomBarIconSelectedColor = bTheme.bottomBarIconSelectedColor ?? this.bottomBarIconSelectedColor;
    this.bottomBarPostIconBackgroundColor =
        bTheme.bottomBarPostIconBackgroundColor ?? this.bottomBarPostIconBackgroundColor;
    this.bottomBarPostIconFillColor = bTheme.bottomBarPostIconFillColor ?? this.bottomBarPostIconFillColor;
    this.bottomBarTextUnselectedColor = bTheme.bottomBarTextUnselectedColor ?? this.bottomBarTextUnselectedColor;
    this.bottomBarTextSelectedColor = bTheme.bottomBarTextSelectedColor ?? this.bottomBarTextSelectedColor;
    this.topBarBackgroundColor = bTheme.topBarBackgroundColor ?? this.topBarBackgroundColor;
    this.topBarTitleNormalColor = bTheme.topBarTitleNormalColor ?? this.topBarTitleNormalColor;
    this.topBarTitleUnSelectedColor = bTheme.topBarTitleUnSelectedColor ?? this.topBarTitleUnSelectedColor;
    this.tabPageTopBarSliderColor = bTheme.tabPageTopBarSliderColor ?? this.tabPageTopBarSliderColor;
    this.tabPageTopBarButtonColor = bTheme.tabPageTopBarButtonColor ?? this.tabPageTopBarButtonColor;
    this.threadListTileTitleColor = bTheme.threadListTileTitleColor ?? this.threadListTileTitleColor;
    this.threadListTileContentColor = bTheme.threadListTileContentColor ?? this.threadListTileContentColor;
    this.threadListOtherTextColor = bTheme.threadListOtherTextColor ?? this.threadListOtherTextColor;
    this.threadListDividerColor = bTheme.threadListDividerColor ?? this.threadListDividerColor;
    this.threadListBackgroundColor = bTheme.threadListBackgroundColor ?? this.threadListBackgroundColor;
    this.voteBetListBackgroundColor = bTheme.voteBetListBackgroundColor ?? this.voteBetListBackgroundColor;
    this.voteBetListOptionSelectedColor = bTheme.voteBetListOptionSelectedColor ?? this.voteBetListOptionSelectedColor;
    this.voteBetListOptionUnselectedColor =
        bTheme.voteBetListOptionUnselectedColor ?? this.voteBetListOptionUnselectedColor;
    this.voteBetListOptionDividerColor = bTheme.voteBetListOptionDividerColor ?? this.voteBetListOptionDividerColor;
    this.notificationListTileTitleColor = bTheme.notificationListTileTitleColor ?? this.notificationListTileTitleColor;
    this.notificationListTileOtherTextColor =
        bTheme.notificationListTileOtherTextColor ?? this.notificationListTileOtherTextColor;
    this.settingItemCellMainColor = bTheme.settingItemCellMainColor ?? this.settingItemCellMainColor;
    this.settingItemCellSubColor = bTheme.settingItemCellSubColor ?? this.settingItemCellSubColor;
    this.mePageBackgroundColor = bTheme.mePageBackgroundColor ?? this.mePageBackgroundColor;
    this.mePageTextColor = bTheme.mePageTextColor ?? this.mePageTextColor;
    this.mePageIconColor = bTheme.mePageIconColor ?? this.mePageIconColor;
    this.mePageUserIdColor = bTheme.mePageUserIdColor ?? this.mePageUserIdColor;
    this.mePageUsernameColor = bTheme.mePageUsernameColor ?? this.mePageUsernameColor;
    this.mePageSelectedColor = bTheme.mePageSelectedColor ?? this.mePageSelectedColor;
    this.sectionPageBackgroundColor = bTheme.sectionPageBackgroundColor ?? this.sectionPageBackgroundColor;
    this.sectionPageContentColor = bTheme.sectionPageContentColor ?? this.sectionPageContentColor;
    this.voteBetTitleColor = bTheme.voteBetTitleColor ?? this.voteBetTitleColor;
    this.voteBetOtherTextColor = bTheme.voteBetOtherTextColor ?? this.voteBetOtherTextColor;
    this.voteBetOptionTextColor = bTheme.voteBetOptionTextColor ?? this.voteBetOptionTextColor;
    this.voteBetBarBaseColor = bTheme.voteBetBarBaseColor ?? this.voteBetBarBaseColor;
    this.voteBetBarFillColor = bTheme.voteBetBarFillColor ?? this.voteBetBarFillColor;
    this.voteBetOptionTickUnselectedColor =
        bTheme.voteBetOptionTickUnselectedColor ?? this.voteBetOptionTickUnselectedColor;
    this.voteBetOptionTickSelectedColor = bTheme.voteBetOptionTickSelectedColor ?? this.voteBetOptionTickSelectedColor;
    this.voteBetOptionPercentageTextColor =
        bTheme.voteBetOptionPercentageTextColor ?? this.voteBetOptionPercentageTextColor;
    this.voteBetOptionTickedBarFillColor =
        bTheme.voteBetOptionTickedBarFillColor ?? this.voteBetOptionTickedBarFillColor;
    this.voteBetOptionResultBarFillColor =
        bTheme.voteBetOptionResultBarFillColor ?? this.voteBetOptionResultBarFillColor;
    this.voteBetOptionButtonBackgroundColor =
        bTheme.voteBetOptionButtonBackgroundColor ?? this.voteBetOptionButtonBackgroundColor;
    this.voteBetOptionButtonTextColor = bTheme.voteBetOptionButtonTextColor ?? this.voteBetOptionButtonTextColor;
    this.threadPageTopBarButtonColor = bTheme.threadPageTopBarButtonColor ?? this.threadPageTopBarButtonColor;
    this.threadPageTopBarMenuColor = bTheme.threadPageTopBarMenuColor ?? this.threadPageTopBarMenuColor;
    this.threadPageBackgroundColor = bTheme.threadPageBackgroundColor ?? this.threadPageBackgroundColor;
    this.threadPageDividerColor = bTheme.threadPageDividerColor ?? this.threadPageDividerColor;
    this.threadPageButtonUnselectedColor =
        bTheme.threadPageButtonUnselectedColor ?? this.threadPageButtonUnselectedColor;
    this.threadPageButtonSelectedColor = bTheme.threadPageButtonSelectedColor ?? this.threadPageButtonSelectedColor;
    this.threadPageTextUnselectedColor = bTheme.threadPageTextUnselectedColor ?? this.threadPageTextUnselectedColor;
    this.threadPageTextSelectedColor = bTheme.threadPageTextSelectedColor ?? this.threadPageTextSelectedColor;
    this.threadPageVoteUpDownUnpickedColor =
        bTheme.threadPageVoteUpDownUnpickedColor ?? this.threadPageVoteUpDownUnpickedColor;
    this.threadPageVoteUpPickedColor = bTheme.threadPageVoteUpPickedColor ?? this.threadPageVoteUpPickedColor;
    this.threadPageVoteDownPickedColor = bTheme.threadPageVoteDownPickedColor ?? this.threadPageVoteDownPickedColor;
    this.threadPageVoteUpDownNumberColor =
        bTheme.threadPageVoteUpDownNumberColor ?? this.threadPageVoteUpDownNumberColor;
    this.threadPageTitleColor = bTheme.threadPageTitleColor ?? this.threadPageTitleColor;
    this.threadPageContentColor = bTheme.threadPageContentColor ?? this.threadPageContentColor;
    this.threadPageQuoteColor = bTheme.threadPageQuoteColor ?? this.threadPageQuoteColor;
    this.threadPageOtherTextColor = bTheme.threadPageOtherTextColor ?? this.threadPageOtherTextColor;
    this.threadPageReplyBarBackgroundColor =
        bTheme.threadPageReplyBarBackgroundColor ?? this.threadPageReplyBarBackgroundColor;
    this.threadPageReplyBarButtonBackgroundColor =
        bTheme.threadPageReplyBarButtonBackgroundColor ?? this.threadPageReplyBarButtonBackgroundColor;
    this.threadPageReplyBarInputBackgroundColor =
        bTheme.threadPageReplyBarInputBackgroundColor ?? this.threadPageReplyBarInputBackgroundColor;
    this.threadPagePageNumberBackgroundColor =
        bTheme.threadPagePageNumberBackgroundColor ?? this.threadPagePageNumberBackgroundColor;
    this.threadPagePageNumberTextColor = bTheme.threadPagePageNumberTextColor ?? this.threadPagePageNumberTextColor;
    this.emoticonPanelTopBarTitleSelectedBackgroundColor =
        bTheme.emoticonPanelTopBarTitleSelectedBackgroundColor ?? this.emoticonPanelTopBarTitleSelectedBackgroundColor;
    this.emoticonPanelTopBarTitleUnselectedBackgroundColor = bTheme.emoticonPanelTopBarTitleUnselectedBackgroundColor ??
        this.emoticonPanelTopBarTitleUnselectedBackgroundColor;
    this.emoticonPanelTopBarTitleSelectedTextColor =
        bTheme.emoticonPanelTopBarTitleSelectedTextColor ?? this.emoticonPanelTopBarTitleSelectedTextColor;
    this.emoticonPanelTopBarTitleUnselectedTextColor =
        bTheme.emoticonPanelTopBarTitleUnselectedTextColor ?? this.emoticonPanelTopBarTitleUnselectedTextColor;
    this.editPageTopBarButtonColor = bTheme.editPageTopBarButtonColor ?? this.editPageTopBarButtonColor;
    this.editPageBackgroundColor = bTheme.editPageBackgroundColor ?? this.editPageBackgroundColor;
    this.editPagePlaceholderColor = bTheme.editPagePlaceholderColor ?? this.editPagePlaceholderColor;
    this.editPageButtonIconColor = bTheme.editPageButtonIconColor ?? this.editPageButtonIconColor;
    this.editPageButtonTextColor = bTheme.editPageButtonTextColor ?? this.editPageButtonTextColor;
    this.inMailTopBarButtonColor = bTheme.inMailTopBarButtonColor ?? this.inMailTopBarButtonColor;
    this.inMailBackgroundColor = bTheme.inMailBackgroundColor ?? this.inMailBackgroundColor;
    this.inMailTitleColor = bTheme.inMailTitleColor ?? this.inMailTitleColor;
    this.inMailContentColor = bTheme.inMailContentColor ?? this.inMailContentColor;
    this.dialogBackgroundColor = bTheme.dialogBackgroundColor ?? this.dialogBackgroundColor;
    this.dialogTitleColor = bTheme.dialogTitleColor ?? this.dialogTitleColor;
    this.dialogContentColor = bTheme.dialogContentColor ?? this.dialogContentColor;
    this.dialogButtonBackgroundColor = bTheme.dialogButtonBackgroundColor ?? this.dialogButtonBackgroundColor;
    this.dialogButtonTextColor = bTheme.dialogButtonTextColor ?? this.dialogButtonTextColor;
    this.maleUserIdColor = bTheme.maleUserIdColor ?? this.maleUserIdColor;
    this.femaleUserIdColor = bTheme.femaleUserIdColor ?? this.femaleUserIdColor;
    this.otherUserIdColor = bTheme.otherUserIdColor ?? this.otherUserIdColor;
    this.userPagePrimaryBackgroundColor = bTheme.userPagePrimaryBackgroundColor ?? this.userPagePrimaryBackgroundColor;
    this.userPageSecondaryBackgroundColor =
        bTheme.userPageSecondaryBackgroundColor ?? this.userPageSecondaryBackgroundColor;
    this.userPageTextColor = bTheme.userPageTextColor ?? this.userPageTextColor;
    this.userPageButtonBackgroundColor = bTheme.userPageButtonBackgroundColor ?? this.userPageButtonBackgroundColor;
    this.userPageButtonFillColor = bTheme.userPageButtonFillColor ?? this.userPageButtonFillColor;
    this.otherPageTopBarButtonColor = bTheme.otherPageTopBarButtonColor ?? this.otherPageTopBarButtonColor;
    this.otherPageTopBarMenuColor = bTheme.otherPageTopBarMenuColor ?? this.otherPageTopBarMenuColor;
    this.otherPagePrimaryColor = bTheme.otherPagePrimaryColor ?? this.otherPagePrimaryColor;
    this.otherPageSecondaryColor = bTheme.otherPageSecondaryColor ?? this.otherPageSecondaryColor;
    this.otherPageButtonColor = bTheme.otherPageButtonColor ?? this.otherPageButtonColor;
    this.otherPageDividerColor = bTheme.otherPageDividerColor ?? this.otherPageDividerColor;
    this.otherPagePrimaryTextColor = bTheme.otherPagePrimaryTextColor ?? this.otherPagePrimaryTextColor;
    this.otherPageSecondaryTextColor = bTheme.otherPageSecondaryTextColor ?? this.otherPageSecondaryTextColor;
  }

/*
static BYRTheme originLightTheme = BYRTheme.generate(
    themeName: "Light Theme",
    themeDisplayName: "Light Theme",
    statusBarColor: Colors.transparent,
    systemBottomNavigationBarColor: Colors.white,
    systemNavigationBarButtonDark: true,
    sideDrawerBackgroundColor: Colors.white,
    sideDrawerLabelColor: Colors.black,
    frontNavigationBarColor: Colors.white,
    // frontNavigationBarColor: Colors.blue[800],
    // frontTitleColor: Colors.black,
    frontTitleColor: Colors.grey[600],
    // frontTitleColor: Colors.white,
    frontDrawerColor: Colors.white,
    // frontDrawerColor: Colors.white,
    frontTabbarBackgroundColor: Colors.white,
    // frontTabbarBackgroundColor: Colors.grey[200],
    frontTabbarSelectedLabelColor: Colors.black,
    // frontTabbarSelectedLabelColor: Colors.white,
    frontTabbarUnselectedLabelColor: Colors.grey[600],
    // frontTabbarUnselectedLabelColor: Colors.grey,
    frontTabbarIndicatorColor: Colors.blue,
    toptenBackgroundColor: Colors.white,
    toptenTitleColor: Colors.black,
    toptenBoardDescriptionColor: Colors.white,
    toptenUsernameColor: Colors.grey[500],
    toptenParticipantColor: Colors.grey[500],
    toptenQuoteColor: Colors.grey[300],
    toptenContentColor: Colors.grey[600],
    toptenDividerColor: Color(0xffeeeeee),
    timelineBackgroundColor: Colors.white,
    timelineTitleColor: Colors.black,
    timelineBoardLabelColor: Colors.white,
    timelineContentColor: Colors.grey[600],
    timelineDividerColor: Color(0xffeeeeee),
    boardmarksBackgroundColor: Colors.white,
    boardmarksCircleLabelColor: Colors.white,
    boardmarksNameColor: Colors.black,
    boardmarksNewColor: Colors.grey[500],
    threadBackgroundColor: Colors.white,
    threadSpecialBackgroundColor: Colors.lightBlue[50],
    threadTitleColor: Colors.white,
    threadAllRepliesLabelColor: Colors.blue[600],
    threadLikedRepliesLabelColor: Colors.blue[600],
    threadTileTitleColor: Colors.black,
    threadTileContentColor: Colors.black,
    threadTileUsernameMaleColor: Colors.blue,
    threadTileUsernameFemaleColor: Colors.pink,
    threadTileUsernameNoGenderColor: Colors.grey[800],
    threadTileTimeColor: Colors.grey[500],
    threadTileOrderColor: Colors.grey[600],
    threadTileThumbUpColor: Colors.grey,
    threadTileThumbUpTickColor: Colors.grey[600],
    threadTileThumbDownColor: Colors.grey[600],
    threadTileThumbDownTickColor: Colors.grey[600],
    threadDividerColor: Colors.grey[500],
    threadReplyFormBackgroundColor: Color(0xFFEEEEEE),
    threadReplyFormAreaBackgroundColor: Colors.white,
    threadReplyFormButtonColor: Color(0xFFEAEAEA),
    // threadNavigationBarColorGenerator: (s) => Colors.blue,
    boardBackgroundColor: Colors.white,
    boardTopBackgroundColor: Colors.white,
    boardTopTitleColor: Colors.black,
    boardDividerColor: Color(0xffdddddd),
    boardThreadTitleColor: Colors.black,
    boardThreadParticipantColor: Colors.grey[500],
    boardThreadPostTimeColor: Colors.grey[500],

    collectionBackgroundColor: Colors.white,
    collectionDividerColor: Color(0xffdddddd),
    collectionNavigationBarColor: Colors.white,
    // collectionNavigationBarColor: Colors.blue[800],
    collectionTitleColor: Colors.grey[600],
    // collectionTitleColor: Colors.white,
    collectionArticleTitleColor: Colors.black,

    dialogBackgroundColor: Colors.white,
    dialogTitleColor: Colors.black,
    dialogOptionColor: Colors.blue,
    emojiPanelColors: {
      'backgroundColor': Colors.white,
      'unselectedBackgroundColor': Colors.grey[300],
      'selectedBackgroundColor': Colors.grey[100],
      'tabTextColor': Colors.black,
    },

    profileBackgroundColor: Color(0xFFF3F6F7),
    profileBorderColor: Colors.white,
  );

  static BYRTheme originDarkTheme = BYRTheme.generate(
    themeName: "Dark Theme",
    themeDisplayName: "Dark Theme",
    statusBarColor: Colors.transparent,
    systemBottomNavigationBarColor: Colors.grey[900],
    systemNavigationBarButtonDark: false,
    sideDrawerBackgroundColor: Colors.grey[900],
    sideDrawerLabelColor: Colors.grey[400],
    frontNavigationBarColor: Colors.grey[900],
    // frontNavigationBarColor: Colors.indigo[900],
    frontTitleColor: Colors.grey[500],
    frontDrawerColor: Colors.grey[300],
    frontTabbarBackgroundColor: Colors.grey[900],
    // frontTabbarBackgroundColor: Colors.grey[850],
    frontTabbarSelectedLabelColor: Colors.grey[300],
    frontTabbarUnselectedLabelColor: Colors.grey[500],
    frontTabbarIndicatorColor: Colors.grey[500],
    toptenBackgroundColor: Colors.grey[900],
    toptenTitleColor: Colors.grey[300],
    toptenBoardDescriptionColor: Colors.grey[300],
    toptenUsernameColor: Colors.grey[400],
    toptenParticipantColor: Colors.grey[400],
    toptenQuoteColor: Colors.grey[600],
    toptenContentColor: Colors.grey[350],
    toptenDividerColor: Colors.grey[800],
    timelineBackgroundColor: Colors.grey[900],
    timelineTitleColor: Colors.grey[400],
    timelineBoardLabelColor: Colors.grey[300],
    timelineContentColor: Colors.grey[400],
    timelineDividerColor: Colors.grey[800],
    boardmarksBackgroundColor: Colors.grey[900],
    boardmarksCircleLabelColor: Colors.grey[300],
    boardmarksNameColor: Colors.grey[300],
    boardmarksNewColor: Colors.grey[500],
    threadBackgroundColor: Colors.grey[900],
    threadSpecialBackgroundColor: Colors.black,
    threadTitleColor: Colors.grey[300],
    threadAllRepliesLabelColor: Colors.blue[600],
    threadLikedRepliesLabelColor: Colors.blue[600],
    threadTileTitleColor: Colors.grey[300],
    threadTileContentColor: Colors.grey[400],
    threadTileUsernameMaleColor: Colors.blue[700],
    threadTileUsernameFemaleColor: Colors.pink[800],
    threadTileUsernameNoGenderColor: Colors.grey[500],
    threadTileTimeColor: Colors.grey[400],
    threadTileOrderColor: Colors.grey[200],
    threadTileThumbUpColor: Colors.grey[200],
    threadTileThumbUpTickColor: Colors.grey[200],
    threadTileThumbDownColor: Colors.grey[200],
    threadTileThumbDownTickColor: Colors.grey[200],
    threadDividerColor: Colors.grey[500],
    threadReplyFormBackgroundColor: Colors.grey[600],
    threadReplyFormAreaBackgroundColor: Colors.grey[700],
    threadReplyFormButtonColor: Colors.grey[700],
    // threadNavigationBarColorGenerator: (s) => Colors.lightBlue[900],
    boardBackgroundColor: Colors.grey[900],
    boardTopBackgroundColor: Colors.grey[900],
    boardTopTitleColor: Colors.grey[300],
    boardDividerColor: Colors.grey[800],
    boardThreadTitleColor: Colors.grey[300],
    boardThreadParticipantColor: Colors.grey[400],
    boardThreadPostTimeColor: Colors.grey[400],

    collectionBackgroundColor: Colors.grey[900],
    collectionDividerColor: Colors.grey[500],
    collectionNavigationBarColor: Colors.grey[900],
    // collectionNavigationBarColor: Colors.indigo[900],
    collectionTitleColor: Colors.grey[300],
    collectionArticleTitleColor: Colors.grey[300],

    dialogBackgroundColor: Colors.grey[900],
    dialogTitleColor: Colors.grey[400],
    dialogOptionColor: Colors.blue[600],
    emojiPanelColors: {
      'backgroundColor': Colors.grey[850],
      'unselectedBackgroundColor': Colors.grey[600],
      'selectedBackgroundColor': Colors.grey[500],
      'tabTextColor': Colors.grey[300],
    },

    profileBackgroundColor: Colors.grey[900],
    profileBorderColor: Colors.grey[300],
  );
*/

  static BYRTheme originLightTheme = BYRTheme.generate(
    themeName: "Light Theme",
    themeDisplayName: "Light Theme",
    isBoardDefaultColorsUsed: true,
    isThemeDarkStyle: false,
    statusBarColor: Colors.transparent,
    systemBottomNavigationBarColor: Colors.white,
    bottomBarBackgroundColor: Colors.white,
    bottomBarIconUnselectedColor: Colors.grey[600],
    bottomBarIconSelectedColor: Colors.black,
    bottomBarPostIconBackgroundColor: Colors.blue,
    bottomBarPostIconFillColor: Colors.white,
    bottomBarTextUnselectedColor: Colors.grey[600],
    bottomBarTextSelectedColor: Colors.black,
    topBarBackgroundColor: Colors.white,
    topBarTitleNormalColor: Colors.black,
    topBarTitleUnSelectedColor: Colors.grey[600],
    tabPageTopBarSliderColor: Colors.blue,
    tabPageTopBarButtonColor: Colors.grey[600],
    threadListTileTitleColor: Colors.black,
    threadListTileContentColor: Colors.grey[600],
    threadListOtherTextColor: Colors.grey[500],
    threadListDividerColor: Color(0xffeeeeee),
    threadListBackgroundColor: Colors.white,
    voteBetListBackgroundColor: Colors.white,
    voteBetListOptionSelectedColor: Colors.black,
    voteBetListOptionUnselectedColor: Colors.grey[600],
    voteBetListOptionDividerColor: Color(0xffeeeeee),
    notificationListTileTitleColor: Colors.black,
    notificationListTileOtherTextColor: Colors.grey[600],
    settingItemCellMainColor: Colors.black,
    settingItemCellSubColor: Colors.grey[700],
    mePageBackgroundColor: Colors.white,
    mePageTextColor: Colors.black,
    mePageIconColor: Colors.black,
    mePageUserIdColor: Colors.white,
    mePageUsernameColor: Colors.white,
    mePageSelectedColor: Colors.blue,
    sectionPageBackgroundColor: Colors.white,
    sectionPageContentColor: Colors.black,
    voteBetTitleColor: Colors.black,
    voteBetOtherTextColor: Colors.grey[700],
    voteBetOptionTextColor: Colors.black,
    voteBetBarBaseColor: Colors.grey[300],
    voteBetBarFillColor: Colors.blue,
    voteBetOptionTickUnselectedColor: Colors.black,
    voteBetOptionTickSelectedColor: Colors.blue,
    voteBetOptionPercentageTextColor: Colors.black,
    voteBetOptionTickedBarFillColor: Colors.purple,
    voteBetOptionResultBarFillColor: Colors.red,
    voteBetOptionButtonBackgroundColor: Colors.blue,
    voteBetOptionButtonTextColor: Colors.white,
    threadPageTopBarButtonColor: Colors.black,
    threadPageTopBarMenuColor: Colors.black,
    threadPageBackgroundColor: Colors.white,
    threadPageDividerColor: Colors.grey[500],
    threadPageButtonUnselectedColor: Colors.grey[500],
    threadPageButtonSelectedColor: Colors.blue,
    threadPageTextUnselectedColor: Colors.grey[500],
    threadPageTextSelectedColor: Colors.blue,
    threadPageVoteUpDownUnpickedColor: Colors.grey[500],
    threadPageVoteUpPickedColor: Colors.blue,
    threadPageVoteDownPickedColor: Colors.blue,
    threadPageVoteUpDownNumberColor: Colors.grey[500],
    threadPageTitleColor: Colors.black,
    threadPageContentColor: Colors.black,
    threadPageQuoteColor: Colors.grey[500],
    threadPageOtherTextColor: Colors.grey[500],
    threadPageReplyBarBackgroundColor: Color(0xffeeeeee),
    threadPageReplyBarButtonBackgroundColor: Color(0xffeaeaea),
    threadPageReplyBarInputBackgroundColor: Colors.white,
    threadPagePageNumberBackgroundColor: Colors.grey[700],
    threadPagePageNumberTextColor: Colors.white,
    emoticonPanelTopBarTitleUnselectedBackgroundColor: Colors.grey[300],
    emoticonPanelTopBarTitleSelectedBackgroundColor: Colors.grey[100],
    emoticonPanelTopBarTitleUnselectedTextColor: Colors.black,
    emoticonPanelTopBarTitleSelectedTextColor: Colors.black,
    editPageTopBarButtonColor: Colors.black,
    editPageBackgroundColor: Colors.white,
    editPagePlaceholderColor: Colors.grey,
    editPageButtonIconColor: Colors.grey,
    editPageButtonTextColor: Colors.grey,
    inMailTopBarButtonColor: Colors.black,
    inMailBackgroundColor: Colors.white,
    inMailTitleColor: Colors.black,
    inMailContentColor: Colors.black,
    dialogBackgroundColor: Colors.white,
    dialogTitleColor: Colors.black,
    dialogContentColor: Colors.black,
    dialogButtonBackgroundColor: Colors.white,
    dialogButtonTextColor: Colors.blue,
    maleUserIdColor: Colors.blue,
    femaleUserIdColor: Colors.pink,
    otherUserIdColor: Colors.grey[800],
    userPagePrimaryBackgroundColor: Color(0xfff3f6f7),
    userPageSecondaryBackgroundColor: Colors.white,
    userPageTextColor: Colors.black,
    userPageButtonBackgroundColor: Colors.grey[600],
    userPageButtonFillColor: Colors.white,
    otherPageTopBarButtonColor: Colors.black,
    otherPageTopBarMenuColor: Colors.black,
    otherPagePrimaryColor: Colors.white,
    otherPageSecondaryColor: Color(0xfff3f6f7),
    otherPageButtonColor: Colors.blue,
    otherPageDividerColor: Color(0xffeeeeee),
    otherPagePrimaryTextColor: Colors.black,
    otherPageSecondaryTextColor: Colors.grey[600],
  );

  static BYRTheme originDarkTheme = BYRTheme.generate(
    themeName: "Dark Theme",
    themeDisplayName: "Dark Theme",
    isBoardDefaultColorsUsed: true,
    isThemeDarkStyle: true,
    statusBarColor: Colors.transparent,
    systemBottomNavigationBarColor: Colors.grey[900],
    bottomBarBackgroundColor: Colors.grey[900],
    bottomBarIconUnselectedColor: Colors.grey[500],
    bottomBarIconSelectedColor: Colors.grey[300],
    bottomBarPostIconBackgroundColor: Colors.grey[500],
    bottomBarPostIconFillColor: Colors.white,
    bottomBarTextUnselectedColor: Colors.grey[500],
    bottomBarTextSelectedColor: Colors.grey[300],
    topBarBackgroundColor: Colors.grey[900],
    topBarTitleNormalColor: Colors.grey[300],
    topBarTitleUnSelectedColor: Colors.grey[500],
    tabPageTopBarSliderColor: Colors.grey[500],
    tabPageTopBarButtonColor: Colors.grey[500],
    threadListTileTitleColor: Colors.grey[300],
    threadListTileContentColor: Colors.grey[400],
    threadListOtherTextColor: Colors.grey[400],
    threadListDividerColor: Colors.grey[700],
    threadListBackgroundColor: Colors.grey[900],
    voteBetListBackgroundColor: Colors.grey[900],
    voteBetListOptionSelectedColor: Colors.grey[300],
    voteBetListOptionUnselectedColor: Colors.grey[500],
    voteBetListOptionDividerColor: Colors.grey[700],
    notificationListTileTitleColor: Colors.grey[300],
    notificationListTileOtherTextColor: Colors.grey[400],
    settingItemCellMainColor: Colors.grey[300],
    settingItemCellSubColor: Colors.grey[500],
    mePageBackgroundColor: Colors.grey[900],
    mePageTextColor: Colors.grey[300],
    mePageIconColor: Colors.grey[300],
    mePageUserIdColor: Colors.grey[200],
    mePageUsernameColor: Colors.grey[200],
    mePageSelectedColor: Colors.blue,
    sectionPageBackgroundColor: Colors.grey[900],
    sectionPageContentColor: Colors.grey[300],
    voteBetTitleColor: Colors.grey[300],
    voteBetOtherTextColor: Colors.grey[500],
    voteBetOptionTextColor: Colors.grey[400],
    voteBetBarBaseColor: Colors.grey[700],
    voteBetBarFillColor: Colors.blue,
    voteBetOptionTickUnselectedColor: Colors.grey[500],
    voteBetOptionTickSelectedColor: Colors.blue,
    voteBetOptionPercentageTextColor: Colors.grey[400],
    voteBetOptionTickedBarFillColor: Colors.purple,
    voteBetOptionResultBarFillColor: Colors.red,
    voteBetOptionButtonBackgroundColor: Colors.blue,
    voteBetOptionButtonTextColor: Colors.grey[300],
    threadPageTopBarButtonColor: Colors.grey[300],
    threadPageTopBarMenuColor: Colors.grey[300],
    threadPageBackgroundColor: Colors.grey[900],
    threadPageDividerColor: Colors.grey[700],
    threadPageButtonUnselectedColor: Colors.grey[500],
    threadPageButtonSelectedColor: Colors.blue,
    threadPageTextUnselectedColor: Colors.grey[500],
    threadPageTextSelectedColor: Colors.blue,
    threadPageVoteUpDownUnpickedColor: Colors.grey[500],
    threadPageVoteUpPickedColor: Colors.blue,
    threadPageVoteDownPickedColor: Colors.blue,
    threadPageVoteUpDownNumberColor: Colors.grey[500],
    threadPageTitleColor: Colors.grey[300],
    threadPageContentColor: Colors.grey[400],
    threadPageQuoteColor: Colors.grey[500],
    threadPageOtherTextColor: Colors.grey[500],
    threadPageReplyBarBackgroundColor: Colors.grey[600],
    threadPageReplyBarButtonBackgroundColor: Colors.grey[500],
    threadPageReplyBarInputBackgroundColor: Colors.grey[700],
    threadPagePageNumberBackgroundColor: Colors.grey[600],
    threadPagePageNumberTextColor: Colors.grey[300],
    emoticonPanelTopBarTitleUnselectedBackgroundColor: Colors.grey[850],
    emoticonPanelTopBarTitleSelectedBackgroundColor: Colors.grey[600],
    emoticonPanelTopBarTitleUnselectedTextColor: Colors.grey[500],
    emoticonPanelTopBarTitleSelectedTextColor: Colors.grey[300],
    editPageTopBarButtonColor: Colors.grey[300],
    editPageBackgroundColor: Colors.grey[900],
    editPagePlaceholderColor: Colors.grey[500],
    editPageButtonIconColor: Colors.grey[500],
    editPageButtonTextColor: Colors.grey[500],
    inMailTopBarButtonColor: Colors.grey[300],
    inMailBackgroundColor: Colors.grey[900],
    inMailTitleColor: Colors.grey[300],
    inMailContentColor: Colors.grey[400],
    dialogBackgroundColor: Colors.grey[900],
    dialogTitleColor: Colors.grey[300],
    dialogContentColor: Colors.grey[400],
    dialogButtonBackgroundColor: Colors.grey[900],
    dialogButtonTextColor: Colors.blue,
    maleUserIdColor: Colors.blue,
    femaleUserIdColor: Colors.pink,
    otherUserIdColor: Colors.grey[400],
    userPagePrimaryBackgroundColor: Colors.grey[800],
    userPageSecondaryBackgroundColor: Colors.grey[900],
    userPageTextColor: Colors.grey[300],
    userPageButtonBackgroundColor: Colors.grey[500],
    userPageButtonFillColor: Colors.grey[300],
    otherPageTopBarButtonColor: Colors.grey[300],
    otherPageTopBarMenuColor: Colors.grey[300],
    otherPagePrimaryColor: Colors.grey[900],
    otherPageSecondaryColor: Colors.grey[700],
    otherPageButtonColor: Colors.blue,
    otherPageDividerColor: Colors.grey[700],
    otherPagePrimaryTextColor: Colors.grey[300],
    otherPageSecondaryTextColor: Colors.grey[400],
  );
}
