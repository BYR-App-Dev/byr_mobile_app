import 'package:byr_mobile_app/local_objects/local_storage.dart';
import 'package:byr_mobile_app/nforum/nforum_service.dart';

class TabModel {
  String title;
  String key;
  bool checked;
  bool editable;

  TabModel(this.title, this.key, {this.checked: true, this.editable: true});

  TabModel.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        key = json['key'],
        checked = json['checked'],
        editable = json['editable'];

  Map<String, dynamic> toJson() => {
        'title': title,
        'key': key,
        'checked': checked,
        'editable': editable,
      };

  static Future<void> saveFrontPageTabs(List<TabModel> tabs) async {
    List<Map<String, dynamic>> linkMap = [];
    for (var tab in tabs) {
      if (tab.checked == true) {
        linkMap.add({
          'title': tab.title,
          'key': tab.key,
          'checked': true,
          'editable': tab.editable,
        });
      }
    }
    String currentId = NForumService.getIdByToken(NForumService.currentToken);
    var allTabs = LocalStorage.getFrontPageTabs();
    allTabs[currentId] = linkMap;
    await LocalStorage.setFrontPageTabs(allTabs);
  }

  static List<TabModel> getFrontPageTabs() {
    String currentId = NForumService.getIdByToken(NForumService.currentToken);
    if (currentId.length > 0) {
      List<TabModel> tabs = [];
      var allTabs = LocalStorage.getFrontPageTabs();
      List<Map> linkMap = allTabs[currentId]?.cast<Map>();
      if (linkMap != null) {
        for (var map in linkMap) {
          tabs.add(TabModel.fromJson(map.cast<String, dynamic>()));
        }
        return tabs;
      }
    }
    return [];
  }
}
