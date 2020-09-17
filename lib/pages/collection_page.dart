import 'dart:math';

import 'package:byr_mobile_app/customizations/const_colors.dart';
import 'package:byr_mobile_app/customizations/theme_controller.dart';
import 'package:byr_mobile_app/helper/helper.dart';
import 'package:byr_mobile_app/nforum/nforum_service.dart';
import 'package:byr_mobile_app/nforum/nforum_structures.dart';
import 'package:byr_mobile_app/pages/article_list_base_page.dart';
import 'package:byr_mobile_app/pages/pages.dart';
import 'package:byr_mobile_app/reusable_components/adaptive_components.dart';
import 'package:byr_mobile_app/reusable_components/byr_app_bar.dart';
import 'package:byr_mobile_app/reusable_components/clickable_avatar.dart';
import 'package:byr_mobile_app/reusable_components/page_initialization.dart';
import 'package:byr_mobile_app/reusable_components/refreshers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class CollectionPage extends ArticleListBasePage {
  @override
  State<StatefulWidget> createState() {
    return CollectionPageState();
  }
}

class CollectionPageState extends ArticleListBasePageState<CollectionModel, CollectionPage> {
  @override
  void initialization() {
    data = ArticleListBaseData<CollectionModel>()
      ..dataRequestHandler = (int page) {
        return NForumService.getCollection(page);
      };
    super.initialization();
  }

  @override
  Widget buildCell(BuildContext context, int index) {
    CollectionArticleModel collectionArticleObject = data.articleList.article[index];
    return InkWell(
      highlightColor: E().threadListBackgroundColor.withOpacity(0.12),
      splashColor: E().threadListBackgroundColor.withOpacity(0.15),
      onTap: () {
        Navigator.pushNamed(context, "thread_page",
            arguments: ThreadPageRouteArg(collectionArticleObject.boardName, collectionArticleObject.groupId));
      },
      onLongPress: () {
        AdaptiveComponents.showAlertDialog(
          context,
          title: "removeCollectionTrans".tr,
          onDismiss: (result) {
            if (result == AlertResult.confirm) {
              NForumService.removeCollection(collectionArticleObject.boardName, collectionArticleObject.groupId)
                  .then((value) {
                data.articleList.article.removeAt(index);
                if (mounted) {
                  setState(() {});
                }
              });
            }
          },
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              collectionArticleObject.title,
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
                    imageLink: NForumService.makeGetURL(collectionArticleObject.user?.faceUrl ?? ""),
                    emptyUser: collectionArticleObject.user?.faceUrl == null,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    child: Text(
                      collectionArticleObject.user?.id ?? "",
                      style: TextStyle(
                        fontSize: 15.0,
                        color: ConstColors.getUsernameColor(collectionArticleObject.user?.gender),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '收藏于 ' + Helper.convTimestampToRelative(collectionArticleObject.createdTime),
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
            "collectionTrans".tr,
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
    return Shimmer.fromColors(
      baseColor: !E().isThemeDarkStyle ? Colors.grey[300] : Colors.grey,
      highlightColor: !E().isThemeDarkStyle ? Colors.grey[100] : Colors.white,
      enabled: true,
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
