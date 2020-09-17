import 'package:byr_mobile_app/customizations/theme_controller.dart';
import 'package:byr_mobile_app/nforum/nforum_service.dart';
import 'package:byr_mobile_app/nforum/nforum_structures.dart';
import 'package:byr_mobile_app/nforum/nforum_text_parser.dart';
import 'package:byr_mobile_app/reusable_components/adaptive_components.dart';
import 'package:byr_mobile_app/reusable_components/byr_app_bar.dart';
import 'package:byr_mobile_app/reusable_components/controller_insert_text.dart';
import 'package:byr_mobile_app/reusable_components/emoticon_panel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class SendMailPageRouteArg {
  final MailModel mail;
  final String username;
  final bool isReply;

  SendMailPageRouteArg({this.mail, this.username, this.isReply = true});
}

class SendMailPage extends StatefulWidget {
  final SendMailPageRouteArg arg;

  SendMailPage(this.arg);
  @override
  SendMailPageState createState() => SendMailPageState();
}

class SendMailPageState extends State<SendMailPage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => false;

  MailModel _mail;
  String _username = "";
  String _title = "";
  String _content = "";

  TextEditingController _userController = new TextEditingController();
  TextEditingController _titleController = new TextEditingController();
  TextEditingController _contentController = new TextEditingController();
  GlobalKey _formKey = new GlobalKey<FormState>();

  EmoticonPanel _emoticonPanel;
  TextSelection _textSelection;

  @override
  void initState() {
    super.initState();
    if (widget.arg.mail != null) {
      _mail = widget.arg.mail;
      _username = _mail.user.id;
      _title = 'Re:' + _mail.title;
      _content = NForumTextParser.makeReplyQuote(_username, _mail.content);
    } else if (widget.arg.username != null) {
      _username = widget.arg.username;
    }
    _userController.text = _username;
    _titleController.text = _title;
    _contentController.text = _content;
    _contentController.selection = TextSelection(baseOffset: 0, extentOffset: 0);
    _emoticonPanel = EmoticonPanel(
      config: EmoticonPanelConfig(
        {
          'backgroundColor': E().otherPagePrimaryColor,
          'unselectedBackgroundColor': E().emoticonPanelTopBarTitleUnselectedBackgroundColor,
          'selectedBackgroundColor': E().emoticonPanelTopBarTitleSelectedBackgroundColor,
          'tabTextColor': E().emoticonPanelTopBarTitleSelectedTextColor,
        },
        {
          'classicsTabTrans': "emoticonTransClassicsTabTrans".tr,
          'yoyociciTabTrans': "emoticonTransYoyociciTabTrans".tr,
          'tuzkiTabTrans': "emoticonTransTuzkiTabTrans".tr,
          'oniontouTabTrans': "emoticonTransOniontouTabTrans".tr,
        },
      ),
      onEmoticonTap: (String emoticon) {
        _textSelection = controllerInsertText(
          controller: _contentController,
          insertText: emoticon,
          currentSelection: _textSelection,
        );
      },
    );
  }

  @override
  void dispose() {
    _userController.dispose();
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _send(context) async {
    if ((_formKey.currentState as FormState).validate()) {
      AdaptiveComponents.showLoading(
        context,
        content: "sendingTrans".tr,
      );
      StatusModel tt = await NForumService.sendMail(
        _userController.text,
        _titleController.text,
        NForumTextParser.stripEmojis(_contentController.text),
      );
      AdaptiveComponents.hideLoading();
      AdaptiveComponents.showToast(
        context,
        tt.status ? "sendSuccessTrans".tr : "sendFailedTrans".tr,
      );
      Navigator.of(context).pop();
    }
  }

  Widget _buildContent(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Form(
        key: _formKey,
        autovalidate: true,
        child: Column(
          children: <Widget>[
            TextFormField(
              autocorrect: false,
              style: TextStyle(
                color: E().threadPageContentColor,
              ),
              readOnly: _username != null,
              controller: _userController,
              decoration: InputDecoration(
                labelText: "receiverTrans".tr,
                hintText: "loginUsernameTrans".tr,
                labelStyle: TextStyle(
                  color: E().editPagePlaceholderColor,
                ),
                icon: Icon(
                  Icons.person,
                  color: E().editPagePlaceholderColor,
                ),
              ),
              validator: (v) {
                return v.trim().length > 0 ? null : "receiverTrans".tr + "nonBlankTrans".tr;
              },
            ),
            TextFormField(
              style: TextStyle(
                color: E().threadPageContentColor,
              ),
              controller: _titleController,
              autocorrect: false,
              decoration: InputDecoration(
                labelText: "titleTrans".tr,
                hintText: "smsTrans".tr + "titleTrans".tr,
                labelStyle: TextStyle(
                  color: E().editPagePlaceholderColor,
                ),
                icon: Icon(
                  Icons.title,
                  color: E().editPagePlaceholderColor,
                ),
              ),
              validator: (v) {
                return v.trim().length > 0 ? null : "titleTrans".tr + "nonBlankTrans".tr;
              },
            ),
            Expanded(
              child: TextFormField(
                style: TextStyle(
                  color: E().threadPageContentColor,
                ),
                autofocus: true,
                autocorrect: false,
                controller: _contentController,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  labelText: "contentTrans".tr,
                  labelStyle: TextStyle(
                    color: E().editPagePlaceholderColor,
                  ),
                  border: OutlineInputBorder(),
                  hintText: "smsTrans".tr + "contentTrans".tr,
                ),
                validator: (v) {
                  return v.trim().length > 0 ? null : "contentTrans".tr + "nonBlankTrans".tr;
                },
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
              icon: Icon(
                Icons.send,
                color: E().editPageTopBarButtonColor,
              ),
              onPressed: () {
                _send(context);
              },
              label: Text(
                widget.arg.isReply ? "replyTrans".tr : "sendTrans".tr,
                style: TextStyle(fontSize: 17, color: E().topBarTitleNormalColor),
              ),
            ),
          ],
        ),
        backgroundColor: E().editPageBackgroundColor,
        body: _buildContent(context),
        floatingActionButton: FloatingActionButton(
          child: Icon(
            FontAwesomeIcons.smile,
          ),
          onPressed: () {
            _textSelection = _contentController.selection;
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return _emoticonPanel;
              },
            ).whenComplete(
              () {
                _contentController.selection = _textSelection;
              },
            );
          },
        ),
      ),
    );
  }
}
