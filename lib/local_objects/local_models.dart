import 'package:byr_mobile_app/local_objects/local_storage.dart';
import 'package:byr_mobile_app/nforum/nforum_service.dart';
import 'package:byr_mobile_app/nforum/nforum_structures.dart';
import 'package:json_annotation/json_annotation.dart';

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

@JsonSerializable()
class HistoryArticleModel extends ArticleBaseModel {
  @override
  int get hashCode => _getHistoryId(this).hashCode;
  @override
  bool operator ==(Object other) {
    if (other is HistoryArticleModel) {
      return this.hashCode == other.hashCode;
    }
    return super.hashCode == other.hashCode;
  }

  static String _getHistoryId(HistoryArticleModel a) {
    return a.boardName ?? "" + "/" + (a.groupId ?? "").toString();
  }

  int createdTime;
  String title;
  var postTime;
  @JsonKey(name: 'bname')
  var boardName;
  @JsonKey(name: 'gid')
  var groupId;
  UserModel user;

  HistoryArticleModel({
    this.createdTime,
    this.title,
    this.postTime,
    this.boardName,
    this.groupId,
    this.user,
  }) : super(
          groupId: groupId,
          title: title,
          postTime: postTime,
          user: user,
          boardName: boardName,
        );

  factory HistoryArticleModel.fromJson(Map<String, dynamic> json) => _$HistoryArticleModelFromJson(json);

  Map<String, dynamic> toJson() => _$HistoryArticleModelToJson(this);
}

class HistoryListModel extends ArticleListBaseModel<HistoryArticleModel> {
  List<HistoryArticleModel> article;
  PaginationModel pagination;

  factory HistoryListModel.fromList(List<HistoryArticleModel> s) {
    return HistoryListModel(article: s, pagination: PaginationModel(1, 1, s.length, s.length));
  }

  HistoryListModel({
    this.article,
    this.pagination,
  }) : super(
          pagination: pagination,
          article: article,
        );
}

@JsonSerializable()
class HistoryModel {
  Set<HistoryArticleModel> article;

  HistoryModel({
    this.article,
  });

  factory HistoryModel.fromJson(Map<String, dynamic> json) {
    return HistoryModel(
      article: (json['article'] as List)
          ?.map((e) => e == null ? null : HistoryArticleModel.fromJson(e.cast<String, dynamic>()))
          ?.toSet(),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'article': this.article?.map((e) => e.toJson())?.toList(),
    };
  }

  static Future<void> _saveHistory(HistoryModel history) async {
    return await LocalStorage.setHistory(history.toJson());
  }

  static HistoryModel _getHistory() {
    try {
      return HistoryModel.fromJson(LocalStorage.getHistory());
    } catch (e) {
      return HistoryModel(article: {});
    }
  }

  static List<HistoryArticleModel> ordered() {
    return _history.article.toList()
      ..sort((a, b) {
        return b.createdTime - a.createdTime;
      });
  }

  static int _historyLimit = 100;
  static HistoryModel _history;
  static void startHistory() {
    _history = _getHistory();
    if (_history == null) {
      _history = HistoryModel(article: Set());
    }
    if (_history.article == null) {
      _history.article = Set();
    }
    _history.article = ordered().sublist(0, _historyLimit).toSet();
  }

  static void addHistoryItem(HistoryArticleModel a) {
    if (_history == null) {
      _history = HistoryModel(article: Set());
    }
    if (_history.article == null) {
      _history.article = Set();
    }
    if (_history.article.contains(a)) {
      _history.article.remove(a);
      _history.article.add(a);
    } else {
      _history.article.add(a);
    }
    _saveHistory(_history);
  }
}

HistoryArticleModel _$HistoryArticleModelFromJson(Map<String, dynamic> json) {
  return HistoryArticleModel(
    createdTime: json['createdTime'] as int,
    title: json['title'] as String,
    postTime: json['post_time'],
    boardName: json['bname'],
    groupId: json['gid'],
    user: json['user'] == null ? null : UserModel.fromJson(json['user'].cast<String, dynamic>()),
  );
}

Map<String, dynamic> _$HistoryArticleModelToJson(HistoryArticleModel instance) => <String, dynamic>{
      'createdTime': instance.createdTime,
      'title': instance.title,
      'post_time': instance.postTime,
      'bname': instance.boardName,
      'gid': instance.groupId,
      'user': instance.user,
    };
