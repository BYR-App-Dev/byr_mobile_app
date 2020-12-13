import 'dart:math';

import 'package:byr_mobile_app/customizations/board_info.dart';
import 'package:byr_mobile_app/customizations/shimmer_theme.dart';
import 'package:byr_mobile_app/customizations/theme_controller.dart';
import 'package:byr_mobile_app/helper/helper.dart';
import 'package:byr_mobile_app/local_objects/local_models.dart';
import 'package:byr_mobile_app/pages/article_list_base_page.dart';
import 'package:byr_mobile_app/pages/pages.dart';
import 'package:byr_mobile_app/reusable_components/byr_app_bar.dart';
import 'package:byr_mobile_app/reusable_components/page_initialization.dart';
import 'package:byr_mobile_app/reusable_components/refreshers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class HistoryPage extends ArticleListBasePage {
  @override
  State<StatefulWidget> createState() {
    return HistoryPageState();
  }
}

class HistoryPageState extends ArticleListBasePageState<HistoryListModel, HistoryPage> {
  @override
  void initialization() {
    data = ArticleListBaseData<HistoryListModel>()
      ..dataRequestHandler = (int page) async {
        return HistoryListModel.fromList(HistoryModel.ordered());
      };
    super.initialization();
  }

  @override
  Widget buildCell(BuildContext context, int index) {
    HistoryArticleModel historyArticleObject = data.articleList.article[index];
    return InkWell(
      // highlightColor: E().threadListBackgroundColor.withOpacity(0.12),
      // splashColor: E().threadListBackgroundColor.withOpacity(0.15),
      onTap: () async {
        await Navigator.pushNamed(context, "thread_page",
            arguments: ThreadPageRouteArg(
                historyArticleObject.boardName,
                historyArticleObject.groupId.runtimeType == String
                    ? int.tryParse(historyArticleObject.groupId)
                    : historyArticleObject.groupId));
        onTopRefresh();
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              historyArticleObject.title,
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
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    width: 25,
                    height: 25,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: BoardInfo.getBoardIconColor(data.articleList.article[index].boardName),
                    ),
                    child: Center(
                      child: Text(
                        BoardInfo.getBoardCnShort(
                            data.articleList.article[index].boardName, data.articleList.article[index].boardName),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '最后浏览于 ' + Helper.convTimestampToRelative(historyArticleObject.createdTime),
                        style: TextStyle(fontSize: 12.0, color: E().threadListOtherTextColor),
                        overflow: TextOverflow.fade,
                      ),
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
    return Container(
      height: 0.0,
      margin: EdgeInsetsDirectional.only(start: 14),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: E().threadListDividerColor, width: 0.8),
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
        appBar: BYRAppBar(
          title: Text(
            "browsingHistory".tr,
          ),
        ),
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
                        false,
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
        itemCount: 20,
        padding: const EdgeInsets.all(0),
        separatorBuilder: (context, i) {
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
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: 5, bottom: 10, top: 8),
                  height: 20,
                  width: ((Random().nextInt(30) + 60) / 100) * MediaQuery.of(context).size.width,
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
