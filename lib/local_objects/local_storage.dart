import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

// part 'local_storage.g.dart';

/// list of locally stored key value pairs
///
/// bool `isDevChannelEnabled`: whether the app is on dev channel, only for Android
///
/// bool `isToptenScreenshotEnabled`: whether to take screenshot after bottom pull up in topten page
///
/// String `locale`: locale of the app
///
/// bool `isAutoTheme`: whether is theme turning dark and light automatically
///
/// String `currentTheme`: current theme name
///
/// int `welver`: current welcome image version
///
/// Map<String, String> `tokensWithIds`: stored access tokens as keys with user IDs as values
///
/// String `currentToken`: current access token
///
/// bool `isIPv6Used`: whether the IPv6 is used
///
/// Map<String, List<Map<String, dynamic>>> `frontPageTabs`: map of list of tabs to be shown on front page for each id
///
/// List<Map<String, String>> `refreshers`: map of refreshers
///
/// bool `isAnonymous`: whether is anonymous to post for IWhisper board
///
/// String `ignoreVersion`: ignore the update notification of certain version
///
/// String `appBarStyle`: app bar style number
///
/// Map<String, bool> `featureKeys`: new feature hint keys

class LocalStorage {
  static Box _box;

  static Future<void> initialization() async {
    await Hive.initFlutter();
    _box = await Hive.openBox("byr_mobile_app_data_box");
  }

  static Future<void> clear() async {
    await _box.clear();
  }

  // static bool _contains(dynamic key) {
  //   return _box.containsKey(key);
  // }

  static dynamic _extract(dynamic key) {
    return _box.get(key);
  }

  static Future<void> _enter(dynamic key, dynamic value) async {
    return await _box.put(key, value);
  }

  static bool getIsDevChannelEnabled() {
    return _extract("isDevChannelEnabled") ?? false;
  }

  static Future<void> setIsDevChannelEnabled(bool v) async {
    return await _enter("isDevChannelEnabled", v);
  }

  static bool getIsToptenScreenshotEnabled() {
    return _extract("isToptenScreenshotEnabled") ?? false;
  }

  static Future<void> setIsToptenScreenshotEnabled(bool v) async {
    return await _enter("isToptenScreenshotEnabled", v);
  }

  static String getLocale() {
    return _extract("locale") ?? Get.locale.toString();
  }

  static Future<void> setLocale(String v) async {
    return await _enter("locale", v);
  }

  static bool getIsAutoTheme() {
    return _extract("isAutoTheme") ?? false;
  }

  static Future<void> setIsAutoTheme(bool v) async {
    return await _enter("isAutoTheme", v);
  }

  static String getCurrentTheme() {
    return _extract("currentTheme") ?? "Light Theme";
  }

  static Future<void> setCurrentTheme(String v) async {
    return await _enter("currentTheme", v);
  }

  static Map<String, String> getLocalThemes() {
    return _extract("localThemes").cast<String, String>() ?? Map<String, String>();
  }

  static Future<void> setLocalThemes(Map<String, String> v) async {
    return await _enter("localThemes", v);
  }

  static int getWelver() {
    return _extract("welver") ?? -1;
  }

  static Future<void> setWelver(int v) async {
    return await _enter("welver", v);
  }

  static Map<String, String> getTokensWithIds() {
    return _extract("tokensWithIds")?.cast<String, String>() ?? Map<String, String>();
  }

  static Future<void> setTokensWithIds(Map<String, String> v) async {
    return await _enter("tokensWithIds", v);
  }

  static String getCurrentToken() {
    return _extract("currentToken") ?? "";
  }

  static Future<void> setCurrentToken(String v) async {
    return await _enter("currentToken", v);
  }

  static bool getIsIPv6Used() {
    return _extract("isIPv6Used") ?? false;
  }

  static Future<void> setIsIPv6Used(bool v) async {
    return await _enter("isIPv6Used", v);
  }

  static Map<String, List> getFrontPageTabs() {
    return _extract("frontPageTabs")?.cast<String, List>() ?? Map<String, List>();
  }

  static Future<void> setFrontPageTabs(Map<String, List> v) async {
    return await _enter("frontPageTabs", v);
  }

  static List<Map> getRefreshers() {
    return _extract("refreshers")?.cast<Map>() ?? List<Map>();
  }

  static Future<void> setRefreshers(List<Map> v) async {
    return await _enter("refreshers", v);
  }

  static bool getIsAnonymous() {
    return _extract("isAnonymous")?.cast<bool>() ?? true;
  }

  static Future<void> setIsAnonymous(bool v) async {
    return await _enter("isAnonymous", v);
  }

  static String getIgnoreVersion() {
    return _extract("ignoreVersion") ?? "...";
  }

  static Future<void> setIgnoreVersion(String v) async {
    return await _enter("ignoreVersion", v);
  }

  static String getAppBarStyle() {
    return _extract("appBarStyle") ?? "100";
  }

  static Future<void> setAppBarStyle(String v) async {
    return await _enter("appBarStyle", v);
  }

  static Map<String, bool> getFeatureKeys() {
    return _extract("featureKeys").cast<String, bool>() ?? Map<String, bool>();
  }

  static Future<void> setFeatureKeys(Map<String, bool> v) async {
    return await _enter("featureKeys", v);
  }
}
