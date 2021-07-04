import 'package:byr_mobile_app/customizations/const_colors.dart';
import 'package:byr_mobile_app/customizations/theme_controller.dart';
import 'package:byr_mobile_app/local_objects/local_models.dart';
import 'package:byr_mobile_app/nforum/nforum_service.dart';
import 'package:byr_mobile_app/nforum/nforum_structures.dart';
import 'package:byr_mobile_app/pages/pages.dart';
import 'package:byr_mobile_app/reusable_components/adaptive_components.dart';
import 'package:byr_mobile_app/reusable_components/byr_app_bar.dart';
import 'package:byr_mobile_app/reusable_components/clickable_avatar.dart';
import 'package:byr_mobile_app/reusable_components/pic_swiper.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class ProfilePage extends StatefulWidget {
  final UserModel user;

  const ProfilePage({Key key, this.user}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ProfilePageState();
  }
}

class ProfilePageState extends State<ProfilePage> {
  _cardInfoCell(String title, String value) {
    return Column(
      children: <Widget>[
        Text(
          value,
          style: TextStyle(
            color: E().userPageTextColor,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            color: E().userPageTextColor,
          ),
        ),
      ],
    );
  }

  _detailCell(String title, String value) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          height: 40,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                  color: E().userPageTextColor,
                  fontSize: 15,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  color: E().userPageTextColor,
                ),
              ),
            ],
          ),
        ),
        Divider(
          height: 1,
          color: E().userPageSecondaryBackgroundColor,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var blocklist = Blocklist.getBlocklist();
    return Obx(
      () => Scaffold(
        backgroundColor: E().userPagePrimaryBackgroundColor,
        appBar: BYRAppBar(
          title: Text(
            "profilePageName".tr,
          ),
          actions: [
            if (blocklist[widget.user.id] == null || blocklist[widget.user.id] == false)
              IconButton(
                icon: Icon(Icons.visibility_off_outlined, color: E().otherPageTopBarButtonColor),
                onPressed: () async {
                  Blocklist.addBlocklistItem(widget.user.id);
                  if (mounted) {
                    setState(() {});
                  }
                },
              )
            else
              IconButton(
                icon: Icon(Icons.visibility_outlined, color: E().otherPageTopBarButtonColor),
                onPressed: () async {
                  Blocklist.removeBlocklistItem(widget.user.id);
                  if (mounted) {
                    setState(() {});
                  }
                },
              ),
            IconButton(
              icon: Icon(Icons.notifications_off_outlined, color: E().otherPageTopBarButtonColor),
              onPressed: () async {
                AdaptiveComponents.showAlertDialog(
                  context,
                  title: "addBlocklistEntry".tr,
                  barrierDismissible: false,
                  onDismiss: (result) {
                    if (result == AlertResult.confirm) {
                      AdaptiveComponents.showLoading(context);
                      NForumService.addBlocklistEntry(widget.user.id).then((value) {
                        AdaptiveComponents.hideLoading();
                      }).catchError((e) {
                        AdaptiveComponents.hideLoading();
                      });
                    } else {}
                  },
                );
              },
            ),
          ],
        ),
        body: CustomScrollView(
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, index) {
                  return Column(
                    children: <Widget>[
                      Card(
                        elevation: 0.0,
                        margin: EdgeInsets.fromLTRB(20, 10, 20, 0),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                        color: E().userPageSecondaryBackgroundColor,
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Stack(
                                    children: [
                                      Container(
                                        height: 90,
                                        width: 90,
                                        alignment: Alignment(0, 0),
                                        child: ClickableAvatar(
                                          radius: 45,
                                          onTap: () {
                                            showGeneralDialog(
                                              barrierColor: Colors.black,
                                              barrierDismissible: false,
                                              transitionDuration: Duration(milliseconds: 200),
                                              barrierLabel: "PicDialog",
                                              pageBuilder: (c, _, __) => PicSwiper(
                                                index: 0,
                                                pics: [
                                                  PicSwiperItem(picUrl: NForumService.makeGetURL(widget.user.faceUrl))
                                                ],
                                              ),
                                              context: context,
                                            );
                                          },
                                          isWhisper: (widget.user?.id ?? "").startsWith("IWhisper"),
                                          imageLink: NForumService.makeGetURL(widget.user.faceUrl),
                                          emptyUser: !GetUtils.isURL(widget.user?.faceUrl),
                                        ),
                                      ),
                                      Positioned(
                                        right: 0,
                                        bottom: 10,
                                        child: Container(
                                          alignment: Alignment(0, 0),
                                          width: 20,
                                          height: 20,
                                          decoration: BoxDecoration(
                                            color: E().userPageSecondaryBackgroundColor,
                                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        right: 0,
                                        bottom: 10,
                                        child: Container(
                                          alignment: Alignment(0, 0),
                                          width: 20,
                                          height: 20,
                                          decoration: BoxDecoration(
                                            color: ConstColors.getUsernameColor(widget.user?.gender).withOpacity(0.3),
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(10.0),
                                            ),
                                            border: Border.all(
                                              width: 2,
                                              color: Colors.transparent,
                                            ),
                                          ),
                                          child: Icon(
                                            widget.user.gender == 'm'
                                                ? FontAwesomeIcons.mars
                                                : widget.user.gender == 'f'
                                                    ? FontAwesomeIcons.venus
                                                    : FontAwesomeIcons.genderless,
                                            color: ConstColors.getUsernameColor(widget.user?.gender),
                                            size: 15,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Flexible(
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 10, top: 5),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            widget.user?.id ?? "",
                                            style: TextStyle(
                                              fontSize: 22.0,
                                              color: ConstColors.getUsernameColor(widget.user?.gender),
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(top: 5),
                                            child: Text(
                                              widget.user?.userName ?? "",
                                              style: TextStyle(
                                                fontSize: 16.0,
                                                color: E().userPageTextColor,
                                              ),
                                              // maxLines: 1,
                                              // overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(top: 5),
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.pushNamed(
                                                  context,
                                                  'send_mail_page',
                                                  arguments: SendMailPageRouteArg(
                                                    mail: null,
                                                    username: widget.user.id,
                                                    isReply: false,
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                alignment: Alignment(0, 0),
                                                width: 30,
                                                height: 30,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey,
                                                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                                ),
                                                child: Icon(
                                                  FontAwesomeIcons.solidComment,
                                                  color: E().userPageButtonFillColor,
                                                  size: 15,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Divider(
                              height: 1,
                              color: E().userPageSecondaryBackgroundColor,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  _cardInfoCell("profileLife".tr, widget.user.life.toString()),
                                  _cardInfoCell("profilePostCount".tr, widget.user.postCount.toString()),
                                  _cardInfoCell("profileScore".tr, widget.user.score.toString()),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 20,
                      ),
                      Divider(
                        height: 1,
                        color: E().userPageSecondaryBackgroundColor,
                      ),
                      _detailCell("profileLevel".tr, widget.user.level),
                      _detailCell("profileState".tr, widget.user.isOnline ? "profileOnline".tr : "profileOffline".tr),
                      _detailCell(
                        "profileStarSign".tr,
                        widget.user.astro == '' ? '--' : widget.user.astro,
                      ),
                      _detailCell(
                        "profileHomePage".tr,
                        widget.user.homePage == '' ? '--' : widget.user.homePage,
                      ),
                      _detailCell(
                        "profileQQ".tr,
                        widget.user.qq == '' ? '--' : widget.user.qq,
                      ),
                    ],
                  );
                },
                childCount: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
