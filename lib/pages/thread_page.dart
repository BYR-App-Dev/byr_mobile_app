import 'package:byr_mobile_app/nforum/board_att_info.dart';
import 'package:byr_mobile_app/nforum/nforum_service.dart';
import 'package:byr_mobile_app/pages/pages.dart';
import 'package:byr_mobile_app/pages/thread_base_page.dart';
import 'package:flutter/material.dart';

class ThreadPageData extends ThreadBaseData {}

class ThreadPageRouteArg extends ThreadBasePageRouteArg {
  final String boardName;
  final int groupId;
  final int startingPage;
  final int startingPosition;
  final bool keepAlive;

  ThreadPageRouteArg(this.boardName, this.groupId,
      {this.startingPage = 1, this.startingPosition = -1, this.keepAlive = false})
      : super(
          boardName,
          groupId,
          startingPage: startingPage,
          startingPosition: startingPosition,
          keepAlive: keepAlive,
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
  Future<void> initialDataLoader({Function afterLoad}) {
    setScreenshotTitle(NForumService.makeThreadURL(widget.arg.boardName, widget.arg.groupId));
    data = ThreadPageData();
    data.boardName = widget.arg.boardName;
    data.groupId = widget.arg.groupId;
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

    return NForumService.getThread(data.boardName, data.groupId, page: startingPg).then((thread) {
      if (data.authorToShow != null && data.authorToShow != "") {
        thread.likeArticles = [];
      }
      data.thread = thread;
      firstPageJump = data.thread.likeArticles?.length ?? 0;
      currentPage = thread.pagination?.pageCurrentCount ?? 1;
      maxPage = thread.pagination?.pageAllCount ?? maxPage;
      data.isCollected = data.thread?.collect;
      if (afterLoad != null) {
        afterLoad();
      }
      if (mounted) {
        setState(() {});
      }
    });
  }
}
