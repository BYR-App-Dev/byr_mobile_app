import 'package:byr_mobile_app/customizations/const_colors.dart';
import 'package:byr_mobile_app/customizations/shimmer_theme.dart';
import 'package:byr_mobile_app/customizations/theme_controller.dart';
import 'package:byr_mobile_app/helper/helper.dart';
import 'package:byr_mobile_app/nforum/nforum_service.dart';
import 'package:byr_mobile_app/nforum/nforum_structures.dart';
import 'package:byr_mobile_app/pages/pageable_list_base_page.dart';
import 'package:byr_mobile_app/pages/pages.dart';
import 'package:byr_mobile_app/reusable_components/clickable_avatar.dart';
import 'package:byr_mobile_app/reusable_components/page_initialization.dart';
import 'package:byr_mobile_app/reusable_components/refreshers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tinycolor/tinycolor.dart';

class MailboxBaseData<X extends MailBoxModel> extends PageableListBaseData<X> {
  X articleList;
  PageableListDataRequestHandler<X> dataRequestHandler;
}

class MailboxPage extends PageableListBasePage {
  @override
  State<StatefulWidget> createState() {
    return MailboxPageState();
  }
}

class MailboxPageState extends PageableListBasePageState<MailBoxModel, MailboxPage> {
  @override
  void initialization() {
    data = MailboxBaseData<MailBoxModel>()
      ..dataRequestHandler = (int page) {
        if (page == 1) {
          Get.find<MessageController>().getMsgCount();
        }
        return NForumService.getMailBox(page);
      };
    super.initialization();
  }

  @override
  Widget buildCell(BuildContext context, int index, {bool isScreenshot = false}) {
    MailModel object = data.articleList.article[index];
    return Container(
      decoration:
          BoxDecoration(color: object.isRead ? E().threadListBackgroundColor : E().threadListBackgroundColor.darken(5)),
      child: InkWell(
        highlightColor: E().threadListBackgroundColor.withOpacity(0.12),
        splashColor: E().threadListBackgroundColor.withOpacity(0.15),
        onTap: () {
          if (object.isRead == false) {
            Get.find<MessageController>().getMsgCount();
          }
          object.isRead = true;
          if (mounted) {
            setState(() {});
          }
          Navigator.pushNamed(context, 'mail_page', arguments: MailPageRouteArg(object.index));
        },
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 10, 5, 10),
          child: Row(
            children: <Widget>[
              ClickableAvatar(
                radius: 20,
                isWhisper: (object.user?.id ?? "").startsWith("IWhisper"),
                imageLink: NForumService.makeGetURL(object.user?.faceUrl ?? ""),
                emptyUser: object.user?.faceUrl == null,
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
                            object.user.id,
                            style: TextStyle(
                              fontSize: 16.5,
                              color: ConstColors.getUsernameColor(object.user?.gender),
                            ),
                          ),
                          Text(
                            Helper.convTimestampToRelative(object.postTime),
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
                        object.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: object.isRead
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
