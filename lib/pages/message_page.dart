import 'dart:async';

import 'package:byr_mobile_app/customizations/theme_controller.dart';
import 'package:byr_mobile_app/nforum/nforum_service.dart';
import 'package:byr_mobile_app/pages/pages.dart';
import 'package:byr_mobile_app/reusable_components/adaptive_components.dart';
import 'package:byr_mobile_app/reusable_components/byr_app_bar.dart';
import 'package:byr_mobile_app/reusable_components/custom_tab_controller.dart';
import 'package:byr_mobile_app/reusable_components/custom_tabs.dart';
import 'package:byr_mobile_app/reusable_components/custom_underline_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MessageController extends GetxController {
  RxInt replyNewMessageCount = 0.obs;
  RxInt atMessageCount = 0.obs;
  RxInt mailMessageCount = 0.obs;

  Timer _timer;

  int get allCount => replyNewMessageCount() + atMessageCount() + mailMessageCount();

  @override
  void onInit() {
    getMsgCount();
    startCountDownTimer();
    super.onInit();
  }

  @override
  Future<void> onClose() {
    _timer.cancel();
    return super.onClose();
  }

  startCountDownTimer() {
    _timer = Timer.periodic(Duration(minutes: 3), (t) {
      getMsgCount();
    });
  }

  void getMsgCount() {
    NForumService.getNewMessageCount().then((value) {
      replyNewMessageCount.value = value.item1;
      atMessageCount.value = value.item2;
      mailMessageCount.value = value.item3;
    });
  }

  void setReferAllRead() async {
    await NForumService.setReferAllRead(ReferType.At);
    await NForumService.setReferAllRead(ReferType.Reply);
    getMsgCount();
  }
}

class MessagePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MessagePageState();
  }
}

class MessagePageState extends State<MessagePage> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  CustomTabController tabController;

  final controller = Get.find<MessageController>();

  @override
  void initState() {
    tabController = CustomTabController(initialIndex: 0, length: 3, vsync: this);
    super.initState();
  }

  void setReferAllRead() {
    AdaptiveComponents.showAlertDialog(
      context,
      title: "allReadTrans".tr,
      onDismiss: (value) {
        if (value == AlertResult.confirm) {
          controller.setReferAllRead();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Obx(
      () => Scaffold(
        appBar: BYRAppBar(
          elevation: 0,
          actions: <Widget>[
            IconButton(
              onPressed: () {
                setReferAllRead();
              },
              icon: Icon(
                Icons.done_all,
                color: E().tabPageTopBarButtonColor,
              ),
              iconSize: 24,
            ),
          ],
          flexibleSpace: SafeArea(
            child: Padding(
              padding: EdgeInsets.only(left: IconTheme.of(context).size * (2), right: IconTheme.of(context).size * (2)),
              child: CustomTabBar(
                indicator: FixedUnderlineTabIndicator(
                  borderSide: BorderSide(
                    width: 3,
                    color: E().tabPageTopBarSliderColor,
                  ),
                ),
                indicatorWeight: 3,
                labelStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                labelColor: E().topBarTitleNormalColor,
                unselectedLabelStyle: TextStyle(fontSize: 12),
                unselectedLabelColor: E().topBarTitleUnSelectedColor,
                tabs: <CustomTab>[
                  CustomTab(
                    unselectedFontSize: 12,
                    icon: Stack(
                      overflow: Overflow.visible,
                      children: <Widget>[
                        Container(),
                        controller.replyNewMessageCount() > 0
                            ? Positioned(
                                top: 0,
                                right: 0,
                                child: Container(
                                  padding: EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  constraints: BoxConstraints(
                                    minWidth: 12,
                                    minHeight: 12,
                                  ),
                                  child: Text(
                                    controller.replyNewMessageCount() <= 99
                                        ? controller.replyNewMessageCount().toString()
                                        : '...',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              )
                            : SizedBox.shrink()
                      ],
                    ),
                    text: "replyReferTrans".tr,
                  ),
                  CustomTab(
                    unselectedFontSize: 12,
                    icon: Stack(
                      overflow: Overflow.visible,
                      children: <Widget>[
                        Container(),
                        controller.atMessageCount() > 0
                            ? Positioned(
                                top: 0,
                                right: 0,
                                child: Container(
                                  padding: EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  constraints: BoxConstraints(
                                    minWidth: 12,
                                    minHeight: 12,
                                  ),
                                  child: Text(
                                    controller.atMessageCount() <= 99 ? controller.atMessageCount().toString() : '...',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              )
                            : SizedBox.shrink()
                      ],
                    ),
                    text: "atReferTrans".tr,
                  ),
                  CustomTab(
                    unselectedFontSize: 12,
                    icon: Stack(
                      overflow: Overflow.visible,
                      children: <Widget>[
                        Container(),
                        controller.mailMessageCount() > 0
                            ? Positioned(
                                top: 0,
                                right: 0,
                                child: Container(
                                  padding: EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  constraints: BoxConstraints(
                                    minWidth: 12,
                                    minHeight: 12,
                                  ),
                                  child: Text(
                                    controller.mailMessageCount() <= 99
                                        ? controller.mailMessageCount().toString()
                                        : '...',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              )
                            : SizedBox.shrink()
                      ],
                    ),
                    text: "smsTrans".tr,
                  ),
                ],
                indicatorColor: E().tabPageTopBarSliderColor,
                controller: tabController,
              ),
            ),
          ),
        ),
        backgroundColor: E().topBarBackgroundColor,
        body: CustomTabBarView(
          children: <Widget>[
            ReferboxPage(ReferType.Reply),
            ReferboxPage(ReferType.At),
            MailboxPage(),
          ],
          controller: tabController,
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
