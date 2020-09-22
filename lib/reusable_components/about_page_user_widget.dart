import 'package:byr_mobile_app/customizations/const_colors.dart';
import 'package:byr_mobile_app/customizations/theme_controller.dart';
import 'package:byr_mobile_app/nforum/nforum_service.dart';
import 'package:byr_mobile_app/nforum/nforum_structures.dart';
import 'package:byr_mobile_app/pages/pages.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'clickable_avatar.dart';

class AboutPageUserWidget extends StatefulWidget {
  AboutPageUserWidget({this.id, this.description = ''}) : assert(id != null);

  final String id;
  final String description;
  @override
  _AboutPageUserWidgetState createState() => _AboutPageUserWidgetState();
}

class _AboutPageUserWidgetState extends State<AboutPageUserWidget> {
  bool _isLoading = true;
  UserModel _userModel;

  @override
  void initState() {
    NForumService.getUserInfo(widget.id).then((user) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _userModel = user;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = TextStyle(
      color: E().otherPagePrimaryTextColor,
      fontSize: 16,
    );
    double size = 40;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (_userModel != null) {
          navigator.pushNamed("profile_page", arguments: _userModel);
        }
      },
      child: Container(
        height: 40.0,
        child: Row(
          children: <Widget>[
            _isLoading
                ? Icon(
                    FontAwesomeIcons.solidUserCircle,
                    color: Colors.grey.withOpacity(0.5),
                    size: size,
                  )
                : Container(
                    height: size,
                    width: size,
                    alignment: Alignment(0, 0),
                    child: ClickableAvatar(
                      radius: size / 2,
                      isWhisper: (_userModel?.id ?? "").startsWith("IWhisper"),
                      imageLink: NForumService.makeGetURL(_userModel.faceUrl),
                      emptyUser: !GetUtils.isURL(_userModel?.faceUrl),
                    ),
                  ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  left: 10,
                ),
                child: Text(
                  widget.id,
                  style: textStyle.copyWith(
                    color: ConstColors.getUsernameColor(_userModel?.gender),
                  ),
                ),
              ),
            ),
            if (widget.description.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(
                  left: 5,
                  right: 15,
                ),
                child: Text(
                  widget.description,
                  style: textStyle.copyWith(color: E().otherPageSecondaryTextColor),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
