import 'package:byr_mobile_app/customizations/board_info.dart';
import 'package:byr_mobile_app/customizations/theme_controller.dart';
import 'package:byr_mobile_app/helper/helper.dart';
import 'package:byr_mobile_app/local_objects/local_storage.dart';
import 'package:byr_mobile_app/nforum/nforum_service.dart';
import 'package:byr_mobile_app/nforum/nforum_structures.dart';
import 'package:byr_mobile_app/nforum/nforum_text_parser.dart';
import 'package:byr_mobile_app/reusable_components/article_cell.dart';
import 'package:byr_mobile_app/reusable_components/page_initialization.dart';
import 'package:byr_mobile_app/reusable_components/refreshers.dart';
import 'package:byr_mobile_app/reusable_components/screenshot_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import 'pages.dart';

class ToptenPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ToptenPageState();
  }
}

class ToptenPageState extends State<ToptenPage> with AutomaticKeepAliveClientMixin, InitializableMixin {
  @override
  bool get wantKeepAlive => true;

  ToptenModel toptenObject;

  int factor = RefresherFactory.getFactor();

  RefreshController refreshController = RefreshController(initialRefresh: false);

  ScrollController scrollController = ScrollController();

  ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState() {
    initialization();
    super.initState();
  }

  @override
  void dispose() {
    refreshController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  void initialization() {
    NForumService.getTopten().then((topten) {
      toptenObject = topten;
      initializationStatus = InitializationStatus.Initialized;
      if (mounted) {
        setState(() {});
      }
    }).catchError(initializationErrorHandling);
  }

  void refreshErrorHandling(e) {
    setFailureInfo(e);
    refreshController.refreshFailed();
  }

  Future<void> onTopRefresh() {
    return NForumService.getTopten().then((topten) {
      toptenObject = topten;
      refreshController.refreshCompleted();
      if (mounted) {
        setState(() {});
      }
    }).catchError(refreshErrorHandling);
  }

  Future<void> onBottomRefresh() async {
    try {
      var image = await screenshotController.capture(
        delay: Duration(milliseconds: 10),
        pixelRatio: MediaQuery.of(context).devicePixelRatio,
      );
      GallerySaver.saveImage(image.path, albumName: 'BYRDownload');
      refreshController.loadComplete();
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text("screenshotCaptured".tr),
          duration: Duration(seconds: 1),
        ),
      );
    } on Exception catch (_) {
      refreshController.loadFailed();
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Obx(
      () => Scaffold(
        backgroundColor: E().threadListBackgroundColor,
        body: RefreshConfiguration(
          child: Center(
            child: widgetCase(
              initializationStatus,
              {
                InitializationStatus.Initializing: _buildLoadingView(),
                InitializationStatus.Initialized: toptenObject == null
                    ? _buildLoadingView()
                    : RefresherFactory(
                        factor,
                        refreshController,
                        true,
                        LocalStorage.getIsToptenScreenshotEnabled(),
                        onTopRefresh,
                        onBottomRefresh,
                        _buildToptenListView(),
                        bottomScreenshot: LocalStorage.getIsToptenScreenshotEnabled(),
                      ),
                InitializationStatus.Failed: InitializationFailureView(
                  failureInfo: failureInfo,
                  textColor: E().threadListOtherTextColor,
                  buttonColor: E().threadListOtherTextColor,
                  refresh: initialization,
                ),
              },
              _buildLoadingView(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildToptenListView() {
    return SingleChildScrollView(
      controller: scrollController,
      child: Screenshot(
        controller: screenshotController,
        child: Container(
          color: E().threadPageBackgroundColor,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              toptenObject.article.length * 2 + 1,
              (i) {
                if (i == 0) {
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
                if (i % 2 == 0) {
                  return Container(
                    height: 4.0,
                    margin: EdgeInsetsDirectional.zero,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: E().threadListDividerColor, width: 4),
                      ),
                    ),
                  );
                } else {
                  return _buildToptenRow(toptenObject.article[((i - 1) / 2).round()]);
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildToptenRow(FrontArticleModel threadObject) {
    return Container(
      color: E().threadListBackgroundColor,
      child: InkWell(
        highlightColor: E().threadListBackgroundColor.withOpacity(0.12),
        splashColor: E().threadListBackgroundColor.withOpacity(0.15),
        onTap: () {
          navigator.pushNamed("thread_page",
              arguments: ThreadPageRouteArg(threadObject.boardName, threadObject.groupId));
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(right: 5),
                child: CircleAvatar(
                  radius: 13,
                  backgroundColor: BoardInfo.getBoardIconColor(threadObject.boardName),
                  child: Text(
                    BoardInfo.getBoardCnShort(threadObject.boardName, threadObject.boardDescription),
                    style: TextStyle(
                      fontSize: 15.0,
                      color: E().threadListBackgroundColor,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ArticleCell(
                      title:
                          threadObject.title.substring(0, threadObject.title.length - threadObject.idCount.length - 2),
                      content: NForumTextParser.stripText(
                        NForumTextParser.retrieveEmojis(threadObject.content)
                                .trim()
                                .replaceAll('\n\n', '\n')
                                .replaceAll(RegExp(r'\n+--\n*$'), '')
                                .replaceAll('\n', '') +
                            "...",
                      ),
                      titleStyle: TextStyle(
                        fontSize: 17.0,
                        color: E().threadListTileTitleColor,
                        fontWeight: FontWeight.w500,
                      ),
                      contentStyle: TextStyle(
                        fontSize: 15.0,
                        height: 1.8,
                        color: E().threadListTileContentColor,
                      ),
                      imageUrls:
                          threadObject.hasAttachment ? NForumTextParser.getImageURLs(threadObject.attachment) : [],
                      contentColor: E().threadListTileContentColor,
                      iconColor: E().threadListTileContentColor,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 5),
                      child: Text(
                        '${threadObject.idCount} ${"participantsTrans".tr}  ${threadObject.replyCount} ${"repliesTrans".tr}',
                        style: TextStyle(
                          fontSize: 12.0,
                          color: E().threadListOtherTextColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingView() {
    return Shimmer.fromColors(
      baseColor: !E().isThemeDarkStyle ? Colors.grey[300] : Colors.grey,
      highlightColor: !E().isThemeDarkStyle ? Colors.grey[100] : Colors.white,
      enabled: true,
      child: ListView.separated(
        itemCount: 6,
        padding: const EdgeInsets.all(0),
        separatorBuilder: (context, i) => Container(
          height: 0.0,
          margin: EdgeInsetsDirectional.only(start: 15),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: E().threadListDividerColor, width: 0.5),
            ),
          ),
        ),
        itemBuilder: (context, i) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: 5),
                  child: CircleAvatar(
                    radius: 13,
                    backgroundColor: Colors.white,
                  ),
                ),
                Expanded(
                  child: ArticleCell(
                    title: '',
                    content: '',
                    titleStyle: null,
                    contentStyle: null,
                    emptyCell: true,
                    contentColor: Colors.transparent,
                    iconColor: Colors.transparent,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
