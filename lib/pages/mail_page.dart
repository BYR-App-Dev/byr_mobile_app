import 'package:byr_mobile_app/customizations/const_colors.dart';
import 'package:byr_mobile_app/customizations/theme_controller.dart';
import 'package:byr_mobile_app/helper/helper.dart';
import 'package:byr_mobile_app/nforum/nforum_service.dart';
import 'package:byr_mobile_app/nforum/nforum_structures.dart';
import 'package:byr_mobile_app/pages/pages.dart';
import 'package:byr_mobile_app/reusable_components/byr_app_bar.dart';
import 'package:byr_mobile_app/reusable_components/clickable_avatar.dart';
import 'package:byr_mobile_app/reusable_components/parsed_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MailPageRouteArg {
  final int index;

  MailPageRouteArg(this.index);
}

class MailPage extends StatefulWidget {
  final MailPageRouteArg arg;

  MailPage(this.arg);
  @override
  MailPageState createState() => MailPageState();
}

class MailPageState extends State<MailPage> with AutomaticKeepAliveClientMixin {
  bool _loading;
  MailModel _mailObject;

  @override
  bool get wantKeepAlive => false;

  @override
  void initState() {
    super.initState();
    _loading = true;
    NForumService.getMail(widget.arg.index).then(
      (mail) {
        _loading = false;
        _mailObject = mail;
        if (mounted) {
          setState(() {});
        }
      },
    );
  }

  Widget _buildContent(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(16, 15, 16, 15),
              child: Row(
                children: <Widget>[
                  ClickableAvatar(
                    radius: 20,
                    imageLink: NForumService.makeGetURL(_mailObject.user?.faceUrl ?? ""),
                    isWhisper: (_mailObject.user?.id ?? "").startsWith("IWhisper"),
                    emptyUser: _mailObject.user?.faceUrl == null,
                    onTap: () {
                      navigator.pushNamed(
                        "profile_page",
                        arguments: _mailObject.user,
                      );
                    },
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          _mailObject.user.id,
                          style: TextStyle(
                            fontSize: 16.5,
                            color: ConstColors.getUsernameColor(_mailObject.user?.gender),
                          ),
                        ),
                        Container(
                          height: 3,
                        ),
                        Text(
                          Helper.convTimestampToRelative(_mailObject.postTime),
                          style: TextStyle(
                            fontSize: 14.0,
                            color: E().notificationListTileOtherTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              indent: 16,
              color: E().otherPageDividerColor,
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(
                      bottom: 10,
                    ),
                    child: Text(
                      _mailObject.title,
                      style: TextStyle(
                        fontSize: 18.0,
                        color: E().notificationListTileTitleColor,
                      ),
                    ),
                  ),
                  ParsedText.uploaded(
                    text: _mailObject.content.trim().replaceAll(RegExp(r'\n+--\n*$'), '\n'),
                    uploads: _mailObject.attachment.file,
                    title: _mailObject.title,
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
  Widget build(BuildContext context) {
    super.build(context);
    return Obx(
      () => Scaffold(
        appBar: BYRAppBar(
          title: Text(
            "smsTrans".tr,
          ),
          actions: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.mail, color: E().editPageTopBarButtonColor),
              onPressed: () {
                Navigator.pushNamed(context, 'send_mail_page', arguments: SendMailPageRouteArg(mail: _mailObject));
              },
              label: Text("replyTrans".tr, style: TextStyle(fontSize: 17, color: E().topBarTitleNormalColor)),
            ),
          ],
        ),
        backgroundColor: E().editPageBackgroundColor,
        body: _loading
            ? Center(
                child: CircularProgressIndicator(
                backgroundColor: E().editPageBackgroundColor,
                valueColor: AlwaysStoppedAnimation<Color>(
                  E().editPageTopBarButtonColor,
                ),
              ))
            : _buildContent(context),
      ),
    );
  }
}
