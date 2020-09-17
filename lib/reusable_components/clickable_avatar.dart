import 'package:byr_mobile_app/customizations/theme_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ClickableAvatar extends StatelessWidget {
  final double radius;
  final bool emptyUser;
  final String imageLink;
  final onTap;
  const ClickableAvatar({
    Key key,
    @required this.radius,
    @required this.emptyUser,
    this.imageLink,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget placeHolder = Container(
      alignment: Alignment.center,
      child: Icon(
        FontAwesomeIcons.solidUserCircle,
        color: Colors.grey.withOpacity(0.5),
        size: radius * 2,
      ),
      decoration: BoxDecoration(color: Colors.transparent, shape: BoxShape.circle),
    );
    Widget avatar = emptyUser
        ? placeHolder
        : CachedNetworkImage(
            alignment: Alignment.center,
            color: E().userPageSecondaryBackgroundColor,
            imageUrl: imageLink,
            imageBuilder: (context, imageProvider) => CircleAvatar(
              backgroundColor: E().userPageSecondaryBackgroundColor,
              radius: radius,
              backgroundImage: imageProvider,
            ),
            placeholder: (context, url) => placeHolder,
            errorWidget: (context, url, error) => placeHolder,
          );
    if (onTap != null) {
      return GestureDetector(
        child: avatar,
        onTap: this.onTap,
      );
    } else {
      return avatar;
    }
  }
}
