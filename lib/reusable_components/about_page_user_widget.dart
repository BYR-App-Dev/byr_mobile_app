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
      color: Colors.grey,
      fontSize: 14,
    );
    return LayoutBuilder(
      builder: (context, constraint) {
        double size = constraint.maxWidth * 0.70;
        return Column(
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
                      onTap: () {
                        navigator.pushNamed("profile_page", arguments: _userModel);
                      },
                    ),
                  ),
            Padding(
              padding: EdgeInsets.only(
                top: 5,
              ),
              child: Text(
                widget.id,
                style: textStyle,
              ),
            ),
          ],
        );
      },
    );
  }
}
