import 'package:byr_mobile_app/customizations/const_colors.dart';
import 'package:byr_mobile_app/customizations/theme_controller.dart';
import 'package:byr_mobile_app/nforum/nforum_service.dart';
import 'package:byr_mobile_app/nforum/nforum_structures.dart';
import 'package:byr_mobile_app/pages/pages.dart';
import 'package:byr_mobile_app/reusable_components/byr_app_bar.dart';
import 'package:byr_mobile_app/reusable_components/clickable_avatar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class ProfilePage extends StatelessWidget {
  final UserModel user;

  const ProfilePage({Key key, this.user}) : super(key: key);

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
    return Obx(
      () => Scaffold(
        backgroundColor: E().userPagePrimaryBackgroundColor,
        appBar: BYRAppBar(
          title: Text(
            "profilePageName".tr,
          ),
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
                                          onTap: null,
                                          isWhisper: (user?.id ?? "").startsWith("IWhisper"),
                                          imageLink: NForumService.makeGetURL(user.faceUrl),
                                          emptyUser: !GetUtils.isURL(user?.faceUrl),
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
                                            color: ConstColors.getUsernameColor(user?.gender).withOpacity(0.3),
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(10.0),
                                            ),
                                            border: Border.all(
                                              width: 2,
                                              color: Colors.transparent,
                                            ),
                                          ),
                                          child: Icon(
                                            user.gender == 'm'
                                                ? FontAwesomeIcons.mars
                                                : user.gender == 'f'
                                                    ? FontAwesomeIcons.venus
                                                    : FontAwesomeIcons.genderless,
                                            color: ConstColors.getUsernameColor(user?.gender),
                                            size: 15,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 10, top: 5),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          user?.id ?? "",
                                          style: TextStyle(
                                            fontSize: 22.0,
                                            color: ConstColors.getUsernameColor(user?.gender),
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 5),
                                          child: Text(
                                            user?.userName ?? "",
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              color: E().userPageTextColor,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
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
                                                  username: user.id,
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
                                  _cardInfoCell("profileLife".tr, user.life.toString()),
                                  _cardInfoCell("profilePostCount".tr, user.postCount.toString()),
                                  _cardInfoCell("profileScore".tr, user.score.toString()),
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
                      _detailCell("profileLevel".tr, user.level),
                      _detailCell("profileState".tr, user.isOnline ? "profileOnline".tr : "profileOffline".tr),
                      _detailCell(
                        "profileStarSign".tr,
                        user.astro == '' ? '--' : user.astro,
                      ),
                      _detailCell(
                        "profileHomePage".tr,
                        user.homePage == '' ? '--' : user.homePage,
                      ),
                      _detailCell(
                        "profileQQ".tr,
                        user.qq == '' ? '--' : user.qq,
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
