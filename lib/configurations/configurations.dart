import 'package:byr_mobile_app/local_objects/local_storage.dart';
import 'package:secrets/secrets.dart';

class AppConfigs {
  static const String version = '3.2.2';
  static const clientID = Secrets.clientID;
  static const appleID = Secrets.appleID;
  static const bundleID = Secrets.bundleID;
  static const identifier = Secrets.identifier;
  static const welcomeSalt = Secrets.welcomeSalt;
  static const String relativeDownloadPath = '/BYRDownload/';
  static const String hiveBoxName = 'byr_local_data_box';
  static bool _isIPv6Used = false;

  static void initializeAppConfigs() {
    _isIPv6Used = LocalStorage.getIsIPv6Used();
  }

  static void useIPv6(bool v) {
    _isIPv6Used = v;
    LocalStorage.setIsIPv6Used(v);
  }

  static bool get isIPv6Used {
    return _isIPv6Used;
  }
}
