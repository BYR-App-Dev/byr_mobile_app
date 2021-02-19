import 'package:byr_mobile_app/customizations/shimmer_theme.dart';
import 'package:byr_mobile_app/customizations/theme_controller.dart';
import 'package:byr_mobile_app/helper/helper.dart';
import 'package:byr_mobile_app/nforum/nforum_service.dart';
import 'package:byr_mobile_app/nforum/nforum_structures.dart';
import 'package:byr_mobile_app/pages/list_base_page.dart';
import 'package:byr_mobile_app/pages/pages.dart';
import 'package:byr_mobile_app/reusable_components/about_page_user_widget.dart';
import 'package:byr_mobile_app/reusable_components/adaptive_components.dart';
import 'package:byr_mobile_app/reusable_components/page_initialization.dart';
import 'package:byr_mobile_app/reusable_components/refreshers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class CloudBlocklistPage extends UserListPage {
  @override
  State<StatefulWidget> createState() {
    return CloudBlocklistPageState();
  }
}

class CloudBlocklistPageState extends UserListPageState<UserListModel, CloudBlocklistPage> {
  @override
  void initialization() {
    data = UserListData<UserListModel>()
      ..dataRequestHandler = (int page) {
        return NForumService.getBlocklist(page);
      };
    super.initialization();
  }

  @override
  Widget buildCell(BuildContext context, int index) {
    UserModel articleObject = data.articleList.article[index];
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onLongPress: () {
        AdaptiveComponents.showAlertDialog(
          context,
          title: "removeBlocklistEntry".tr + ": " + articleObject.id,
          onDismiss: (result) {
            AdaptiveComponents.showLoading(context);
            if (result == AlertResult.confirm) {
              NForumService.deleteBlocklistEntry(articleObject.id).then((value) {
                AdaptiveComponents.hideLoading();
                if (value == true) {
                  onTopRefresh();
                }
              }).catchError((e) {
                AdaptiveComponents.hideLoading();
              });
            }
          },
        );
      },
      child: AboutPageUserWidget(id: articleObject.id),
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

  final userIdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Obx(
      () => Scaffold(
        backgroundColor: E().threadListBackgroundColor,
        body: Container(
          child: Column(
            children: [
              Container(
                color: E().otherPagePrimaryColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      padding: EdgeInsets.all(0.0),
                      icon: Icon(
                        Icons.add,
                        size: 28,
                        color: E().otherPageTopBarButtonColor,
                      ),
                      onPressed: () {
                        AdaptiveComponents.showAlertDialog(
                          context,
                          title: "addBlocklistEntry".tr,
                          barrierDismissible: false,
                          contentWidget: Material(
                            child: TextField(
                              autofocus: true,
                              controller: userIdController,
                              decoration: InputDecoration(labelText: 'id'),
                              style: TextStyle(color: E().dialogContentColor),
                              maxLines: null,
                            ),
                            color: Colors.transparent,
                          ),
                          onDismiss: (result) {
                            if (result == AlertResult.confirm) {
                              AdaptiveComponents.showLoading(context);
                              NForumService.addBlocklistEntry(userIdController.text.trim()).then((value) {
                                AdaptiveComponents.hideLoading();
                                if (value == true) {
                                  onTopRefresh();
                                }
                              }).catchError((e) {
                                AdaptiveComponents.hideLoading();
                              });
                              userIdController.clear();
                            } else {
                              userIdController.clear();
                            }
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  color: E().otherPagePrimaryColor,
                  child: RefreshConfiguration(
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
                                  GridView.builder(
                                    controller: scrollController,
                                    itemCount: cellCount(),
                                    itemBuilder: (context, index) {
                                      return buildCell(context, index);
                                    },
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: (cellCount() ?? 0) == 0 ? 1 : 2,
                                      mainAxisSpacing: 0.0,
                                      crossAxisSpacing: 0.0,
                                      childAspectRatio: 3.0,
                                    ),
                                  ),
                                ),
                        },
                        _buildLoadingView(),
                      ),
                    ),
                  ),
                ),
              ),
            ],
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
          );
        },
        itemBuilder: (context, i) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 7),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Row(
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
                              ],
                            ),
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
                    ],
                  ),
                ),
                Flexible(
                  child: Row(
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
                              ],
                            ),
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
