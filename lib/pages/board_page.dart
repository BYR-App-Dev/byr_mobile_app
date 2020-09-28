import 'dart:math';

import 'package:byr_mobile_app/customizations/board_info.dart';
import 'package:byr_mobile_app/customizations/const_colors.dart';
import 'package:byr_mobile_app/customizations/shimmer_theme.dart';
import 'package:byr_mobile_app/customizations/theme_controller.dart';
import 'package:byr_mobile_app/helper/helper.dart';
import 'package:byr_mobile_app/nforum/nforum_service.dart';
import 'package:byr_mobile_app/nforum/nforum_structures.dart';
import 'package:byr_mobile_app/nforum/nforum_text_parser.dart';
import 'package:byr_mobile_app/pages/article_list_base_page.dart';
import 'package:byr_mobile_app/pages/pages.dart';
import 'package:byr_mobile_app/reusable_components/byr_app_bar.dart';
import 'package:byr_mobile_app/reusable_components/capped_ratio_fade_in_image.dart';
import 'package:byr_mobile_app/reusable_components/clickable_avatar.dart';
import 'package:byr_mobile_app/reusable_components/custom_expansion_tile.dart';
import 'package:byr_mobile_app/reusable_components/no_padding_list_tile.dart';
import 'package:byr_mobile_app/reusable_components/page_initialization.dart';
import 'package:byr_mobile_app/reusable_components/refreshers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:tinycolor/tinycolor.dart';

class BoardPageRouteArg {
  final String boardName;
  final bool keepTop;
  final bool keepAlive;
  final bool isPicWaterfall;

  BoardPageRouteArg(this.boardName, {this.keepTop = true, this.keepAlive = true, this.isPicWaterfall = false});
}

class BoardPage extends ArticleListBasePage {
  final BoardPageRouteArg arg;
  BoardPage(this.arg);
  @override
  State<StatefulWidget> createState() {
    return BoardPageState();
  }
}

class BoardPageState extends ArticleListBasePageState<BoardModel, BoardPage> {
  List<FrontArticleModel> topArticles;

  @override
  bool get wantKeepAlive => widget.arg.keepAlive;

  @override
  void initialization() {
    topArticles = List<FrontArticleModel>();
    data = ArticleListBaseData()
      ..dataRequestHandler = (int page) {
        return NForumService.getBoard(widget.arg.boardName, page: page).then((value) {
          for (final v in value.article) {
            if (v.isTop) {
              topArticles.add(v);
            }
          }
          return value;
        });
      };
    super.initialization();
  }

  @override
  Future<void> firstTopDataLoader({Function afterLoad}) {
    topArticles.clear();
    return super.firstTopDataLoader(afterLoad: afterLoad);
  }

  @override
  void didUpdateWidget(BoardPage oldWidget) {
    if (oldWidget.arg.boardName != widget.arg.boardName) {
      initialization();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget buildCell(BuildContext context, int index) {
    FrontArticleModel boardArticleObject = data.articleList.article[index];
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, "thread_page",
            arguments: ThreadPageRouteArg(boardArticleObject.boardName, boardArticleObject.groupId));
      },
      child: Container(
        color: E().threadListBackgroundColor,
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              boardArticleObject.title,
              style: TextStyle(
                fontSize: 17.0,
                color: E().threadListTileTitleColor,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            Container(
              margin: EdgeInsets.only(top: 5),
              child: Row(
                children: <Widget>[
                  ClickableAvatar(
                    radius: 10,
                    imageLink: NForumService.makeGetURL(boardArticleObject.user?.faceUrl ?? ""),
                    isWhisper: (boardArticleObject.user?.id ?? "").startsWith("IWhisper"),
                    emptyUser: boardArticleObject.user == null || boardArticleObject.user.faceUrl == null,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    child: Text(
                      boardArticleObject.user?.id ?? "",
                      style: TextStyle(
                        fontSize: 15.0,
                        color: ConstColors.getUsernameColor(boardArticleObject.user?.gender),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "updatedOn".tr + ' ' + Helper.convTimestampToRelative(boardArticleObject.lastReplyTime),
                      style: TextStyle(fontSize: 12.0, color: E().threadListOtherTextColor),
                      overflow: TextOverflow.fade,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 5),
                    child: Text(
                      (boardArticleObject.replyCount - 1).toString() + ' ' + "repliersTrans".tr,
                      textWidthBasis: TextWidthBasis.parent,
                      style: TextStyle(
                        fontSize: 14.0,
                        color: E().threadListOtherTextColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget buildSeparator(BuildContext context, int index, {bool isLast = false}) {
    if (index == 0) {
      return Container(
        height: 4.0,
        margin: EdgeInsetsDirectional.zero,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.transparent, width: 4),
          ),
        ),
      );
    }
    return Container(
      height: 4.0,
      margin: EdgeInsetsDirectional.zero,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: E().threadListDividerColor, width: 4),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Obx(
      () => Scaffold(
        backgroundColor: E().threadListBackgroundColor,
        appBar: !widget.arg.keepTop
            ? null
            : BYRAppBar(
                title: Text(
                  data.articleList?.description ?? "",
                ),
                boardName: widget.arg.boardName,
                actions: <Widget>[
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                        'search_thread_page',
                        arguments: SearchThreadPageRouteArg(widget.arg.boardName),
                      );
                    },
                    icon: Icon(Icons.search),
                    iconSize: 24,
                  ),
                ],
              ),
        body: Center(
          child: widgetCase(
            initializationStatus,
            {
              InitializationStatus.Initializing: _buildLoadingView(),
              InitializationStatus.Failed: InitializationFailureView(
                failureInfo: failureInfo,
                textColor: E().threadListOtherTextColor,
                buttonColor: E().threadListOtherTextColor,
                refresh: initialization,
              ),
              InitializationStatus.Initialized: data.articleList == null
                  ? _buildLoadingView()
                  : RefresherFactory(
                      factor,
                      refreshController,
                      true,
                      true,
                      onTopRefresh,
                      onBottomRefresh,
                      buildList(),
                    ),
            },
            _buildLoadingView(),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FlatButton(
          shape: CircleBorder(),
          child: SizedBox(
            width: 56,
            height: 56,
            child: Container(
              child: Icon(
                Icons.create,
                color: Colors.white,
              ),
              decoration: BoxDecoration(
                color: BoardInfo.getBoardIconColor(widget.arg.boardName),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: BoardInfo.getBoardIconColor(widget.arg.boardName).withOpacity(0.5).darken(10),
                    spreadRadius: 2,
                    blurRadius: 4,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
            ),
          ),
          color: BoardInfo.getBoardIconColor(widget.arg.boardName),
          onPressed: () {
            Navigator.of(context).pushNamed('post_page', arguments: PostPageRouteArg(board: data.articleList));
          },
        ),
      ),
    );
  }

  @override
  buildList() {
    return CustomScrollView(
      physics: ScrollPhysics(),
      controller: scrollController,
      slivers: <Widget>[
        SliverToBoxAdapter(child: _buildTitleRow()),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 4,
            child: Container(
              color: E().threadListDividerColor,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: _buildTopExpansionTile(),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 4,
            child: Container(
              color: E().threadListDividerColor,
            ),
          ),
        ),
        if (widget.arg.isPicWaterfall) _buildPicBoardSliverListView() else _buildBoardSliverListView()
      ],
    );
  }

  List<Widget> _buildTopTiles() {
    List<Widget> l = [];
    for (int i = 1; i < topArticles.length; ++i) {
      l.add(
        Container(
          height: 1.0,
          margin: EdgeInsetsDirectional.only(start: 0),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: E().threadListDividerColor, width: 1.5),
            ),
          ),
        ),
      );
      l.add(
        NonPaddingListTile(
          title: Row(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                padding: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.blue,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                ),
                child: Text(
                  "stickyTopTrans".tr,
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              Expanded(
                child: Text(
                  topArticles[i].title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: E().threadListTileTitleColor),
                ),
              ),
            ],
          ),
          onTap: () {
            Navigator.pushNamed(context, "thread_page",
                arguments: ThreadPageRouteArg(topArticles[i].boardName, topArticles[i].groupId));
          },
        ),
      );
    }
    return l;
  }

  Widget _buildTopExpansionTile() {
    if (topArticles.length > 0) {
      return CustomExpansionTile(
        backgroundColor: E().threadListBackgroundColor,
        backgroundColorBegin: E().threadListBackgroundColor,
        backgroundColorEnd: E().threadListBackgroundColor,
        iconColorBegin: Colors.blue,
        iconColorEnd: Colors.blue,
        title: GestureDetector(
          child: Row(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                padding: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.blue,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                ),
                child: Text(
                  "stickyTopTrans".tr,
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              Expanded(
                child: Text(
                  topArticles[0].title,
                  style: TextStyle(
                    color: E().threadListTileTitleColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          onTap: () {
            Navigator.pushNamed(context, "thread_page",
                arguments: ThreadPageRouteArg(topArticles[0].boardName, topArticles[0].groupId));
          },
        ),
        children: _buildTopTiles(),
      );
    } else {
      return Container();
    }
  }

  Widget _buildTitleRow() {
    return Container(
        color: E().threadListBackgroundColor,
        child: NonPaddingListTile(
          title: Row(
            children: <Widget>[
              CircleAvatar(
                backgroundColor: BoardInfo.getBoardIconColor(data.articleList.name),
                child: Text(
                  data.articleList.getBoardCnShort(),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Flexible(
                child: Container(
                  padding: EdgeInsets.only(left: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        data.articleList.threadsTodayCount == 0
                            ? "noThreadTodayTrans".tr
                            : (data.articleList.threadsTodayCount == 1
                                ? "newThreadTodayTrans".trArgs([data.articleList.threadsTodayCount.toString()])
                                : "newThreadsTodayTrans".trArgs([data.articleList.threadsTodayCount.toString()])),
                        style: TextStyle(
                          color: E().threadListTileTitleColor,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        "threads".tr + ': ' + data.articleList.postThreadsCount.toString(),
                        style: TextStyle(color: E().threadListOtherTextColor, fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: data.articleList.isFavorite ? E().threadListBackgroundColor : Colors.blue,
                    border: Border.all(
                      color: Colors.blue,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(1.0),
                    ),
                  ),
                  child: Text(
                    data.articleList.isFavorite ? "hasFavorite".tr : ' + ' + "favorite".tr,
                    style: TextStyle(color: data.articleList.isFavorite ? Colors.blue : Colors.white),
                  ),
                ),
                onTap: () {
                  data.articleList.isFavorite ? data.articleList.delFavorite() : data.articleList.addFavorite();
                  data.articleList.isFavorite = !data.articleList.isFavorite;
                  if (mounted) {
                    setState(() {});
                  }
                },
              ),
              if (!widget.arg.keepTop)
                Container(
                  width: 10,
                ),
              if (!widget.arg.keepTop)
                Container(
                  child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                        'search_thread_page',
                        arguments: SearchThreadPageRouteArg(widget.arg.boardName),
                      );
                    },
                    icon: Icon(Icons.search),
                    iconSize: 24,
                    color: E().otherPageButtonColor,
                  ),
                ),
            ],
          ),
        ));
  }

  Widget _buildBoardSliverListView() {
    return SliverList(
        delegate: SliverChildBuilderDelegate(
      (_, index) {
        final int itemIndex = index ~/ 2;
        if (index.isEven) {
          return _buildBoardRow(data.articleList.article.sublist(topArticles.length)[itemIndex]);
        }
        return Container(
          height: 0.0,
          margin: EdgeInsetsDirectional.only(start: 14),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: E().threadListDividerColor, width: 0.8),
            ),
          ),
        );
      },
      childCount: max((data.articleList.article.length - topArticles.length) * 2 - 1, 0),
    ));
  }

  Widget _buildBoardRow(FrontArticleModel boardArticleObject) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, "thread_page",
            arguments: ThreadPageRouteArg(boardArticleObject.boardName, boardArticleObject.groupId));
      },
      child: Container(
        color: E().threadListBackgroundColor,
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              boardArticleObject.title,
              style: TextStyle(
                fontSize: 17.0,
                color: E().threadListTileTitleColor,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            Container(
              margin: EdgeInsets.only(top: 5),
              child: Row(
                children: <Widget>[
                  ClickableAvatar(
                    radius: 10,
                    imageLink: NForumService.makeGetURL(boardArticleObject.user?.faceUrl ?? ""),
                    isWhisper: (boardArticleObject.user?.id ?? "").startsWith("IWhisper"),
                    emptyUser: !GetUtils.isURL(boardArticleObject.user?.faceUrl),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    child: Text(
                      boardArticleObject.user?.id ?? "",
                      style: TextStyle(
                        fontSize: 15.0,
                        color: ConstColors.getUsernameColor(boardArticleObject.user?.gender),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "updatedOn".tr + ' ' + Helper.convTimestampToRelative(boardArticleObject.lastReplyTime),
                      style: TextStyle(fontSize: 12.0, color: E().threadListOtherTextColor),
                      overflow: TextOverflow.fade,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 5),
                    child: Text(
                      (boardArticleObject.replyCount - 1).toString() + ' ' + "repliersTrans".tr,
                      textWidthBasis: TextWidthBasis.parent,
                      style: TextStyle(
                        fontSize: 14.0,
                        color: E().threadListOtherTextColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPicBoardSliverListView() {
    return SliverStaggeredGrid.countBuilder(
      crossAxisCount: 4,
      itemCount: max((data.articleList.article.length - topArticles.length), 0),
      itemBuilder: (BuildContext context, int index) {
        return _buildPicBoardRow(data.articleList.article.sublist(topArticles.length)[index]);
      },
      staggeredTileBuilder: (int index) => StaggeredTile.fit(2),
    );
  }

  Widget _buildPicBoardRow(FrontArticleModel boardArticleObject) {
    return Container(
      padding: EdgeInsets.all(4),
      color: E().threadListDividerColor,
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, "thread_page",
              arguments: ThreadPageRouteArg(boardArticleObject.boardName, boardArticleObject.groupId));
        },
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          child: Container(
            color: E().threadListBackgroundColor,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                (boardArticleObject.isSubject)
                    ? ((boardArticleObject.hasAttachment &&
                            boardArticleObject.attachment != null &&
                            boardArticleObject.attachment.file != null &&
                            boardArticleObject.attachment.file.length > 0 &&
                            UploadedModelUploadedExtractor().getIsImage(boardArticleObject.attachment.file[0]))
                        ? CappedRatioFadeInImage(
                            cap: 2,
                            image: NetworkImage(
                              UploadedModelUploadedExtractor().getImgThumbnail(boardArticleObject.attachment.file[0]),
                            ),
                            fadeInDuration: Duration(milliseconds: 100),
                            placeholder: ((E().threadListBackgroundColor.red +
                                            E().threadListBackgroundColor.green +
                                            E().threadListBackgroundColor.blue) /
                                        3 <
                                    128)
                                ? AssetImage("resources/icon/media_black.png")
                                : AssetImage("resources/icon/media_white.png"),
                            fit: BoxFit.cover,
                          )
                        : Center(
                            child: Text(
                              NForumTextParser.stripText(NForumTextParser.retrieveEmojis(
                                boardArticleObject.content,
                              ).trim().replaceAll('\n\n', '\n').replaceAll(RegExp(r'\n+--\n*$'), '')),
                              maxLines: 5,
                              overflow: TextOverflow.fade,
                              style: TextStyle(
                                fontSize: 14.0,
                                color: E().threadListTileContentColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ))
                    : Icon(Icons.broken_image),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        boardArticleObject.title,
                        style: TextStyle(
                          fontSize: 17.0,
                          color: E().threadListTileTitleColor,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Row(
                          children: <Widget>[
                            ClickableAvatar(
                              radius: 10,
                              imageLink: NForumService.makeGetURL(boardArticleObject.user?.faceUrl ?? ""),
                              isWhisper: (boardArticleObject.user?.id ?? "").startsWith("IWhisper"),
                              emptyUser: !GetUtils.isURL(boardArticleObject.user?.faceUrl),
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                left: 5,
                              ),
                              child: Text(
                                boardArticleObject.user?.id ?? "",
                                style: TextStyle(
                                  fontSize: 15.0,
                                  color: ConstColors.getUsernameColor(boardArticleObject.user?.gender),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingView() {
    return ShimmerTheme(
      child: ListView.separated(
        itemCount: 20,
        padding: const EdgeInsets.all(0),
        separatorBuilder: (context, i) {
          if (i == 0 || i == 1) {
            return Container(
              height: 0.0,
              margin: EdgeInsetsDirectional.only(start: 0),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: E().threadListDividerColor, width: 4),
                ),
              ),
            );
          }
          return Container(
            height: 0.0,
            margin: EdgeInsetsDirectional.only(start: 15),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: E().threadListDividerColor, width: 0.5),
              ),
            ),
          );
        },
        itemBuilder: (context, i) {
          if (i == 0) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 5),
                        height: 45,
                        width: 45,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(left: 5, bottom: 10, top: 8),
                            height: 20,
                            width: 120,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
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
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 5),
                        height: 20,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                      ),
                      if (!widget.arg.keepTop)
                        Container(
                          width: 10,
                        ),
                      if (!widget.arg.keepTop)
                        Container(
                          margin: EdgeInsets.only(left: 5),
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                        ),
                    ],
                  ),
                ],
              ),
            );
          }
          if (i == 1) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 5, bottom: 10, top: 8),
                    height: 20,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: 5, bottom: 10, top: 8),
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 5, bottom: 10, top: 8),
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
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
                Container(
                  margin: EdgeInsets.only(left: 5, bottom: 10, top: 8),
                  height: 20,
                  width: ((Random().nextInt(50) + 40) / 100) * MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 5),
                            height: 15,
                            width: 15,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
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
                          Container(
                            margin: EdgeInsets.only(left: 5),
                            height: 15,
                            width: 100,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                          ),
                        ],
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
              ],
            ),
          );
        },
      ),
    );
  }
}
