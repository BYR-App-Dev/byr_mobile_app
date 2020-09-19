import 'package:byr_mobile_app/customizations/const_colors.dart';
import 'package:byr_mobile_app/helper/helper.dart';
import 'package:byr_mobile_app/nforum/nforum_service.dart';
import 'package:byr_mobile_app/nforum/nforum_structures.dart';
import 'package:byr_mobile_app/reusable_components/clickable_avatar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum CellStyle {
  text,
  half,
  image,
  allAtt,
}

int calMaxLines(
  String text,
  TextStyle textStyle,
  int maxLines,
  double width,
  double height,
) {
  for (int i = maxLines; i > 0; i--) {
    TextPainter _textPainter =
        TextPainter(maxLines: i, text: TextSpan(text: text, style: textStyle), textDirection: TextDirection.ltr)
          ..layout(maxWidth: width);
    if (_textPainter.size.height > height) {
      continue;
    } else {
      return i;
    }
  }
  return maxLines;
}

bool isExceed(
  String text,
  TextStyle style,
  double contextWidth,
  int maxLines,
) {
  TextPainter _textPainter =
      TextPainter(maxLines: maxLines, text: TextSpan(text: text, style: style), textDirection: TextDirection.ltr)
        ..layout(maxWidth: contextWidth);
  if (_textPainter.didExceedMaxLines) {
    return true;
  } else {
    return false;
  }
}

class ArticleCell extends StatelessWidget {
  final String title;
  final String content;
  final TextStyle titleStyle;
  final TextStyle contentStyle;
  final List<String> imageUrls;
  final bool emptyCell;
  ArticleCell({
    @required this.title,
    @required this.content,
    @required this.titleStyle,
    @required this.contentStyle,
    @required this.iconColor,
    @required this.contentColor,
    this.imageUrls,
    this.emptyCell = false,
  });

  final Color iconColor;
  final Color contentColor;

  double _imageWidth = 70.0;
  double _imageWHRadio = 1.36;
  double _imageHeight = 25.0;
  double _mainSpacing = 5.0;
  int _itemCount = 3;
  int _maxLines = 3;

  Widget _buildImageCell(String imageUrl, {int remainCount = 0}) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(5.0)),
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          imageUrl == null || imageUrl.length <= 0
              ? Icon(
                  Icons.attachment,
                  color: iconColor,
                )
              : CachedNetworkImage(
                  imageUrl: NForumService.makeGetAttachmentURL(imageUrl),
                  fit: BoxFit.cover,
                ),
          if (remainCount != 0)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              top: 0,
              child: Container(
                color: Colors.black.withAlpha(100),
                child: Center(
                  child: Text(
                    '+ $remainCount',
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTextStyle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          title,
          style: titleStyle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        if (content != '')
          Container(
            margin: EdgeInsets.only(top: _mainSpacing),
            child: Text(
              content,
              style: contentStyle,
              maxLines: _maxLines,
              overflow: TextOverflow.ellipsis,
            ),
          ),
      ],
    );
  }

  Widget _buildHalfStyle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          title,
          style: titleStyle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        Container(
          margin: EdgeInsets.only(top: _mainSpacing),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Text(
                  content,
                  style: contentStyle,
                  maxLines: _maxLines,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                width: _imageWidth,
                height: _imageHeight,
                margin: EdgeInsets.only(left: _mainSpacing),
                child: _buildImageCell(
                  imageUrls[0],
                  remainCount: imageUrls.length - 1,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildImageStyle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _buildTextStyle(),
        Container(
          margin: EdgeInsets.only(top: _mainSpacing),
          child: GridView.builder(
            padding: EdgeInsets.all(0.0),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: imageUrls.length.clamp(1, 3),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: imageUrls.length < _itemCount ? _itemCount - 1 : _itemCount,
              crossAxisSpacing: _mainSpacing,
              mainAxisSpacing: 0,
              childAspectRatio: _imageWHRadio,
            ),
            itemBuilder: (BuildContext context, int index) {
              if (index == 2) {
                return _buildImageCell(imageUrls[index], remainCount: imageUrls.length - 3);
              } else {
                return _buildImageCell(imageUrls[index]);
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAttStyle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          title,
          style: titleStyle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        Container(
          margin: EdgeInsets.only(top: _mainSpacing),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Text(
                  content,
                  style: contentStyle,
                  maxLines: _maxLines,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                width: _imageWidth,
                height: _imageHeight,
                margin: EdgeInsets.only(left: _mainSpacing),
                child: _buildImageCell(
                  imageUrls[0],
                  remainCount: imageUrls.length - 1,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyView() {
    double titleHeight = 20.0;
    double contentHeight = 15.0;
    double imageHeight = 3 * contentHeight + 2 * _mainSpacing;
    double imageWidth = imageHeight * _imageWHRadio;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          child: Container(
            height: titleHeight,
            color: Colors.white,
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: _mainSpacing * 2),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(bottom: _mainSpacing),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        child: Container(
                          height: contentHeight,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: _mainSpacing),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        child: Container(
                          height: contentHeight,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      child: Container(
                        height: contentHeight,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: _mainSpacing),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  child: Container(
                    height: imageHeight,
                    width: imageWidth,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (emptyCell) {
          _imageWidth = (constraints.maxWidth - (_itemCount - 1) * _mainSpacing) / _itemCount;
          _imageHeight = _imageWidth / _imageWHRadio;
          return _buildEmptyView();
        } else {
          CellStyle cellStyle;
          if (imageUrls == null || imageUrls.isEmpty) {
            cellStyle = CellStyle.text;
          } else if (imageUrls.length < 3 && isExceed(content, contentStyle, constraints.maxWidth, 1)) {
            cellStyle = CellStyle.half;
          } else if (imageUrls.fold<bool>(false, (r, e) {
                return (e != null && e != "") || r;
              }) ==
              false) {
            cellStyle = CellStyle.allAtt;
          } else {
            cellStyle = CellStyle.image;
          }

          if (cellStyle == CellStyle.half) {
            _imageWidth = (constraints.maxWidth - (_itemCount - 1) * _mainSpacing) / _itemCount;
            _imageHeight = _imageWidth / _imageWHRadio;
            double contentWidth = constraints.maxWidth - _mainSpacing - _imageWidth;
            _maxLines = calMaxLines(content, contentStyle, 10, contentWidth, _imageHeight);
          }
          switch (cellStyle) {
            case CellStyle.text:
              return _buildTextStyle();
            case CellStyle.half:
              return _buildHalfStyle();
            case CellStyle.image:
              return _buildImageStyle();
            case CellStyle.allAtt:
              return _buildAttStyle();
          }
        }

        return Container();
      },
    );
  }
}

class PostInfoView extends StatelessWidget {
  final UserModel user;
  final int postTime;
  final bool emptyView;
  final Color contentColor;

  PostInfoView({
    @required this.user,
    @required this.postTime,
    @required this.contentColor,
    this.emptyView = false,
  });

  Widget _buildEmptyView() {
    return Row(
      children: <Widget>[
        ClipOval(
          child: Container(
            height: 36,
            width: 36,
            color: Colors.white,
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                child: Container(
                  height: 15,
                  width: 100,
                  color: Colors.white,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 5.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  child: Container(
                    height: 13,
                    width: 70,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (emptyView) return _buildEmptyView();
    return Row(
      children: <Widget>[
        ClickableAvatar(
          radius: 18,
          isWhisper: (user?.id ?? "").startsWith("IWhisper"),
          imageLink: NForumService.makeGetURL(user?.faceUrl ?? ""),
          emptyUser: !GetUtils.isURL(user?.faceUrl),
          onTap: !GetUtils.isURL(user?.faceUrl)
              ? null
              : () {
                  navigator.pushNamed("profile_page", arguments: user);
                },
        ),
        Container(
          margin: EdgeInsets.only(left: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                user.id,
                style: TextStyle(
                  fontSize: 17.0,
                  color: ConstColors.getUsernameColor(user?.gender),
                ),
              ),
              Text(
                Helper.convTimestampToRelative(postTime),
                style: TextStyle(
                  fontSize: 12.0,
                  color: contentColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
