import 'dart:math';

import 'package:byr_mobile_app/customizations/app_bar_customization.dart';
import 'package:byr_mobile_app/customizations/board_info.dart';
import 'package:byr_mobile_app/customizations/theme_controller.dart';
import 'package:byr_mobile_app/helper/helper.dart';
import 'package:byr_mobile_app/networking/http_request.dart';
import 'package:byr_mobile_app/nforum/nforum_service.dart';
import 'package:byr_mobile_app/nforum/nforum_structures.dart';
import 'package:byr_mobile_app/nforum/nforum_text_parser.dart';
import 'package:byr_mobile_app/pages/page_components.dart';
import 'package:byr_mobile_app/pages/pages.dart';
import 'package:byr_mobile_app/reusable_components/adaptive_components.dart';
import 'package:byr_mobile_app/reusable_components/article_cell.dart';
import 'package:byr_mobile_app/reusable_components/byr_app_bar.dart';
import 'package:byr_mobile_app/reusable_components/emoticon_panel.dart';
import 'package:byr_mobile_app/reusable_components/page_initialization.dart';
import 'package:byr_mobile_app/reusable_components/refreshers.dart';
import 'package:byr_mobile_app/reusable_components/thread_cell.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:share/share.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tinycolor/tinycolor.dart';

import 'board_page.dart';

class ThreadBaseData extends PagedBaseData {
  ThreadModel thread;
  String boardName;
  int groupId;
  String authorToShow;
  bool isAnonymous;
  bool isCollected;
}

class ThreadBasePageRouteArg {
  final String boardName;
  final int groupId;
  final int startingPage;
  final int startingPosition;
  final bool keepAlive;

  ThreadBasePageRouteArg(this.boardName, this.groupId,
      {this.startingPage = 1, this.startingPosition = -1, this.keepAlive = true});
}

abstract class ThreadBasePage extends StatefulWidget {
  final ThreadBasePageRouteArg arg;

  ThreadBasePage(this.arg);

  @override
  State<StatefulWidget> createState() {
    return ThreadPageBaseState();
  }
}

class ThreadPageBaseState<BaseThreadPage extends ThreadBasePage, BaseThreadData extends ThreadBaseData>
    extends State<BaseThreadPage>
    with
        ScrollableListMixin<BaseThreadPage, BaseThreadData>,
        PagerMixin,
        AutomaticKeepAliveClientMixin,
        ReplyFormMixin,
        InitializationFailureViewMixin {
  GlobalKey<ScaffoldState> scaffoldKey;
  int refreshFactor;
  RefreshController refreshController;

  InitializationStatus initializationStatus;
  bool isLoading;

  String failureInfo;

  int firstPageJump;

  @override
  bool get wantKeepAlive => widget.arg.keepAlive;

  @override
  void dispose() {
    refreshController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    scaffoldKey = GlobalKey<ScaffoldState>();

    firstPageJump = 0;

    initialization();

    refreshFactor = RefresherFactory.getFactor();
    refreshController = RefreshController(initialRefresh: false);
  }

  @override
  void initialization() {
    initializationStatus = InitializationStatus.Initializing;
    failureInfo = '';

    initialDataLoader(afterLoad: () {
      initializationStatus = InitializationStatus.Initialized;
      if (mounted) {
        setState(() {});
      }
      if (widget.arg.startingPosition != -1) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          if (widget.arg.startingPosition >= PageConfig.pageItemCount) {
            int target = widget.arg.startingPosition % PageConfig.pageItemCount;
            scrollController
              ..scrollToIndex(target, duration: Duration(milliseconds: 600), preferPosition: AutoScrollPosition.middle)
              ..highlight(target);
          } else {
            int target = widget.arg.startingPosition + firstPageJump;
            scrollController
              ..scrollToIndex(target, duration: Duration(milliseconds: 600), preferPosition: AutoScrollPosition.middle)
              ..highlight(target);
          }
        });
      }
    }).catchError(initializationErrorHandling);
  }

  Future<void> initialDataLoader({Function afterLoad}) {
    return null;
  }

  Future<void> shareArticle() async {
    if (data.thread?.id != null) {
      await Share.share(data.thread.title +
          ": " +
          NForumService.makeThreadURL(data.thread.boardName, data.thread.groupId) +
          ' 北邮人论坛');
    }
  }

  getThreadMoreMenu(BuildContext context) {
    return <PopupMenuEntry<String>>[
      PopupMenuItem<String>(
        value: 'goboard',
        child: Text(
          "backToBoardTrans".tr,
          style: TextStyle(
            color: E().threadPageTopBarMenuColor,
          ),
        ),
      ),
      PopupMenuItem<String>(
        value: 'report',
        child: Text(
          "reportTrans".tr,
          style: TextStyle(
            color: E().threadPageTopBarMenuColor,
          ),
        ),
      ),
      data.boardName == 'IWhisper'
          ? PopupMenuItem<String>(
              value: 'anonymous',
              child: Text(
                data.isAnonymous ? "unAnonymous".tr : "anonymous".tr,
                style: TextStyle(
                  color: E().threadPageTopBarMenuColor,
                ),
              ),
            )
          : null,
      screenshotStatus == ScreenshotStatus.Dismissed
          ? PopupMenuItem<String>(
              value: 'screenshot',
              child: Text(
                "screenshotPage".tr,
                style: TextStyle(
                  color: E().threadPageTopBarMenuColor,
                ),
              ),
            )
          : null,
      PopupMenuItem<String>(
        value: 'share',
        child: Text(
          "share".tr,
          style: TextStyle(
            color: E().threadPageTopBarMenuColor,
          ),
        ),
      ),
    ];
  }

  @override
  void afterEdit() {
    goToPage(currentPage);
  }

  @override
  void afterReply() {
    data.authorToShow = null;
    gotoLastPage(() {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        scrollController
          ..animateTo(
            scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 600),
            curve: Curves.fastOutSlowIn,
          );
      });
    });
  }

  void gotoLastPage(Function afterLoad) {
    NForumService.getThread(data.boardName, data.groupId, page: maxPage, author: data.authorToShow).then((thread) {
      if (thread != null && thread.id != null && thread.article != null && thread.pagination != null) {
        data.thread.pagination = thread.pagination;
        maxPage = data.thread.pagination.pageAllCount;
      }
      goToPage(maxPage, afterLoad: afterLoad);
    });
  }

  _likeArticle(String name, int id) {
    NForumService.likeArticle(name, id).then((status) {});
  }

  _votedownArticle(String name, int id) {
    NForumService.votedownArticle(name, id).then((status) {});
  }

  Future<void> _author(String authorToShow) {
    if (data.authorToShow == null || data.authorToShow == "") {
      data.authorToShow = authorToShow;
    } else {
      data.authorToShow = null;
    }
    AdaptiveComponents.showLoading(context);
    return NForumService.getThread(data.boardName, data.groupId, author: data.authorToShow).then((thread) {
      if (data.authorToShow != null && data.authorToShow != "") {
        thread.likeArticles = [];
      }
      data.thread = thread;
      data.currentMinPage = 1;
      data.currentMaxPage = 1;
      currentPage = 1;
      maxPage = thread.pagination.pageAllCount;
      pagerRedraw();
      if (mounted) {
        setState(() {});
      }
      AdaptiveComponents.hideLoading();
    });
  }

  Future<void> firstTopDataLoader({Function afterLoad}) {
    return NForumService.getThread(
      data.boardName,
      data.groupId,
      author: data.authorToShow,
    ).then((thread) {
      if (data.authorToShow != null && data.authorToShow != "") {
        thread.likeArticles = [];
      }
      refreshController.refreshCompleted();
      data.currentMinPage = 1;
      data.currentMaxPage = 1;
      data.thread = thread;
      pagerRedraw();
      if (afterLoad != null) {
        afterLoad();
      }
      if (mounted) {
        setState(() {});
      }
    });
  }

  Future<void> topDataLoader({Function afterLoad}) {
    var currentMinPage = max(1, data.currentMinPage - 1);
    return NForumService.getThread(
      data.boardName,
      data.groupId,
      page: currentMinPage,
      author: data.authorToShow,
    ).then((thread) {
      if (data.authorToShow != null && data.authorToShow != "") {
        thread.likeArticles = [];
      }
      refreshController.refreshCompleted();
      data.currentMinPage = currentMinPage;
      data.thread.article.insertAll(0, thread.article);
      data.thread.pagination = thread.pagination;
      pagerRedraw();
      if (afterLoad != null) {
        afterLoad();
      }
      if (mounted) {
        setState(() {});
      }
    });
  }

  Future<void> onTopRefresh() async {
    if (data.currentMinPage <= 1) {
      return firstTopDataLoader(afterLoad: () {
        if (mounted) {
          setState(() {});
        }
      }).catchError(refreshErrorHandling);
    } else {
      var startingMaxExtent = scrollController.position.maxScrollExtent;
      var currentMinPage = max(1, data.currentMinPage - 1);
      return topDataLoader(afterLoad: () {
        if (mounted) {
          setState(() {});
        }
        SchedulerBinding.instance.addPostFrameCallback((_) {
          int target = data.thread.pagination.itemPageCount +
              (currentMinPage <= 1 ? (data.thread.likeArticles?.length ?? 0) : 0) -
              1;
          scrollController
            ..jumpTo(scrollController.position.maxScrollExtent - startingMaxExtent)
            ..scrollToIndex(target, duration: Duration(milliseconds: 600), preferPosition: AutoScrollPosition.end)
            ..highlight(target);
        });
      }).catchError(refreshErrorHandling);
    }
  }

  Future<void> lastBottomDataLoader({Function afterLoad}) {
    return NForumService.getThread(data.boardName, data.groupId,
            page: data.currentMaxPage + 1, author: data.authorToShow)
        .then((thread) {
      if (data.authorToShow != null && data.authorToShow != "") {
        thread.likeArticles = [];
      }
      if (thread.pagination.pageCurrentCount == data.currentMaxPage + 1) {
        data.currentMaxPage += 1;
        data.thread.article.addAll(thread.article);
        data.thread.pagination = thread.pagination;
      }
      refreshController.loadComplete();
      if (afterLoad != null) {
        afterLoad();
      }
      if (mounted) {
        setState(() {});
      }
    });
  }

  Future<void> bottomDataLoader({Function afterLoad}) {
    var oldCount = data.thread.article.length % PageConfig.pageItemCount;
    oldCount = oldCount == 0 ? PageConfig.pageItemCount : oldCount;
    var oldLength = data.thread.article.length;
    var lastPageStartIndex = oldLength - oldCount;
    return NForumService.getThread(
      data.boardName,
      data.groupId,
      page: data.currentMaxPage,
      author: data.authorToShow,
    ).then((thread) {
      if (data.authorToShow != null && data.authorToShow != "") {
        thread.likeArticles = [];
      }
      if (thread.pagination.pageCurrentCount == data.currentMaxPage) {
        data.thread.article.removeRange(lastPageStartIndex, oldLength);
        data.thread.article.addAll(thread.article);
        data.thread.pagination = thread.pagination;
      }
      refreshController.loadComplete();
      if (afterLoad != null) {
        afterLoad();
      }
      if (mounted) {
        setState(() {});
      }
    });
  }

  Future<void> onBottomRefresh() async {
    if (isLoading) {
      return;
    }
    if (data.currentMaxPage < data.thread.pagination.pageAllCount) {
      lastBottomDataLoader(afterLoad: () {
        if (mounted) {
          setState(() {});
        }
      }).catchError(loadErrorHandling);
    } else {
      bottomDataLoader(afterLoad: () {
        if (mounted) {
          setState(() {});
        }
      }).catchError(loadErrorHandling);
    }
  }

  @override
  Future<void> goToPage(int page, {Function afterLoad}) {
    AdaptiveComponents.showLoading(context);
    page = min(maxPage, max(1, page));
    return NForumService.getThread(data.boardName, data.groupId, page: page, author: data.authorToShow).then((thread) {
      if (data.authorToShow != null && data.authorToShow != "") {
        thread.likeArticles = [];
      }
      if (thread.pagination.pageCurrentCount == page) {
        data.currentMaxPage = page;
        data.currentMinPage = page;
        data.thread = thread;
        currentPage = page;
        maxPage = thread.pagination.pageAllCount;
        pagerRedraw();
      }
      if (afterLoad != null) {
        afterLoad();
      }
      if (mounted) {
        setState(() {});
      }
      AdaptiveComponents.hideLoading();
    });
  }

  @override
  void scrollSolver(int index1, int index2, double extentBefore, double extentAfter) {
    if (index1 != null && index2 != null) {
      int _page = min(
          ((index1 - (data.thread.likeArticles?.length ?? 0)) ~/ PageConfig.pageItemCount) + data.currentMinPage,
          maxPage);
      int _page2 = min(
          ((index2 - (data.thread.likeArticles?.length ?? 0)) ~/ PageConfig.pageItemCount) + data.currentMinPage,
          maxPage);
      if (!(currentPage >= _page && currentPage <= _page2)) {
        currentPage = _page;
        pagerRedraw();
      }
    }

    if (!isLoading && extentAfter < 1000) {
      autoAddBottom();
    }
  }

  Future<void> autoAddBottom() {
    if (data.currentMaxPage < data.thread.pagination.pageAllCount) {
      isLoading = true;
      return NForumService.getThread(data.boardName, data.groupId,
              page: data.currentMaxPage + 1, author: data.authorToShow)
          .then((thread) {
        if (data.authorToShow != null && data.authorToShow != "") {
          thread.likeArticles = [];
        }
        if (thread.pagination.pageCurrentCount == data.currentMaxPage + 1) {
          data.currentMaxPage += 1;
          refreshController.loadComplete();
          data.thread.article.addAll(thread.article);
          data.thread.pagination = thread.pagination;
          isLoading = false;
        }
        if (mounted) {
          setState(() {});
        }
      }).catchError(loadErrorHandling);
    } else {
      isLoading = false;
      return null;
    }
  }

  deleteArticle(int id) async {
    scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text("deleting".tr),
        duration: Duration(seconds: 1),
      ),
    );
    var result = await NForumService.deleteArticle(
      data.boardName,
      id,
    );
    if (result) {
      scaffoldKey.currentState.removeCurrentSnackBar();
      scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text("deleteSuccess".tr),
          duration: Duration(seconds: 1),
        ),
      );
      if (data.thread.article.length == 1) {
        navigator.pop();
        return;
      }
      int index = -1;
      int pos = 0;
      index = data.thread.article.indexWhere((articleModel) => articleModel.id == id);
      if (index != -1) {
        pos = data.thread.article[index].position;
        data.thread.article.removeAt(index);
        if (pos != 0) {
          for (var articleModel in data.thread.article) {
            if (articleModel.position > pos) {
              articleModel.position -= 1;
            }
          }
        }
      }
      if (data.thread.likeArticles != null) {
        index = data.thread.likeArticles.indexWhere((articleModel) => articleModel.id == id);
        if (index != -1) {
          data.thread.likeArticles.removeAt(index);
          if (pos != 0) {
            for (var articleModel in data.thread.likeArticles) {
              if (articleModel.position > pos) {
                articleModel.position -= 1;
              }
            }
          }
        }
      }
      if (mounted) {
        setState(() {});
      }
    } else {
      scaffoldKey.currentState.removeCurrentSnackBar();
      scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text("deleteFailed".tr),
          duration: Duration(milliseconds: 1500),
        ),
      );
    }
  }

  showBottomActionSheet({ArticleBaseModel articleModel, String content}) {
    content = NForumTextParser.computeEmojiStr(content);
    var actions = [
      if (widget.arg.boardName != 'IWhisper')
        (data.authorToShow == articleModel.user?.id ? ("cancelTrans".tr + " ") : "") + "onlyAuthor".tr,
    ];
    actions.add("copy".tr);
    if (articleModel != null &&
        articleModel.runtimeType == ThreadArticleModel &&
        (articleModel as ThreadArticleModel).isAdmin) {
      actions.add("edit".tr);
      actions.add("delete".tr);
    }
    AdaptiveComponents.showBottomSheet(context, actions, onItemTap: (int index) async {
      if (index == 0) {
        if (articleModel.user?.id != null && articleModel.user.id.isNotEmpty) {
          _author(articleModel.user?.id);
        }
      }
      if (index == 1) {
        Clipboard.setData(ClipboardData(text: content));
        scaffoldKey.currentState.removeCurrentSnackBar();
        scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text("copy".tr + "succeed".tr),
            duration: Duration(seconds: 1),
          ),
        );
      }
      if (index == 2) {
        var result = await navigator.pushNamed(
          'post_page',
          arguments: PostPageRouteArg(
            board: null,
            updateMode: true,
            articleModel: articleModel as ThreadArticleModel,
          ),
        );
        if (result == true) {
          afterEdit();
        }
      }
      if (index == 3) deleteArticle((articleModel as ThreadArticleModel).id);
      return;
    });
  }

  @override
  Widget buildCell(BuildContext context, int index) {
    int delSubjectLength = 1;
    if (data.thread?.id != null) {
      delSubjectLength = data.thread.article[0].isSubject == false && data.currentMinPage == 1 ? 1 : 0;
    }
    int i = index;
    int j = i - delSubjectLength;
    if (i == 0 && data.currentMinPage == 1) {
      if (j == -1) {
        if (data.authorToShow != null && data.authorToShow.isNotEmpty) {
          return Container();
        }
        return Container(
          alignment: Alignment.center,
          child: Image.asset(
            'resources/thread/delete_bg.png',
          ),
        );
      }
      var threadArticleObject = data.thread.article[j];
      return ThreadPageListSubjectCell<ThreadArticleModel>(
        data.thread.article[i],
        ThreadPageListCellArticleLayouter(),
        data.thread.title,
        data.boardName,
        () {
          showBottomActionSheet(
            articleModel: threadArticleObject,
            content: threadArticleObject.content,
          );
        },
        () {
          changeReplyPointer(threadArticleObject.id, threadArticleObject.position,
              NForumTextParser.makeReplyQuote(threadArticleObject.user.id, threadArticleObject.content));
          changePlaceHolder();
        },
        () {
          _likeArticle(threadArticleObject.boardName, threadArticleObject.id);
        },
        () {
          _votedownArticle(threadArticleObject.boardName, threadArticleObject.id);
        },
        _author,
        authorShown: data.authorToShow,
        threadAuthor: data.thread?.user?.id,
      );
    }

    if (data.currentMinPage <= 1 &&
        (data.thread.likeArticles?.length ?? 0) > 0 &&
        i <= (data.thread.likeArticles?.length ?? 0)) {
      var threadArticleObject = data.thread.likeArticles[i - 1];
      return ThreadPageListCell<LikeArticleModel>(
        threadArticleObject,
        ThreadPageListCellLikeArticleLayouter(),
        null,
        data.boardName,
        () {
          showBottomActionSheet(
            articleModel: threadArticleObject,
            content: threadArticleObject.content,
          );
        },
        () {
          changeReplyPointer(threadArticleObject.id, threadArticleObject.position,
              NForumTextParser.makeReplyQuote(threadArticleObject.user.id, threadArticleObject.content));
          changePlaceHolder();
        },
        () {
          _likeArticle(threadArticleObject.boardName, threadArticleObject.id);
        },
        () {
          _votedownArticle(threadArticleObject.boardName, threadArticleObject.id);
        },
        _author,
        threadAuthor: data.thread?.user?.id,
      );
    }

    var threadArticleObject = data.thread.article[j - (data.thread.likeArticles?.length ?? 0)];
    return ThreadPageListCell<ThreadArticleModel>(
      threadArticleObject,
      ThreadPageListCellArticleLayouter(),
      null,
      data.boardName,
      () {
        showBottomActionSheet(
          articleModel: threadArticleObject,
          content: threadArticleObject.content,
        );
      },
      () {
        changeReplyPointer(threadArticleObject.id, threadArticleObject.position,
            NForumTextParser.makeReplyQuote(threadArticleObject.user.id, threadArticleObject.content));
        changePlaceHolder();
      },
      () {
        _likeArticle(threadArticleObject.boardName, threadArticleObject.id);
      },
      () {
        _votedownArticle(threadArticleObject.boardName, threadArticleObject.id);
      },
      _author,
      threadAuthor: data.thread?.user?.id,
    );
  }

  @override
  Widget buildSeparator(BuildContext context, int index, {bool isLast = false}) {
    if (screenshotStatus == ScreenshotStatus.Capturing || screenshotStatus == ScreenshotStatus.Previewing) {
      return Divider(
        indent: 62,
        height: 0.4,
        color: E().threadPageDividerColor,
      );
    }
    index = index - 1;
    if (index == -1 || isLast) {
      return Container(
        height: 4.0,
        margin: EdgeInsetsDirectional.zero,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: E().threadPageBackgroundColor, width: 4),
          ),
        ),
      );
    }
    if (data.currentMinPage <= 1 && index == 0 && (data.thread.likeArticles?.length ?? 0) > 0) {
      return Row(
        children: <Widget>[
          if (data.authorToShow == null || data.authorToShow.isEmpty)
            Image.asset(
              'resources/thread/like_posts.png',
              width: 30,
              height: 30,
            ),
          if (data.authorToShow == null || data.authorToShow.isEmpty)
            Text("hotRepliesTrans".tr, style: TextStyle(color: E().threadPageOtherTextColor)),
          Expanded(
            child: Divider(
              indent: 20,
              height: 0.4,
              color: E().threadPageDividerColor,
            ),
          ),
        ],
      );
    }
    if (data.currentMinPage == 1 &&
        index == (data.thread.likeArticles?.length ?? 0) &&
        data.thread.article != null &&
        ((data.thread.article.length > 0 && data.thread.article[0].isSubject != true) ||
            (data.thread.article.length > 1 && data.thread.article[0].isSubject == true))) {
      return Row(
        children: <Widget>[
          if (data.authorToShow == null || data.authorToShow.isEmpty)
            Image.asset(
              'resources/thread/all_posts.png',
              width: 30,
              height: 30,
            ),
          if (data.authorToShow == null || data.authorToShow.isEmpty)
            Text(
              "allRepliesTrans".tr,
              style: TextStyle(color: E().threadPageOtherTextColor),
            ),
          Expanded(
            child: Divider(
              indent: 20,
              height: 0.4,
              color: E().threadPageDividerColor,
            ),
          ),
        ],
      );
    }
    return Divider(
      indent: 62,
      height: 0.4,
      color: E().threadPageDividerColor,
    );
  }

  @override
  int cellCount() {
    int delSubjectLength = 0;
    if (data.thread?.id != null) {
      delSubjectLength = data.thread.article[0].isSubject == false && data.currentMinPage == 1 ? 1 : 0;
    }
    return data.thread == null || data.thread.id == null
        ? 1
        : (data.thread.article.length +
            (data.currentMinPage <= 1 ? (data.thread.likeArticles?.length ?? 0) : 0) +
            (delSubjectLength));
  }

  Future<bool> onCollectButtonTapped(
    bool isCollected,
  ) async {
    var result;
    if (isCollected) {
      result = await NForumService.removeCollection(data.boardName, data.groupId);
    } else {
      result = await NForumService.addCollection(data.boardName, data.groupId);
    }
    if (result.id != null && result.id == data.groupId) {
      data.isCollected = !data.isCollected;
      return !isCollected;
    } else {
      AdaptiveComponents.showToast(context, '${isCollected ? '收藏' : '取消收藏'}失败');
      return isCollected;
    }
  }

  Widget buildLoadingView() {
    return Shimmer.fromColors(
      baseColor: !E().isThemeDarkStyle ? Colors.grey[300] : Colors.grey,
      highlightColor: !E().isThemeDarkStyle ? Colors.grey[100] : Colors.white,
      enabled: true,
      child: ListView.separated(
        itemCount: 10,
        padding: const EdgeInsets.all(0),
        separatorBuilder: (context, i) => Container(
          height: 0.0,
          margin: EdgeInsetsDirectional.only(start: 15),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: E().threadPageDividerColor, width: 0.5),
            ),
          ),
        ),
        itemBuilder: (context, i) {
          if (i == 0) {
            var line = () => Container(
                  margin: EdgeInsets.only(left: 5, top: 10),
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                );
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: PostInfoView(
                          user: null,
                          postTime: null,
                          emptyView: true,
                          contentColor: E().threadPageContentColor,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 5),
                        height: 15,
                        width: 70,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 5, top: 20),
                    height: 25,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  ),
                  line(),
                  line(),
                  line(),
                  line(),
                  line(),
                  line(),
                  line(),
                  line(),
                  line(),
                  line(),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Flexible(
                        child: Container(
                          margin: EdgeInsets.only(left: 5, top: 20, bottom: 10),
                          height: 25,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                        ),
                      ),
                      Flexible(
                        child: Container(
                          margin: EdgeInsets.only(left: 5, top: 20, bottom: 10),
                          height: 25,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                        ),
                      ),
                      Flexible(
                        child: Container(
                          margin: EdgeInsets.only(left: 5, top: 20, bottom: 10),
                          height: 25,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: PostInfoView(
                        user: null,
                        postTime: null,
                        emptyView: true,
                        contentColor: E().threadPageContentColor,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 5),
                      height: 15,
                      width: 70,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(left: 5, top: 10),
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                ),
                Container(
                  margin: EdgeInsets.only(left: 5, top: 10),
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                ),
                Container(
                  margin: EdgeInsets.only(left: 5, top: 10),
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void initializationErrorHandling(e) {
    setFailureInfo(e);
    initializationStatus = InitializationStatus.Failed;
    if (mounted) {
      setState(() {});
    }
  }

  void refreshErrorHandling(e) {
    setFailureInfo(e);
    refreshController.refreshFailed();
    if (mounted) {
      setState(() {});
    }
  }

  void loadErrorHandling(e) {
    isLoading = false;
    setFailureInfo(e);
    refreshController.loadFailed();
    if (mounted) {
      setState(() {});
    }
  }

  void setFailureInfo(e) {
    switch (e.runtimeType) {
      case NetworkException:
        failureInfo = "networkExceptionTrans".tr;
        break;
      case APIException:
        failureInfo = e.toString();
        break;
      case DataException:
        failureInfo = "dataExceptionTrans".tr;
        break;
      default:
        failureInfo = e.toString();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Obx(
      () => Scaffold(
        key: scaffoldKey,
        appBar: BYRAppBar(
          boardName: widget.arg.boardName,
          title: Text(
            "threadTrans".tr,
          ),
          actions: <Widget>[
            LikeButton(
              isLiked: data.isCollected ?? false,
              likeBuilder: (bool isLiked) {
                return Icon(
                  isLiked ? FontAwesomeIcons.solidStar : FontAwesomeIcons.star,
                  color: isLiked ? (AppBarCustomization.appBarIsColorfulTitle() ? null : Colors.orange) : null,
                  size: 22,
                );
              },
              circleColor: CircleColor(
                start: AppBarCustomization.appBarIsColorfulTitle()
                    ? BoardInfo.getBoardColor(widget.arg.boardName).withOpacity(0.5)
                    : Colors.orange.withOpacity(0.5),
                end: AppBarCustomization.appBarIsColorfulTitle()
                    ? BoardInfo.getBoardColor(widget.arg.boardName)
                    : Colors.orange,
              ),
              bubblesColor: BubblesColor(
                dotPrimaryColor: AppBarCustomization.appBarIsColorfulTitle()
                    ? BoardInfo.getBoardColor(widget.arg.boardName).withOpacity(0.5)
                    : Colors.orange.withOpacity(0.5),
                dotSecondaryColor: AppBarCustomization.appBarIsColorfulTitle()
                    ? BoardInfo.getBoardColor(widget.arg.boardName)
                    : Colors.orange,
              ),
              onTap: (bool isCollected) {
                HapticFeedback.heavyImpact();
                return onCollectButtonTapped(isCollected);
              },
            ),
            PopupMenuButton<String>(
              color: E().topBarBackgroundColor,
              itemBuilder: (context) => getThreadMoreMenu(context),
              onSelected: (choice) {
                switch (choice) {
                  case "goboard":
                    return Navigator.of(context).pushNamedAndRemoveUntil("board_page", ModalRoute.withName('home_page'),
                        arguments: BoardPageRouteArg(data.boardName));
                  case "report":
                    AdaptiveComponents.showAlertDialog(
                      context,
                      title: "reportConfirmTrans".tr,
                      onDismiss: (result) {
                        print(result);
                      },
                    );
                    return null;
                  case "anonymous":
                    NForumSpecs.setAnonymous(value: !data.isAnonymous);
                    data.isAnonymous = !data.isAnonymous;
                    if (mounted) {
                      setState(() {});
                    }
                    return null;
                  case "screenshot":
                    captureScreenshot();
                    return null;
                  case "share":
                    shareArticle();
                    return null;
                  default:
                    return null;
                }
              },
              icon: Icon(Icons.more_horiz, size: 30),
            ),
          ],
        ),
        body: Scaffold(
          body: Container(
            color: E().threadPageBackgroundColor,
            child: SafeArea(
              child: Material(
                color: E().threadPageBackgroundColor,
                child: Center(
                  child: widgetCase(
                    initializationStatus,
                    {
                      InitializationStatus.Initializing: buildLoadingView(),
                      InitializationStatus.Failed: buildLoadingFailedView(),
                      InitializationStatus.Initialized: Column(
                        children: <Widget>[
                          Expanded(
                            child: Stack(
                              children: <Widget>[
                                if (screenshotStatus == ScreenshotStatus.Dismissed)
                                  RefresherFactory(
                                    refreshFactor,
                                    refreshController,
                                    screenshotStatus == ScreenshotStatus.Dismissed ? true : false,
                                    screenshotStatus == ScreenshotStatus.Dismissed ? true : false,
                                    onTopRefresh,
                                    onBottomRefresh,
                                    buildList(),
                                  )
                                else
                                  buildList(),
                                if (screenshotStatus == ScreenshotStatus.Dismissed)
                                  buildPager()
                                else
                                  Positioned(
                                    right: 15,
                                    bottom: 15,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: E().threadPageButtonUnselectedColor.lighten(30),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(40.0),
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          if (screenshotStatus == ScreenshotStatus.Previewing)
                                            Text(
                                              (lengthPercentage * 100).ceil().toString() +
                                                  "%" +
                                                  ((lengthPercentage * 100).ceil() > 100
                                                      ? ("\n" + "screenshotOverLength".tr)
                                                      : ""),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: (lengthPercentage * 100).ceil() > 100
                                                      ? E().threadPageTextSelectedColor
                                                      : E().threadPageTextUnselectedColor),
                                            ),
                                          Row(
                                            children: [
                                              if (screenshotStatus == ScreenshotStatus.Selecting)
                                                IconButton(
                                                  icon: Icon(Icons.check_circle,
                                                      color: E().threadPageButtonUnselectedColor),
                                                  onPressed: () {
                                                    previewing();
                                                  },
                                                )
                                              else if (screenshotStatus == ScreenshotStatus.Previewing)
                                                IconButton(
                                                  icon: Icon(Icons.save, color: E().threadPageButtonUnselectedColor),
                                                  onPressed: () {
                                                    capturing();
                                                  },
                                                )
                                              else if (screenshotStatus == ScreenshotStatus.Capturing)
                                                IconButton(
                                                  icon: Icon(Icons.hourglass_empty,
                                                      color: E().threadPageButtonUnselectedColor),
                                                  onPressed: () {
                                                    capturing();
                                                  },
                                                ),
                                              if (screenshotStatus == ScreenshotStatus.Selecting)
                                                IconButton(
                                                  icon: Icon(Icons.cancel, color: E().threadPageButtonUnselectedColor),
                                                  onPressed: () {
                                                    cancelScreenshot();
                                                  },
                                                )
                                              else if (screenshotStatus == ScreenshotStatus.Previewing)
                                                IconButton(
                                                  icon: Icon(Icons.remove_circle,
                                                      color: E().threadPageButtonUnselectedColor),
                                                  onPressed: () {
                                                    backToSelecting();
                                                  },
                                                ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          if (screenshotStatus == ScreenshotStatus.Dismissed)
                            data.thread != null && data.thread.id != null
                                ? MultiProvider(
                                    providers: [
                                      ChangeNotifierProvider<EmoticonPanelProvider>(
                                        create: (_) => EmoticonPanelProvider(),
                                      ),
                                    ],
                                    child: buildReplyForm(),
                                  )
                                : Container(),
                        ],
                      ),
                    },
                    buildLoadingView(),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
