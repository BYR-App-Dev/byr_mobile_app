import 'dart:convert';
import 'dart:io';

import 'package:byr_mobile_app/configurations/configurations.dart';
import 'package:byr_mobile_app/data_structures/image_file.dart';
import 'package:byr_mobile_app/local_objects/local_storage.dart';
import 'package:byr_mobile_app/networking/http_request.dart';
import 'package:byr_mobile_app/nforum/nforum_structures.dart';
import 'package:byr_mobile_app/nforum/nforum_text_parser.dart';
import 'package:byr_mobile_app/pages/pages.dart';
import 'package:byr_mobile_app/reusable_components/event_bus.dart';
import 'package:secrets/secrets.dart';
import 'package:byr_mobile_app/shared_objects/shared_objects.dart';
import 'package:crypto/crypto.dart' as crypto;
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:tuple/tuple.dart';

class APIException implements Exception {
  final message;
  final code;

  APIException(this.message, {this.code});

  String toString() {
    if (message == null) return "API Exception";
    return "API Exception: $message";
  }
}

class DataException implements Exception {
  final message;

  DataException([this.message]);

  String toString() {
    if (message == null) return "Data Exception";
    return "Data Exception: $message";
  }
}

class NForumSpecs {
  static String get bbsURL => AppConfigs.isIPv6Used ? 'https://bbs6.byr.cn/' : 'https://bbs.byr.cn/';
  static String get baseURL => bbsURL + 'open/';
  static String get tokenURL => bbsURL + Secrets.tokenDir;
  static bool _isAnonymous = false;
  static bool get isAnonymous => _isAnonymous;
  static String byrFaceM = NForumSpecs.bbsURL + "img/face_default_m.jpg";
  static String byrFaceF = NForumSpecs.bbsURL + "img/face_default_f.jpg";
  static const attachmentSize = 5242880;

  static String get androidUpdateLink => Secrets.androidStableUpdateLink;
  static String get androidVersionsLink => Secrets.androidVersionsLink;

  static String get microPluginListLink => Secrets.microPluginListLink;

  static initializeNForumSpecs() {
    _isAnonymous = LocalStorage.getIsAnonymous();
  }

  static void setAnonymous({bool value}) {
    LocalStorage.setIsAnonymous(value ?? true);
    _isAnonymous = value ?? true;
  }

  static void setUnanonymous() {
    LocalStorage.setIsAnonymous(false);
    _isAnonymous = false;
  }
}

enum ReferType { Reply, At }

class NForumService {
  static String _currentToken;
  static String get currentToken => _currentToken;

  static void loadCurrentToken() {
    if (LocalStorage.getCurrentToken().length > 0) {
      _currentToken = LocalStorage.getCurrentToken();
    }
  }

  static Future<bool> logoutUser(String token) async {
    Map<String, String> tokenMap = LocalStorage.getTokensWithIds();
    if (tokenMap[token] != null) {
      tokenMap.remove(token);
      LocalStorage.setTokensWithIds(tokenMap);
    }
    if (_currentToken == token) {
      await LocalStorage.setCurrentToken('');
    }
    return true;
  }

  static String getIdByToken(String token) {
    Map<String, String> tokenMap = LocalStorage.getTokensWithIds();
    return tokenMap[token] ?? '';
  }

  static Future<bool> loginUser(String token) async {
    Map<String, String> tokenMap = LocalStorage.getTokensWithIds();
    await LocalStorage.setCurrentToken(token);
    loadCurrentToken();
    var selfInfo = getSelfUserInfo();
    eventBus.emit(UPDATE_MAIN_TAB_SETTING);
    if (selfInfo != null && await selfInfo != null) {
      SharedObjects.me = selfInfo;
      UserModel userInfo = await SharedObjects.me;
      tokenMap[token] = userInfo.id;
      await LocalStorage.setTokensWithIds(tokenMap);
    }
    return true;
  }

  static Future<void> loadMe() async {
    Map<String, String> tokenMap = LocalStorage.getTokensWithIds();
    var selfInfo = getSelfUserInfo();
    if (selfInfo != null) {
      SharedObjects.me = selfInfo;
      UserModel userInfo = await SharedObjects.me;
      if (userInfo != null) {
        tokenMap[currentToken] = userInfo.id;
        await LocalStorage.setTokensWithIds(tokenMap);
      }
    }
    return true;
  }

  static List getAllUser() {
    Map<String, String> tokens = LocalStorage.getTokensWithIds();
    List users = [];
    for (final tokenWithId in tokens.entries) {
      users.add({'token': tokenWithId.key, 'id': tokenWithId.value});
    }
    return users;
  }

  static Future<Map<dynamic, dynamic>> getAndroidLatest() {
    return Request.httpGet(NForumSpecs.androidUpdateLink, {}).then((response) {
      Utf8Decoder utf8decoder = Utf8Decoder();
      Map resultMap = json.decode(utf8decoder.convert(response.bodyBytes));
      return resultMap;
    });
  }

  static Future<Map<dynamic, dynamic>> getAndroidVersions() {
    return Request.httpGet(NForumSpecs.androidVersionsLink, {}).then((response) {
      Map resultMap = jsonDecode(response.body);
      return resultMap;
    });
  }

  static String makeBBSURL(String originalUrl) {
    return originalUrl.replaceFirst(
      'static.byr',
      'bbs.byr',
    );
  }

  static String makeThreadURL(String boardName, int threadId) {
    return NForumSpecs.bbsURL + 'article/' + (boardName ?? "") + '/' + (threadId ?? "").toString();
  }

  static String makeBetURL(String bid) {
    return NForumSpecs.bbsURL + 'bet/view/' + (bid ?? "").toString();
  }

  static String makeVoteURL(String vid) {
    return NForumSpecs.bbsURL + 'vote/view/' + (vid ?? "").toString();
  }

  static String makeGetURL(String originalUrl) {
    return makeBBSURL(originalUrl) + '?oauth_token=' + currentToken;
  }

  static String makeGetAttachmentURL(String originalUrl) {
    return makeGetURL(
      makeBBSURL(originalUrl).replaceFirst('/api/', '/open/'),
    );
  }

  static Future<ImageFile> getImage(String url) async {
    var img = await DefaultCacheManager().getFileFromCache(url);
    ImageFile imgFile;
    if (img == null) {
      imgFile = await Request.httpGet(makeBBSURL(url), null).then((response) {
        var slashL = response.headers["content-type"].lastIndexOf('/');
        return DefaultCacheManager()
            .putFile(
          url,
          response.bodyBytes,
          fileExtension: response.headers["content-type"].substring(slashL + 1),
        )
            .then((v) {
          return ImageFile(
            ext: response.headers["content-type"].substring(slashL + 1),
            bytes: response.bodyBytes,
            path: v.path,
          );
        });
      });
    } else {
      imgFile = ImageFile(
        ext: img.file.path.substring(img.file.path.lastIndexOf('.') + 1),
        bytes: await img.file.readAsBytes(),
        path: img.file.path,
      );
    }
    return imgFile;
  }

  static Future<List<String>> getRecommendedBoards() async {
    var response;
    try {
      response = await Request.httpGet(NForumSpecs.baseURL + "recommend_boards.json", null);
    } catch (e) {
      throw e;
    }
    Map resultMap = jsonDecode(
      ascii.decode(response.bodyBytes),
    );
    if (resultMap["code"] != null) {
      throw APIException(resultMap['msg'], code: resultMap["code"]);
    }
    var result = resultMap["recommended_boards"].cast<String>();
    if (result == null) {
      throw DataException();
    }
    return result;
  }

  // static Future<MicroPluginListModel> getMicroPlugins() async {
  //   var response;
  //   try {
  //     response = await Request.httpGet(NForumSpecs.microPluginListLink, null);
  //   } catch (e) {
  //     throw e;
  //   }
  //   Map resultMap = jsonDecode(response.body);
  //   if (resultMap["code"] != null) {
  //     throw APIException(resultMap['msg'], code: resultMap["code"]);
  //   }

  //   var result = MicroPluginListModel.fromJson(resultMap);
  //   result.pagination = PaginationModel(1, 1, result.article.length, result.article.length);
  //   if (result == null) {
  //     throw DataException();
  //   }
  //   return result;
  // }

  static Future<WelcomeInfo> getWelcomeInfo() async {
    return Request.httpGet(NForumSpecs.baseURL + 'welcomeimg.json', null).then((response) {
      Map resultMap = jsonDecode(
        ascii.decode(response.bodyBytes),
      );
      if (resultMap["code"] != null) {
        throw APIException(resultMap['msg'], code: resultMap["code"]);
      }
      var result = WelcomeInfo.fromJson(resultMap);
      if (result == null) {
        throw DataException();
      }
      return result;
    }).catchError((e) {
      throw e;
    });
  }

  static Future<OAuthInfo> postLoginInfo(String username, String password) async {
    var date = DateTime.now().millisecondsSinceEpoch / 1000;
    var dateStr = date.round().toString();
    var sourceStr = dateStr + Secrets.identifier;
    var digest = crypto.md5.convert(
      Utf8Encoder().convert(Secrets.clientID + Secrets.appleID + Secrets.bundleID + dateStr),
    );
    var appKey = digest.toString();
    var body = {
      'appkey': appKey,
      'source': sourceStr,
      'username': Base64Encoder().convert(username.codeUnits),
      'password': Base64Encoder().convert(password.codeUnits)
    };
    return Request.httpPost(NForumSpecs.tokenURL, body).then((response) {
      var resultMap = jsonDecode(
        ascii.decode(response.bodyBytes),
      );
      if (resultMap["code"] != null) {
        return OAuthErrorInfo.fromJson(resultMap);
      } else {
        return OAuthAccessInfo.fromJson(resultMap);
      }
    });
  }

  static Future<UserModel> getSelfUserInfo() async {
    if (currentToken == null) {
      return null;
    }
    return Request.httpGet(
      NForumSpecs.baseURL + 'user/getinfo.json',
      {
        'oauth_token': currentToken,
      },
    ).then(
      (response) {
        Map resultMap = jsonDecode(response.body);
        return UserModel.fromJson(resultMap);
      },
    );
  }

  static Future<ToptenModel> getTopten() async {
    return Request.httpGet(NForumSpecs.baseURL + 'widget/topten.json', {'oauth_token': currentToken}).then((response) {
      Map resultMap = jsonDecode(response.body);
      if (resultMap["code"] != null) {
        throw APIException(resultMap['msg'], code: resultMap["code"]);
      }
      var result = ToptenModel.fromJson(resultMap);
      if (result == null) {
        throw DataException();
      }
      return result;
    }).catchError((e) {
      throw e;
    });
  }

  static Future<TimelineModel> getTimeline(int page) async {
    return Request.httpGet(
      NForumSpecs.baseURL + 'favorpost.json',
      {
        'oauth_token': currentToken,
        'page': page,
      },
    ).then((response) {
      Map resultMap = jsonDecode(response.body);
      if (resultMap["code"] != null) {
        throw APIException(resultMap['msg'], code: resultMap["code"]);
      }
      var result = TimelineModel.fromJson(resultMap);
      if (result == null) {
        throw DataException();
      }
      return result;
    }).catchError((e) {
      throw e;
    });
  }

  static Future<ThreadModel> getThread(String boardName, int threadId,
      {int page, int count = PageConfig.pageItemCount, String author, int mode}) async {
    return Request.httpGet(NForumSpecs.baseURL + 'threads/' + boardName + '/' + threadId.toString() + '.json', {
      'oauth_token': currentToken,
      'page': page,
      'count': count,
      'au': author,
      "mode": mode,
    }).then((response) {
      Map resultMap = jsonDecode(response.body);
      if (resultMap["code"] != null) {
        throw APIException(resultMap['msg'], code: resultMap["code"]);
      }
      var result = ThreadModel.fromJson(resultMap);
      if (result == null) {
        throw DataException();
      }
      return result;
    }).catchError((e) {
      throw e;
    });
  }

  static Future<BetModel> getBet(int bid) async {
    return Request.httpGet(NForumSpecs.baseURL + 'bet/' + bid.toString() + '.json', {
      'oauth_token': currentToken,
    }).then((response) {
      Map resultMap = jsonDecode(response.body);
      if (resultMap["code"] != null) {
        throw APIException(resultMap['msg'], code: resultMap["code"]);
      }
      var result = BetModel.fromJson(resultMap);
      if (result == null) {
        throw DataException();
      }
      return result;
    }).catchError((e) {
      throw e;
    });
  }

  static Future<Map> betOn(int bid, int biid, int score) async {
    var response;
    try {
      response = await Request.httpPost(
        NForumSpecs.baseURL + 'bet/' + bid.toString() + '.json',
        {
          'oauth_token': currentToken,
          'biid': biid,
          'score': score,
        },
      );
    } catch (e) {
      throw e;
    }
    Map resultMap = jsonDecode(response.body);
    if (resultMap["code"] != null) {
      throw APIException(resultMap['msg'], code: resultMap["code"]);
    }
    var result = resultMap;
    if (result == null) {
      throw DataException();
    }
    return result;
  }

  static Future<BetCategoriesModel> getBetCategory() async {
    return Request.httpGet(NForumSpecs.baseURL + 'bet/' + 'allCate' + '.json', {
      'oauth_token': currentToken,
    }).then((response) {
      Map resultMap = jsonDecode(response.body);
      if (resultMap["code"] != null) {
        throw APIException(resultMap['msg'], code: resultMap["code"]);
      }
      var result = BetCategoriesModel.fromJson(resultMap);
      if (result == null) {
        throw DataException();
      }
      return result;
    }).catchError((e) {
      throw e;
    });
  }

  static Future<BetListModel> getBetList(BetAttrType betAttrType, {int cid = 0, int page = 1, int count = 20}) async {
    return Request.httpGet(
        NForumSpecs.baseURL + 'bet/category/' + NForumTextParser.getStrippedEnumValue(betAttrType) + '.json', {
      'oauth_token': currentToken,
      'cid': cid,
      'page': page,
      'count': count,
    }).then((response) {
      Map resultMap = jsonDecode(response.body);
      if (resultMap["code"] != null) {
        throw APIException(resultMap['msg'], code: resultMap["code"]);
      }
      resultMap['pagination'].forEach((k, v) {
        if (v is String) {
          resultMap['pagination'][k] = int.tryParse(v) ?? 0;
        }
      });
      var result = BetListModel.fromJson(resultMap);
      if (result == null) {
        throw DataException();
      }
      return result;
    }).catchError((e) {
      throw e;
    });
  }

  static Future<VoteModel> getVote(int vid) async {
    return Request.httpGet(NForumSpecs.baseURL + 'vote/' + vid.toString() + '.json', {
      'oauth_token': currentToken,
    }).then((response) {
      Map resultMap = jsonDecode(response.body);
      if (resultMap["code"] != null) {
        throw APIException(resultMap['msg'], code: resultMap["code"]);
      }
      var result = VoteModel.fromJson(resultMap);
      if (result == null) {
        throw DataException();
      }
      return result;
    }).catchError((e) {
      throw e;
    });
  }

  static Future<Map> voteOn(int vid, List<int> viids, bool isMultiple) async {
    var param = Map<String, String>();
    for (int i = 0; i < viids.length; i++) {
      param["vote[" + i.toString() + "]"] = viids[i].toString();
    }
    param['oauth_token'] = currentToken;
    var response;
    try {
      response = await Request.httpPost(
        NForumSpecs.baseURL + 'vote/' + vid.toString() + '.json',
        isMultiple
            ? param
            : {
                'oauth_token': currentToken,
                'vote': viids[0],
              },
      );
    } catch (e) {
      throw e;
    }
    Map resultMap = jsonDecode(response.body);
    if (resultMap["code"] != null) {
      throw APIException(resultMap['msg'], code: resultMap["code"]);
    }
    var result = resultMap;
    if (result == null) {
      throw DataException();
    }
    return result;
  }

  static Future<VoteListModel> getVoteList(VoteAttrType voteAttrType, {String u, int page = 1, int count = 20}) async {
    return Request.httpGet(
        NForumSpecs.baseURL + 'vote/category/' + NForumTextParser.getStrippedEnumValue(voteAttrType) + '.json', {
      'oauth_token': currentToken,
      'page': page,
      'count': count,
      'user': u,
    }).then((response) {
      Map resultMap = jsonDecode(response.body);
      if (resultMap["code"] != null) {
        throw APIException(resultMap['msg'], code: resultMap["code"]);
      }
      resultMap['pagination'].forEach((k, v) {
        if (v is String) {
          resultMap['pagination'][k] = int.tryParse(v) ?? 0;
        }
      });
      var result = VoteListModel.fromJson(resultMap);
      if (result == null) {
        throw DataException();
      }
      return result;
    }).catchError((e) {
      throw e;
    });
  }

  static Future<Map> postArticle(String boardName, String title, String content,
      {int reId, bool anonymousSpecial}) async {
    bool anony = anonymousSpecial ?? NForumSpecs.isAnonymous;
    var response;
    try {
      response = await Request.httpPost(
        NForumSpecs.baseURL + 'article/' + boardName + '/' + 'post' + '.json',
        {
          'oauth_token': currentToken,
          'title': title,
          'content': content,
          'reid': reId,
          "anonymous": anony ? 1 : 0,
        },
      );
    } catch (e) {
      throw e;
    }
    Map resultMap = jsonDecode(response.body);
    if (resultMap["code"] != null) {
      throw APIException(resultMap['msg'], code: resultMap["code"]);
    }
    var result = resultMap;
    if (result == null) {
      throw DataException();
    }
    return result;
  }

  static Future<Map> updateArticle(
    String boardName,
    int id,
    String title,
    String content,
  ) async {
    var response;
    try {
      response = await Request.httpPost(
        NForumSpecs.baseURL + 'article/$boardName/update/$id.json',
        {
          'oauth_token': currentToken,
          'title': title,
          'content': content,
        },
      );
    } catch (e) {
      throw e;
    }
    Map resultMap = jsonDecode(response.body);
    if (resultMap["code"] != null) {
      throw APIException(resultMap['msg'], code: resultMap["code"]);
    }
    var result = resultMap;
    if (result == null) {
      throw DataException();
    }
    return result;
  }

  static Future<bool> likeArticle(String boardName, int id) async {
    return Request.httpGet(NForumSpecs.baseURL + 'article/' + boardName + '/like/' + id.toString() + '.json', {
      'oauth_token': currentToken,
    }).then((response) {
      Map resultMap = jsonDecode(response.body);
      if (resultMap["code"] != null) {
        return false;
      }
      return true;
    });
  }

  static Future<bool> votedownArticle(String boardName, int id) async {
    return Request.httpGet(NForumSpecs.baseURL + 'article/' + boardName + '/votedown/' + id.toString() + '.json', {
      'oauth_token': currentToken,
    }).then((response) {
      Map resultMap = jsonDecode(response.body);
      if (resultMap["code"] != null) {
        return false;
      }
      return true;
    });
  }

  static Future<bool> deleteArticle(String boardName, int id) async {
    return Request.httpPost(
      NForumSpecs.baseURL + 'article/' + boardName + '/delete/' + id.toString() + '.json',
      {
        'oauth_token': currentToken,
      },
    ).then(
      (response) {
        Map resultMap = jsonDecode(response.body);
        if (resultMap["code"] != null) {
          return false;
        }
        return true;
      },
    );
  }

  static Future<BannerModel> getBanner() async {
    return Request.httpGet(NForumSpecs.baseURL + 'banner.json', {'oauth_token': currentToken}).then((response) {
      Map resultMap = jsonDecode(response.body);
      if (resultMap["code"] != null) {
        throw APIException(resultMap['msg'], code: resultMap["code"]);
      }
      var result = BannerModel.fromJson(resultMap);
      if (result == null) {
        throw DataException();
      }
      return result;
    }).catchError((e) {
      throw e;
    });
  }

  static Future<FavBoardsModel> getFavBoards() async {
    return Request.httpGet(NForumSpecs.baseURL + 'favorite/0.json', {'oauth_token': currentToken}).then((response) {
      Map resultMap = jsonDecode(response.body);
      if (resultMap["code"] != null) {
        throw APIException(resultMap['msg'], code: resultMap["code"]);
      }
      FavBoardsModel f = FavBoardsModel.fromJson(resultMap);
      if (f == null) {
        throw DataException();
      }
      f.board.sort((a, b) => b.threadsTodayCount.compareTo(a.threadsTodayCount));
      return f;
    }).catchError((e) {
      throw e;
    });
  }

  static Future<FavBoardsModel> addFavBoard(String boardName) async {
    return Request.httpPost(
      NForumSpecs.baseURL + 'favorite/add/0.json',
      {
        'oauth_token': currentToken,
        'name': boardName,
        'dir': 0,
      },
    ).then((response) {
      Map resultMap = jsonDecode(response.body);
      if (resultMap["code"] != null) {
        throw APIException(resultMap['msg'], code: resultMap["code"]);
      }
      var result = FavBoardsModel.fromJson(resultMap);
      if (result == null) {
        throw DataException();
      }
      return result;
    }).catchError((e) {
      throw e;
    });
  }

  static Future<FavBoardsModel> delFavBoard(String boardName) async {
    return Request.httpPost(
      NForumSpecs.baseURL + 'favorite/delete/0.json',
      {
        'oauth_token': currentToken,
        'name': boardName,
        'dir': 0,
      },
    ).then((response) {
      Map resultMap = jsonDecode(response.body);
      if (resultMap["code"] != null) {
        throw APIException(resultMap['msg'], code: resultMap["code"]);
      }
      var result = FavBoardsModel.fromJson(resultMap);
      if (result == null) {
        throw DataException();
      }
      return result;
    }).catchError((e) {
      throw e;
    });
  }

  static Future<BoardModel> getBoard(String boardName, {int page = 1, int count = 30, int content}) async {
    return Request.httpGet(NForumSpecs.baseURL + 'board/$boardName.json', {
      'oauth_token': currentToken,
      'page': page,
      'count': count,
      'content': content,
    }).then((response) {
      Map resultMap = jsonDecode(response.body);
      if (resultMap["code"] != null) {
        throw APIException(resultMap['msg'], code: resultMap["code"]);
      }
      var result = BoardModel.fromJson(resultMap);
      if (result == null) {
        throw DataException();
      }
      return result;
    }).catchError((e) {
      throw e;
    });
  }

  static Future<SectionListModel> getSections() async {
    return Request.httpGet(NForumSpecs.baseURL + 'section.json', {
      'oauth_token': currentToken,
    }).then((response) {
      Map resultMap = jsonDecode(response.body);
      if (resultMap["code"] != null) {
        throw APIException(resultMap['msg'], code: resultMap["code"]);
      }
      var result = SectionListModel.fromJson(resultMap);
      if (result == null) {
        throw DataException();
      }
      return result;
    }).catchError((e) {
      throw e;
    });
  }

  static Future<SectionModel> getSection(String sectionName) async {
    return Request.httpGet(NForumSpecs.baseURL + 'section/$sectionName.json', {
      'oauth_token': currentToken,
    }).then((response) {
      Map resultMap = jsonDecode(response.body);
      if (resultMap["code"] != null) {
        throw APIException(resultMap['msg'], code: resultMap["code"]);
      }
      var result = SectionModel.fromJson(resultMap);
      if (result == null) {
        throw DataException();
      }
      return result;
    }).catchError((e) {
      throw e;
    });
  }

  static Future<CollectionModel> getCollection(int page, {int count = PageConfig.pageItemCount}) async {
    return Request.httpGet(NForumSpecs.baseURL + 'collection.json', {
      'oauth_token': currentToken,
      'page': page,
      'count': count,
    }).then((response) {
      Map resultMap = jsonDecode(response.body);
      if (resultMap["code"] != null) {
        throw APIException(resultMap['msg'], code: resultMap["code"]);
      }
      var result = CollectionModel.fromJson(resultMap);
      if (result == null) {
        throw DataException();
      }
      return result;
    }).catchError((e) {
      throw e;
    });
  }

  static Future<ThreadArticleModel> addCollection(String boardName, int id) async {
    return Request.httpPost(
      NForumSpecs.baseURL + 'collection/add.json',
      {
        'oauth_token': currentToken,
        'board': boardName,
        'id': id,
      },
    ).then((response) {
      Map resultMap = jsonDecode(response.body);
      if (resultMap["code"] != null) {
        throw APIException(resultMap['msg'], code: resultMap["code"]);
      }
      var result = ThreadArticleModel.fromJson(resultMap);
      if (result == null) {
        throw DataException();
      }
      return result;
    }).catchError((e) {
      throw e;
    });
  }

  static Future<ThreadArticleModel> removeCollection(String boardName, int id) async {
    return Request.httpPost(
      NForumSpecs.baseURL + 'collection/delete.json',
      {
        'oauth_token': currentToken,
        'board': boardName,
        'id': id,
      },
    ).then((response) {
      Map resultMap = jsonDecode(response.body);
      if (resultMap["code"] != null) {
        throw APIException(resultMap['msg'], code: resultMap["code"]);
      }
      var result = ThreadArticleModel.fromJson(resultMap);
      if (result == null) {
        throw DataException();
      }
      return result;
    }).catchError((e) {
      throw e;
    });
  }

  static Future<UserListModel> getBlocklist(int page, {int count = PageConfig.pageItemCount}) async {
    return Request.httpGet(
      NForumSpecs.baseURL + 'blacklist/list.json',
      {
        'page': page,
        'count': count,
        'oauth_token': currentToken,
      },
    ).then((response) {
      Map resultMap = jsonDecode(response.body);
      if (resultMap["code"] != null) {
        throw APIException(resultMap['msg'], code: resultMap["code"]);
      }
      var result = UserListModel.fromJson(resultMap);
      if (result == null) {
        throw DataException();
      }
      return result;
    }).catchError((e) {
      throw e;
    });
  }

  static Future<bool> addBlocklistEntry(String id) async {
    return Request.httpPost(
      NForumSpecs.baseURL + 'blacklist/add.json',
      {
        'oauth_token': currentToken,
        'id': id,
      },
    ).then<bool>((response) {
      Map resultMap = jsonDecode(response.body);
      if (resultMap["code"] != null) {
        throw APIException(resultMap['msg'], code: resultMap["code"]);
      }
      return resultMap["status"];
    }).catchError((e) {
      throw e;
    });
  }

  static Future<bool> deleteBlocklistEntry(String id) async {
    return Request.httpPost(
      NForumSpecs.baseURL + 'blacklist/delete.json',
      {
        'oauth_token': currentToken,
        'id': id,
      },
    ).then<bool>((response) {
      Map resultMap = jsonDecode(response.body);
      if (resultMap["code"] != null) {
        throw APIException(resultMap['msg'], code: resultMap["code"]);
      }
      return resultMap["status"];
    }).catchError((e) {
      throw e;
    });
  }

  static Future<ReferBoxModel> getReply(int page, {int count = PageConfig.pageItemCount}) async {
    return Request.httpGet(
      NForumSpecs.baseURL + 'refer/reply.json',
      {
        'oauth_token': currentToken,
        'page': page,
        'count': count,
      },
    ).then((response) {
      Map resultMap = jsonDecode(response.body);
      if (resultMap["code"] != null) {
        throw APIException(resultMap['msg'], code: resultMap["code"]);
      }
      var result = ReferBoxModel.fromJson(resultMap);
      if (result == null) {
        throw DataException();
      }
      return result;
    }).catchError((e) {
      throw e;
    });
  }

  static Future<ReferBoxModel> getAt(int page, {int count = PageConfig.pageItemCount}) async {
    return Request.httpGet(
      NForumSpecs.baseURL + 'refer/at.json',
      {
        'oauth_token': currentToken,
        'page': page,
        'count': count,
      },
    ).then((response) {
      Map resultMap = jsonDecode(response.body);
      if (resultMap["code"] != null) {
        throw APIException(resultMap['msg'], code: resultMap["code"]);
      }
      var result = ReferBoxModel.fromJson(resultMap);
      if (result == null) {
        throw DataException();
      }
      return result;
    }).catchError((e) {
      throw e;
    });
  }

  static Future<ReferModel> setReferRead(ReferType type, int index) async {
    String t = type == ReferType.At ? 'at' : 'reply';
    return Request.httpPost(
      NForumSpecs.baseURL + 'refer/$t/setRead/$index.json',
      {
        'oauth_token': currentToken,
      },
    ).then((response) {
      Map resultMap = jsonDecode(response.body);
      if (resultMap["code"] != null) {
        throw APIException(resultMap['msg'], code: resultMap["code"]);
      }
      var result = ReferModel.fromJson(resultMap);
      if (result == null) {
        throw DataException();
      }
      return result;
    }).catchError((e) {
      throw e;
    });
  }

  static Future setReferAllRead(ReferType type) async {
    String t = type == ReferType.At ? 'at' : 'reply';
    return Request.httpPost(
      NForumSpecs.baseURL + 'refer/$t/setRead.json',
      {
        'oauth_token': currentToken,
      },
    ).then((response) {
      return;
    });
  }

  static Future<MailBoxModel> getMailBox(int page, {int count = PageConfig.pageItemCount}) async {
    return Request.httpGet(
      NForumSpecs.baseURL + 'mail/inbox.json',
      {
        'oauth_token': currentToken,
        'page': page,
        'count': count,
      },
    ).then((response) {
      Map resultMap = jsonDecode(response.body);
      if (resultMap["code"] != null) {
        throw APIException(resultMap['msg'], code: resultMap["code"]);
      }
      var result = MailBoxModel.fromJson(resultMap);
      if (result == null) {
        throw DataException();
      }
      return result;
    }).catchError((e) {
      throw e;
    });
  }

  static Future<MailModel> getMail(int index) async {
    return Request.httpGet(
      NForumSpecs.baseURL + 'mail/inbox/$index.json',
      {
        'oauth_token': currentToken,
      },
    ).then((response) {
      Map resultMap = jsonDecode(response.body);
      if (resultMap["code"] != null) {
        throw APIException(resultMap['msg'], code: resultMap["code"]);
      }
      var result = MailModel.fromJson(resultMap);
      if (result == null) {
        throw DataException();
      }
      return result;
    }).catchError((e) {
      throw e;
    });
  }

  static Future<MailModel> replyMail(int index, String title, String content) async {
    return Request.httpPost(
      NForumSpecs.baseURL + 'mail/inbox/reply/$index.json',
      {'oauth_token': currentToken, 'title': title, 'content': content, 'signature': 0, 'backup': 1},
    ).then((response) {
      Map resultMap = jsonDecode(response.body);
      if (resultMap["code"] != null) {
        throw APIException(resultMap['msg'], code: resultMap["code"]);
      }
      var result = MailModel.fromJson(resultMap);
      if (result == null) {
        throw DataException();
      }
      return result;
    }).catchError((e) {
      throw e;
    });
  }

  static Future<StatusModel> sendMail(String username, String title, String content) async {
    return Request.httpPost(
      NForumSpecs.baseURL + 'mail/send.json',
      {'oauth_token': currentToken, 'id': username, 'title': title, 'content': content, 'signature': 0, 'backup': 1},
    ).then(
      (response) {
        Map resultMap = jsonDecode(response.body);
        if (resultMap["code"] != null) {
          return StatusModel(false);
        } else {
          return StatusModel.fromJson(resultMap);
        }
      },
    );
  }

  static Future<Tuple3<int, int, int>> getNewMessageCount() async {
    int reply = await Request.httpGet(NForumSpecs.baseURL + 'refer/reply/info.json', {
      'oauth_token': currentToken,
    }).then((response) {
      Map resultMap = jsonDecode(response.body);
      return resultMap["new_count"] ?? 0;
    });

    int at = await Request.httpGet(NForumSpecs.baseURL + 'refer/at/info.json', {
      'oauth_token': currentToken,
    }).then((response) {
      Map resultMap = jsonDecode(response.body);
      return resultMap["new_count"] ?? 0;
    });

    int mail = await Request.httpGet(
      NForumSpecs.baseURL + 'mail/inbox.json',
      {
        'oauth_token': currentToken,
        'page': 1,
        'count': 1,
      },
    ).then(
      (response) {
        Map resultMap = jsonDecode(response.body);
        return resultMap["new_num"] ?? 0;
      },
    );
    return Tuple3(reply, at, mail);
  }

  static Future<BoardSearchModel> getBoardSearch(String s) async {
    return Request.httpGet(
      NForumSpecs.baseURL + 'search/board.json',
      {
        'oauth_token': currentToken,
        'board': s,
      },
    ).then((response) {
      Map resultMap = jsonDecode(response.body);
      if (resultMap["code"] != null) {
        throw APIException(resultMap['msg'], code: resultMap["code"]);
      }
      var result = BoardSearchModel.fromJson(resultMap);
      if (result == null) {
        throw DataException();
      }
      return result;
    }).catchError((e) {
      throw e;
    });
  }

  static Future<ThreadSearchModel> getThreadSearch({
    String board,
    int day,
    String author,
    String keyword,
    bool attach,
    int page = 1,
  }) async {
    var params = {
      'oauth_token': currentToken,
      'board': board,
      'day': day,
      'page': page,
    };
    if (author != null && author != '') {
      params['author'] = author;
    }
    if (keyword != null && keyword != '') {
      params['title1'] = keyword;
    }
    if (attach != null) {
      params['a'] = attach ? 1 : 0;
    }
    return Request.httpGet(NForumSpecs.baseURL + 'search/threads.json', params).then((response) {
      Map resultMap = jsonDecode(response.body);
      if (resultMap["code"] != null) {
        throw APIException(resultMap['msg'], code: resultMap["code"]);
      }
      var result = ThreadSearchModel.fromJson(resultMap);
      if (result == null) {
        throw DataException();
      }
      return result;
    }).catchError((e) {
      throw e;
    });
  }

  static Future<UserModel> getUserInfo(String id) async {
    return Request.httpGet(
      NForumSpecs.baseURL + 'user/query/$id.json',
      {
        'oauth_token': currentToken,
      },
    ).then((response) {
      Map resultMap = jsonDecode(response.body);
      if (resultMap["code"] != null) {
        throw APIException(resultMap['msg'], code: resultMap["code"]);
      }
      var result = UserModel.fromJson(resultMap);
      if (result == null) {
        throw DataException();
      }
      return result;
    }).catchError((e) {
      throw e;
    });
  }

  static Future<AttachmentModel> uploadAttachment(String boardName, File attachment) async {
    try {
      return Request.httpUpload(
              NForumSpecs.baseURL + 'attachment/' + boardName + '/add.json',
              {
                'oauth_token': currentToken,
              },
              attachment)
          .then((response) {
        Map resultMap = jsonDecode(response.body);
        if (resultMap['code'] != null) {
          return AttachmentModel([], resultMap['msg'], -1);
        }
        return AttachmentModel.fromJson(resultMap);
      });
    } catch (_) {
      return AttachmentModel([], '-1', -1);
    }
  }

  static Future<AttachmentModel> uploadAttachmentToArticle(String boardName, File attachment, int id) async {
    try {
      return Request.httpUpload(
              NForumSpecs.baseURL + 'attachment/$boardName/add/$id.json',
              {
                'oauth_token': currentToken,
              },
              attachment)
          .then((response) {
        Map resultMap = jsonDecode(response.body);
        if (resultMap['code'] != null) {
          return AttachmentModel([], resultMap['msg'], -1);
        }
        return AttachmentModel.fromJson(resultMap);
      });
    } catch (_) {
      return AttachmentModel([], '-1', -1);
    }
  }

  static Future<bool> deleteAttachmentOfArticle(String boardName, int id, String name) async {
    return Request.httpPost(NForumSpecs.baseURL + 'attachment/$boardName/delete/$id.json', {
      'oauth_token': currentToken,
      'name': name,
    }).then((response) {
      Map resultMap = jsonDecode(response.body);
      if (resultMap["code"] != null) {
        return false;
      }
      return true;
    });
  }
}
