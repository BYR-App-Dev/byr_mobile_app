import 'package:byr_mobile_app/customizations/const_colors.dart';
import 'package:byr_mobile_app/customizations/theme_controller.dart';
import 'package:byr_mobile_app/helper/helper.dart';
import 'package:byr_mobile_app/nforum/nforum_service.dart';
import 'package:byr_mobile_app/nforum/nforum_structures.dart';
import 'package:byr_mobile_app/pages/article_list_base_page.dart';
import 'package:byr_mobile_app/pages/pages.dart';
import 'package:byr_mobile_app/reusable_components/clickable_avatar.dart';
import 'package:byr_mobile_app/reusable_components/page_initialization.dart';
import 'package:byr_mobile_app/reusable_components/refreshers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class ReferboxPage extends ArticleListBasePage {
  final ReferType referType;
  ReferboxPage(this.referType);
  @override
  State<StatefulWidget> createState() {
    return ReferboxPageState();
  }
}

class ReferboxPageState extends ArticleListBasePageState<ReferBoxModel, ReferboxPage> {
  @override
  void initialization() {
    data = ArticleListBaseData<ReferBoxModel>()
      ..dataRequestHandler = widget.referType == ReferType.Reply
          ? (int page) {
              if (page == 1) {
                Get.find<MessageController>().getMsgCount();
              }
              return NForumService.getReply(page);
            }
          : (int page) {
              if (page == 1) {
                Get.find<MessageController>().getMsgCount();
              }
              return NForumService.getAt(page);
            };
    super.initialization();
  }

  @override
  Widget buildCell(BuildContext context, int index) {
    ReferModel referArticleObject = data.articleList.article[index];
    return InkWell(
      highlightColor: E().threadListBackgroundColor.withOpacity(0.12),
      splashColor: E().threadListBackgroundColor.withOpacity(0.15),
      onTap: () {
        if (referArticleObject.isRead == false) {
          NForumService.setReferRead(this.widget.referType, referArticleObject.index).then((value) {
            Get.find<MessageController>().getMsgCount();
          });
        }
        referArticleObject.isRead = true;
        if (mounted) {
          setState(() {});
        }
        Navigator.pushNamed(context, 'thread_page',
            arguments: ThreadPageRouteArg(referArticleObject.boardName, referArticleObject.groupId,
                startingPosition: referArticleObject.pos));
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(20, 10, 5, 10),
        child: Row(
          children: <Widget>[
            ClickableAvatar(
              radius: 20,
              isWhisper: (referArticleObject.user?.id ?? "").startsWith("IWhisper"),
              imageLink: NForumService.makeGetURL(referArticleObject.user?.faceUrl ?? ""),
              emptyUser: referArticleObject.user?.faceUrl == null,
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          referArticleObject.user?.id ?? "",
                          style: TextStyle(
                            fontSize: 16.5,
                            color: ConstColors.getUsernameColor(referArticleObject.user?.gender),
                          ),
                        ),
                        Text(
                          Helper.convTimestampToRelative(referArticleObject.time),
                          style: TextStyle(
                            fontSize: 14.0,
                            color: E().notificationListTileOtherTextColor,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 3,
                    ),
                    Text(
                      referArticleObject.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: referArticleObject.isRead
                          ? TextStyle(
                              color: E().notificationListTileTitleColor,
                            )
                          : TextStyle(
                              fontWeight: FontWeight.bold,
                              color: E().notificationListTileTitleColor,
                            ),
                    ),
                  ],
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: E().notificationListTileOtherTextColor,
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
      margin: EdgeInsetsDirectional.only(start: 16),
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
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 7),
            child: Row(
              mainAxisSize: MainAxisSize.max,
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
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 5, bottom: 10, top: 8),
                              height: 15,
                              width: 80,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 5, bottom: 10, top: 8),
                              height: 12,
                              width: 80,
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
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                      ),
                    ],
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
