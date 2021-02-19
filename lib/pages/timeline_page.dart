import 'package:byr_mobile_app/customizations/board_info.dart';
import 'package:byr_mobile_app/customizations/shimmer_theme.dart';
import 'package:byr_mobile_app/customizations/theme_controller.dart';
import 'package:byr_mobile_app/helper/helper.dart';
import 'package:byr_mobile_app/local_objects/local_models.dart';
import 'package:byr_mobile_app/nforum/nforum_service.dart';
import 'package:byr_mobile_app/nforum/nforum_structures.dart';
import 'package:byr_mobile_app/nforum/nforum_text_parser.dart';
import 'package:byr_mobile_app/pages/list_base_page.dart';
import 'package:byr_mobile_app/pages/pages.dart';
import 'package:byr_mobile_app/reusable_components/article_cell.dart';
import 'package:byr_mobile_app/reusable_components/page_initialization.dart';
import 'package:byr_mobile_app/reusable_components/refreshers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TimelinePage extends ArticleListBasePage {
  @override
  State<StatefulWidget> createState() {
    return TimelinePageState();
  }
}

class TimelinePageState extends ArticleListBasePageState<TimelineModel, TimelinePage> {
  @override
  void initialization() {
    data = ArticleListBaseData<TimelineModel>()
      ..dataRequestHandler = (int page) {
        return NForumService.getTimeline(page);
      };
    super.initialization();
  }

  @override
  Widget buildCell(BuildContext context, int index) {
    if (Blocklist.getIsBlocked() == true &&
        Blocklist.getBlocklist()[data.articleList.article[index].user?.id] == true) {
      return Container();
    }
    return InkWell(
      // highlightColor: E().threadListBackgroundColor.withOpacity(0.12),
      // splashColor: E().threadListBackgroundColor.withOpacity(0.15),
      onTap: () {
        navigator.pushNamed(
          "thread_page",
          arguments:
              ThreadPageRouteArg(data.articleList.article[index].boardName, data.articleList.article[index].groupId),
        );
      },
      child: Container(
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
                    user: data.articleList.article[index].user,
                    postTime: data.articleList.article[index].postTime,
                    contentColor: E().threadListTileContentColor,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 5),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, 'board_page',
                              arguments: BoardPageRouteArg(data.articleList.article[index].boardName));
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 5),
                          decoration: BoxDecoration(
                            color: BoardInfo.getBoardIconColor(data.articleList.article[index].boardName),
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                          child: Text(
                            data.articleList.article[index].boardDescription,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 5),
              child: ArticleCell(
                title: data.articleList.article[index].title,
                content: NForumTextParser.stripText(
                  NForumTextParser.retrieveEmojis(data.articleList.article[index].content)
                          .trim()
                          .replaceAll('\n\n', '\n')
                          .replaceAll(RegExp(r'\n+--\n*$'), '')
                          .replaceAll('\n', '') +
                      "...",
                ),
                contentColor: E().threadListTileContentColor,
                iconColor: E().threadListTileContentColor,
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
                imageUrls: data.articleList.article[index].hasAttachment
                    ? NForumTextParser.getImageURLs(data.articleList.article[index].attachment)
                    : [],
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
    if (Blocklist.getIsBlocked() == true &&
        Blocklist.getBlocklist()[data.articleList.article[index - 1].user.id] == true) {
      return Container();
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
        body: RefreshConfiguration(
          child: Center(
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
        ),
      ),
    );
  }

  Widget _buildLoadingView() {
    return ShimmerTheme(
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
