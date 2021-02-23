import 'package:byr_mobile_app/local_objects/local_models.dart';
import 'package:byr_mobile_app/nforum/board_att_info.dart';
import 'package:byr_mobile_app/nforum/nforum_service.dart';
import 'package:byr_mobile_app/pages/pages.dart';
import 'package:byr_mobile_app/pages/thread_base_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ThreadPageData extends ThreadBaseData {}

class ThreadPageRouteArg extends ThreadBasePageRouteArg {
  final String boardName;
  final int groupId;
  final int startingPage;
  final int startingPosition;
  final bool keepAlive;
  final bool fromBoard;

  ThreadPageRouteArg(
    this.boardName,
    this.groupId, {
    this.startingPage = 1,
    this.startingPosition = -1,
    this.keepAlive = false,
    this.fromBoard = false,
  }) : super(
          boardName,
          groupId,
          startingPage: startingPage,
          startingPosition: startingPosition,
          keepAlive: keepAlive,
          fromBoard: fromBoard,
        );
}

class ThreadPage extends ThreadBasePage {
  final ThreadPageRouteArg arg;

  ThreadPage(this.arg) : super(arg);

  @override
  State<StatefulWidget> createState() {
    return ThreadPageState();
  }
}

class ThreadPageState extends ThreadPageBaseState<ThreadPage, ThreadPageData> {
  @override
  Future<void> initialDataLoader({Function afterLoad}) async {
    setScreenshotTitle(NForumService.makeThreadURL(widget.arg.boardName, widget.arg.groupId));
    data = ThreadPageData();
    data.boardName = widget.arg.boardName;
    data.groupId = widget.arg.groupId;
    data.fromBoard = widget.arg.fromBoard;
    var startingPg = widget.arg.startingPage;
    if (startingPg == 1 && widget.arg.startingPosition != -1) {
      startingPg = 1 + widget.arg.startingPosition ~/ PageConfig.pageItemCount;
    }
    data.currentMinPage = startingPg;
    data.currentMaxPage = startingPg;
    data.isAnonymous = NForumSpecs.isAnonymous;

    currentPage = startingPg;
    maxPage = startingPg;
    isLoading = false;

    reid = data.groupId;
    repos = 0;
    threadId = data.groupId;
    boardName = data.boardName;
    boardDescription = BoardAttInfo.desc(boardName);
    replyTail = "";

    /// 2020-09-30 malikwang
    /// 等待页面push完毕再请求数据，防止页面在push过程中数据已经加载完毕造成视觉卡顿错觉
    /// 400毫秒 是route的transitionDuration的时间
    return Future.wait([
      Future.delayed(Duration(milliseconds: 400)),
      NForumService.getThread(data.boardName, data.groupId, page: startingPg).then((thread) {
        if (data.authorToShow != null && data.authorToShow != "") {
          thread.likeArticles = [];
        }
        data.thread = thread;
        HistoryModel.addHistoryItem(HistoryArticleModel(
            boardName: thread.boardName,
            title: thread.title,
            groupId: thread.groupId,
            createdTime: DateTime.now().millisecondsSinceEpoch ~/ 1000));
        firstPageJump = data.thread.likeArticles?.length ?? 0;
        currentPage = thread.pagination?.pageCurrentCount ?? 1;
        maxPage = thread.pagination?.pageAllCount ?? maxPage;
        data.isCollected = data.thread?.collect;
      })
    ]).then((v) {
      if (afterLoad != null) {
        afterLoad();
      }
    });
  }

  @override
  void setFailureInfo(e) {
    if (e is APIException && e.code == "0202") {
      navigator.push(CupertinoPageRoute(
          builder: (_) => WebPage(WebPageRouteArg(
              "https://bbs.byr.cn/n/article/" + widget.arg.boardName + "/" + widget.arg.groupId.toString()))));
    }
  }
}
