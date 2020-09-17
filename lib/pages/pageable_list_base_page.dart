import 'dart:math';

import 'package:byr_mobile_app/nforum/nforum_structures.dart';
import 'package:byr_mobile_app/pages/page_components.dart';
import 'package:byr_mobile_app/pages/pages.dart';
import 'package:byr_mobile_app/reusable_components/page_initialization.dart';
import 'package:byr_mobile_app/reusable_components/refreshers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

typedef Future<T> PageableListDataRequestHandler<T>(int page);

class PageableListBaseData<X extends PageableListBaseModel> extends PagedBaseData {
  X articleList;
  PageableListDataRequestHandler<X> dataRequestHandler;
}

abstract class PageableListBasePage extends StatefulWidget {}

/// need to override initialization, buildCell, buildSeparator, build
abstract class PageableListBasePageState<Y extends PageableListBaseModel, Z extends PageableListBasePage>
    extends State<Z>
    with AutomaticKeepAliveClientMixin, ScrollableListMixin<Z, PageableListBaseData<Y>>, InitializableMixin {
  bool get wantKeepAlive => true;
  bool isBottomLoading = true;
  final int startingPosition = 0;
  final int firstPageJump = 0;
  int factor = RefresherFactory.getFactor();
  RefreshController refreshController = RefreshController(initialRefresh: false);
  AutoScrollController scrollController = AutoScrollController();

  @override
  void initState() {
    initialization();
    super.initState();
  }

  @override
  void dispose() {
    refreshController.dispose();
    super.dispose();
  }

  void initialization() {
    initializationStatus = InitializationStatus.Initializing;
    failureInfo = '';

    initialDataLoader(afterLoad: () {
      initializationStatus = InitializationStatus.Initialized;
      if (startingPosition != -1) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          if (startingPosition >= PageConfig.pageItemCount) {
            int target = startingPosition % PageConfig.pageItemCount;
            scrollController
              ..scrollToIndex(target, duration: Duration(milliseconds: 600), preferPosition: AutoScrollPosition.middle)
              ..highlight(target);
          } else {
            int target = startingPosition + firstPageJump;
            scrollController
              ..scrollToIndex(target, duration: Duration(milliseconds: 600), preferPosition: AutoScrollPosition.middle)
              ..highlight(target);
          }
        });
      }
    }).catchError(initializationErrorHandling);
  }

  Future<void> onTopRefresh() async {
    if (data.currentMinPage <= 1) {
      return firstTopDataLoader(afterLoad: () {}).catchError(refreshErrorHandling);
    } else {
      var startingMaxExtent = scrollController.position.maxScrollExtent;
      var currentMinPage = max(1, data.currentMinPage - 1);
      return topDataLoader(afterLoad: () {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          int target = data.articleList.pagination.itemPageCount + (currentMinPage <= 1 ? (data.articleOffset) : 0) - 1;
          scrollController
            ..jumpTo(scrollController.position.maxScrollExtent - startingMaxExtent)
            ..scrollToIndex(target, duration: Duration(milliseconds: 600), preferPosition: AutoScrollPosition.end)
            ..highlight(target);
        });
      }).catchError(refreshErrorHandling);
    }
  }

  Future<void> onBottomRefresh() async {
    if (isBottomLoading) {
      return;
    }
    if (data.currentMaxPage < data.articleList.pagination.pageAllCount) {
      lastBottomDataLoader(afterLoad: () {}).catchError(loadErrorHandling);
    } else {
      bottomDataLoader(afterLoad: () {}).catchError(loadErrorHandling);
    }
  }

  @override
  int cellCount() {
    return data.articleList.article.length;
  }

  void initializationErrorHandling(e) {
    isBottomLoading = false;
    setFailureInfo(e);
    initializationStatus = InitializationStatus.Failed;
  }

  void refreshErrorHandling(e) {
    setFailureInfo(e);
    refreshController.refreshFailed();
  }

  void loadErrorHandling(e) {
    isBottomLoading = false;
    setFailureInfo(e);
    refreshController.loadFailed();
  }

  @override
  void scrollSolver(int index1, int index2, double extentBefore, double extentAfter) {
    if (!isBottomLoading && extentAfter < 1000) {
      autoAddBottom();
    }
  }

  Future<void> autoAddBottom() async {
    isBottomLoading = true;
    return lastBottomDataLoader(afterLoad: () {
      isBottomLoading = false;
    }).catchError(loadErrorHandling);
  }

  Future<void> bottomDataLoader({Function afterLoad}) {
    var oldCount = data.articleList.article.length % PageConfig.pageItemCount;
    oldCount = oldCount == 0 ? PageConfig.pageItemCount : oldCount;
    var oldLength = data.articleList.article.length;
    var lastPageStartIndex = oldLength - oldCount;
    return data.dataRequestHandler(data.currentMaxPage).then((timelime) {
      if (data.articleList.pagination.pageCurrentCount == data.currentMaxPage) {
        data.articleList.article.removeRange(lastPageStartIndex, oldLength);
        data.articleList.article.addAll(timelime.article);
        data.articleList.pagination = timelime.pagination;
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

  Future<void> lastBottomDataLoader({Function afterLoad}) {
    return data.dataRequestHandler(data.currentMaxPage + 1).then((timeline) {
      if (timeline.pagination.pageCurrentCount == data.currentMaxPage + 1) {
        data.currentMaxPage += 1;
        data.articleList.article.addAll(timeline.article);
        data.articleList.pagination = timeline.pagination;
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

  Future<void> firstTopDataLoader({Function afterLoad}) {
    return data.dataRequestHandler(1).then((timeline) {
      refreshController.refreshCompleted();
      data.currentMinPage = 1;
      data.currentMaxPage = 1;
      data.articleList = timeline;
      if (afterLoad != null) {
        afterLoad();
      }
      if (mounted) {
        setState(() {});
      }
    });
  }

  Future<void> initialDataLoader({Function afterLoad}) {
    setScreenshotTitle("");
    data.currentMinPage = 1;
    data.currentMaxPage = 1;

    isBottomLoading = false;

    return data.dataRequestHandler(1).then((timeline) {
      data.articleList = timeline;
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
    return data.dataRequestHandler(currentMinPage).then((timeline) {
      refreshController.refreshCompleted();
      data.currentMinPage = currentMinPage;
      data.articleList.article.insertAll(0, timeline.article);
      data.articleList.pagination = timeline.pagination;
      if (afterLoad != null) {
        afterLoad();
      }
      if (mounted) {
        setState(() {});
      }
    });
  }
}
