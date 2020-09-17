import 'package:byr_mobile_app/customizations/board_info.dart';
import 'package:byr_mobile_app/customizations/theme_controller.dart';
import 'package:byr_mobile_app/helper/helper.dart';
import 'package:byr_mobile_app/nforum/nforum_service.dart';
import 'package:byr_mobile_app/nforum/nforum_structures.dart';
import 'package:byr_mobile_app/nforum/nforum_text_parser.dart';
import 'package:byr_mobile_app/pages/pages.dart';
import 'package:byr_mobile_app/reusable_components/clickable_avatar.dart';
import 'package:byr_mobile_app/reusable_components/parsed_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThreadPageListCellArticleLayouter extends ThreadPageListCellDataLayouter<ThreadArticleModel> {
  @override
  Color getHighlightColor(ThreadArticleModel d) {
    return E().threadPageBackgroundColor.withOpacity(0.12);
  }

  @override
  bool getIsVotedownNumberShow(ThreadArticleModel d) {
    return true;
  }

  @override
  Color getSplashColor(ThreadArticleModel d) {
    return BoardInfo.getBoardIconColor(d.boardName).withOpacity(0.12);
  }

  @override
  Color getTimeColor(ThreadArticleModel d) {
    return E().threadPageOtherTextColor;
  }

  @override
  Color getPositionColor(ThreadArticleModel d) {
    return E().threadPageOtherTextColor;
  }

  @override
  String getTitle(ThreadArticleModel d) {
    return d.title;
  }

  @override
  String getContent(ThreadArticleModel d) {
    return d.content.trim().replaceAll(RegExp(r'\n+--\n*$'), '\n');
  }

  @override
  String getTimeText(ThreadArticleModel d) {
    if (d.boardName == 'Constellations' && d.groupId == 326533) {
      return Helper.convTimestampToRelativeIncludingSeconds(d.postTime);
    } else {
      return Helper.convTimestampToRelative(d.postTime);
    }
  }

  @override
  bool getIsLiked(ThreadArticleModel d) {
    return d.isLiked;
  }

  @override
  void setIsLiked(ThreadArticleModel d, bool afterValue) {
    d.isLiked = afterValue;
  }

  @override
  int getLikes(ThreadArticleModel d) {
    return int.tryParse(d.likeSum) ?? 0;
  }

  @override
  void setLikes(ThreadArticleModel d, int afterValue) {
    d.likeSum = afterValue.toString();
  }

  @override
  bool getIsVotedown(ThreadArticleModel d) {
    return d.isVotedown;
  }

  @override
  void setIsVotedown(ThreadArticleModel d, bool afterValue) {
    d.isVotedown = afterValue;
  }

  @override
  int getVotedowns(ThreadArticleModel d) {
    return int.tryParse(d.votedownSum) ?? 0;
  }

  @override
  void setVotedowns(ThreadArticleModel d, int afterValue) {
    d.votedownSum = afterValue.toString();
  }

  @override
  bool getIsHiddenByVotedown(ThreadArticleModel d) {
    return d.hiddenByVotedown;
  }

  @override
  void setIsHiddenByVotedown(ThreadArticleModel d, bool afterValue) {
    d.hiddenByVotedown = afterValue;
  }

  @override
  String getUsername(ThreadArticleModel d) {
    return d.user?.id ?? '';
  }

  @override
  Color getUsernameColor(ThreadArticleModel d) {
    return d.user?.gender == null
        ? E().otherUserIdColor
        : (d.user.gender == 'f'
            ? E().femaleUserIdColor
            : (d.user.gender == 'm' ? E().maleUserIdColor : E().otherUserIdColor));
  }

  @override
  String getPositionName(ThreadArticleModel d) {
    return NForumTextParser.getArticlePositionName(d.position);
  }

  @override
  bool getIsUserEmpty(ThreadArticleModel d) {
    if (d.user?.faceUrl == null) {
      return true;
    } else {
      return false;
    }
  }

  @override
  String getUserImageLink(ThreadArticleModel d) {
    if (d.user?.faceUrl != null) {
      return NForumService.makeBBSURL(d.user.faceUrl);
    } else {
      return NForumSpecs.byrFaceM;
    }
  }

  @override
  List getAttachmentFiles(ThreadArticleModel d) {
    return d.attachment.file;
  }

  @override
  void like(ThreadArticleModel d) {}

  @override
  void votedown(ThreadArticleModel d) {}

  @override
  UserModel getUser(ThreadArticleModel d) {
    return d.user;
  }

  @override
  String getBoardDescription(ThreadArticleModel d) {
    return d.boardDescription;
  }

  @override
  String getBoardName(ThreadArticleModel d) {
    return d.boardName;
  }
}

class ThreadPageListCellLikeArticleLayouter extends ThreadPageListCellDataLayouter<LikeArticleModel> {
  @override
  Color getHighlightColor(LikeArticleModel d) {
    return E().threadPageBackgroundColor.withOpacity(0.12);
  }

  @override
  Color getSplashColor(LikeArticleModel d) {
    return BoardInfo.getBoardIconColor(d.boardName).withOpacity(0.12);
  }

  @override
  Color getTimeColor(LikeArticleModel d) {
    return E().threadPageOtherTextColor;
  }

  @override
  Color getPositionColor(LikeArticleModel d) {
    return E().threadPageOtherTextColor;
  }

  @override
  String getTitle(LikeArticleModel d) {
    return d.title;
  }

  @override
  String getContent(LikeArticleModel d) {
    return d.content.trim().replaceAll(RegExp(r'\n+--\n*$'), '\n');
  }

  @override
  String getTimeText(LikeArticleModel d) {
    if (d.boardName == 'Constellations' && d.groupId == 326533) {
      return Helper.convTimestampToRelativeIncludingSeconds(d.postTime);
    } else {
      return Helper.convTimestampToRelative(d.postTime);
    }
  }

  @override
  bool getIsLiked(LikeArticleModel d) {
    return d.isLiked;
  }

  @override
  void setIsLiked(LikeArticleModel d, bool afterValue) {
    d.isLiked = afterValue;
  }

  @override
  int getLikes(LikeArticleModel d) {
    return int.tryParse(d.likeSum) ?? 0;
  }

  @override
  void setLikes(LikeArticleModel d, int afterValue) {
    d.likeSum = afterValue.toString();
  }

  @override
  bool getIsVotedown(LikeArticleModel d) {
    return d.isVotedown != null && d.isVotedown;
  }

  @override
  void setIsVotedown(LikeArticleModel d, bool afterValue) {
    d.isVotedown = afterValue;
  }

  @override
  bool getIsVotedownNumberShow(LikeArticleModel d) {
    return false;
  }

  @override
  int getVotedowns(LikeArticleModel d) {
    return 0;
  }

  @override
  void setVotedowns(LikeArticleModel d, int afterValue) {}

  @override
  bool getIsHiddenByVotedown(LikeArticleModel d) {
    return false;
  }

  @override
  void setIsHiddenByVotedown(LikeArticleModel d, bool afterValue) {}

  @override
  String getUsername(LikeArticleModel d) {
    return d.user?.id ?? '';
  }

  @override
  Color getUsernameColor(LikeArticleModel d) {
    return d.user?.gender == null
        ? E().otherUserIdColor
        : (d.user.gender == 'f'
            ? E().femaleUserIdColor
            : (d.user.gender == 'm' ? E().maleUserIdColor : E().otherUserIdColor));
  }

  @override
  String getPositionName(LikeArticleModel d) {
    return NForumTextParser.getArticlePositionName(d.position);
  }

  @override
  bool getIsUserEmpty(LikeArticleModel d) {
    if (d.user?.faceUrl == null) {
      return true;
    } else {
      return false;
    }
  }

  @override
  String getUserImageLink(LikeArticleModel d) {
    if (d.user?.faceUrl != null) {
      return NForumService.makeBBSURL(d.user.faceUrl);
    } else {
      return NForumSpecs.byrFaceM;
    }
  }

  @override
  List getAttachmentFiles(LikeArticleModel d) {
    return d.attachment.file;
  }

  @override
  void like(LikeArticleModel d) {}

  @override
  void votedown(LikeArticleModel d) {}

  UserModel getUser(LikeArticleModel d) {
    return d.user;
  }

  @override
  String getBoardDescription(LikeArticleModel d) {
    return d.boardDescription;
  }

  @override
  String getBoardName(LikeArticleModel d) {
    return d.boardName;
  }
}

abstract class ThreadPageListCellDataLayouter<T> {
  Color getHighlightColor(T d);
  Color getSplashColor(T d);
  Color getTimeColor(T d);
  Color getPositionColor(T d);

  String getTitle(T d);
  String getContent(T d);
  String getBoardName(T d);
  String getBoardDescription(T d);
  String getTimeText(T d);
  bool getIsLiked(T d);
  void setIsLiked(T d, bool afterValue);
  int getLikes(T d);
  void setLikes(T d, int afterValue);
  bool getIsVotedown(T d);
  void setIsVotedown(T d, bool afterValue);
  int getVotedowns(T d);
  bool getIsVotedownNumberShow(T d);
  void setVotedowns(T d, int afterValue);
  bool getIsHiddenByVotedown(T d);
  void setIsHiddenByVotedown(T d, bool afterValue);
  String getUsername(T d);
  Color getUsernameColor(T d);
  bool getIsUserEmpty(T d);
  String getUserImageLink(T d);
  String getPositionName(T d);
  List getAttachmentFiles(T d);
  UserModel getUser(T d);
  void like(T d);
  void votedown(T d);
}

class ThreadPageListCell<T> extends StatefulWidget {
  final T data;
  final ThreadPageListCellDataLayouter<T> dataLayouter;

  final String title;
  final String boardName;
  final Function onLongPress;
  final Function onTap;
  final Function likeit;
  final Function votedownit;
  final Function onOnlyAuthor;
  final bool isSubject;
  final String authorShown;
  final String threadAuthor;

  ThreadPageListCell(
    this.data,
    this.dataLayouter,
    this.title,
    this.boardName,
    this.onLongPress,
    this.onTap,
    this.likeit,
    this.votedownit,
    this.onOnlyAuthor, {
    this.isSubject = false,
    this.authorShown = '',
    this.threadAuthor = "",
  });

  @override
  ThreadPageListCellState createState() {
    return ThreadPageListCellState();
  }
}

class ThreadPageListSubjectCell<T> extends ThreadPageListCell<T> {
  ThreadPageListSubjectCell(
    data,
    ThreadPageListCellDataLayouter dataLayouter,
    String title,
    String boardName,
    Function onLongPress,
    Function onTap,
    Function likeit,
    Function votedownit,
    Function onOnlyAuthor, {
    isSubject = false,
    authorShown = '',
    String threadAuthor = "",
  }) : super(
          data,
          dataLayouter,
          title,
          boardName,
          onLongPress,
          onTap,
          likeit,
          votedownit,
          onOnlyAuthor,
          isSubject: isSubject,
          authorShown: authorShown,
          threadAuthor: threadAuthor,
        );
  @override
  ThreadPageSubjectCellState createState() {
    return ThreadPageSubjectCellState();
  }
}

class ThreadPageSubjectCellState extends ThreadPageListCellState {
  Widget _buildBoardName(String name, String desc) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, 'board_page', arguments: BoardPageRouteArg(name));
            },
            child: Container(
              padding: EdgeInsets.only(left: 2, top: 2, bottom: 2),
              decoration: BoxDecoration(
                color: E().threadPageBackgroundColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(1.0),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                    radius: 10,
                    backgroundColor: BoardInfo.getBoardIconColor(name),
                    child: Text(
                      BoardInfo.getBoardCnShort(name, desc),
                      style: TextStyle(
                        fontSize: 12,
                        color: E().threadPageBackgroundColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Text(
                      desc + ' >',
                      style: TextStyle(
                        fontSize: 15,
                        color: E().isThemeDarkStyle ? Colors.white : Colors.blue,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget buildTopRightCorner(ThreadPageListCellDataLayouter l, dynamic d) {
    return _buildBoardName(
      l.getBoardName(d),
      l.getBoardDescription(d),
    );
  }
}

class ThreadPageListCellState extends State<ThreadPageListCell> {
  Widget buildNamePosTime(ThreadPageListCellDataLayouter l, dynamic d) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ClickableAvatar(
          radius: 18,
          emptyUser: l.getIsUserEmpty(d),
          imageLink: l.getUserImageLink(d),
          onTap: () {
            if (l.getIsUserEmpty(d)) {
              return;
            }
            navigator.pushNamed(
              "profile_page",
              arguments: l.getUser(d),
            );
          },
        ),
        Container(
          padding: EdgeInsets.only(left: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Text(
                      l.getUsername(d),
                      style: TextStyle(fontSize: 18.0, color: l.getUsernameColor(d)),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 2),
                  ),
                  if (l.getPositionName(d) != "positionTransAuthor".tr && widget.threadAuthor == l.getUsername(d))
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 2),
                      child: Text(
                        "positionTransAuthor".tr,
                        style: TextStyle(fontSize: 12.0, color: l.getTimeColor(d)),
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: l.getTimeColor(d),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(5.0),
                        ),
                      ),
                    ),
                ],
              ),
              Text(
                l.getTimeText(d),
                style: TextStyle(fontSize: 12.0, color: l.getTimeColor(d)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildTopRightCorner(ThreadPageListCellDataLayouter l, dynamic d) {
    return
        // Expanded(
        //   child:
        Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              IconButton(
                padding: EdgeInsets.all(0),
                icon: Icon(Icons.thumb_up,
                    color: l.getIsLiked(d) ? E().threadPageVoteUpPickedColor : E().threadPageVoteUpDownUnpickedColor),
                iconSize: 24,
                onPressed: () {
                  if (l.getIsLiked(d)) {
                    return;
                  }
                  this.widget.likeit();
                  l.setIsLiked(d, true);
                  l.setLikes(d, l.getLikes(d) + 1);
                  l.setVotedowns(d, l.getVotedowns(d) - (l.getIsVotedown(d) ? 1 : 0));
                  l.setIsVotedown(d, false);
                  if (mounted) {
                    setState(() {});
                  }
                },
              ),
              Text(
                l.getLikes(d).toString(),
                style: TextStyle(fontSize: 14.0, color: E().threadPageVoteUpDownNumberColor),
              ),
            ],
          ),
        ),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              IconButton(
                padding: EdgeInsets.all(0),
                icon: Icon(Icons.thumb_down,
                    color:
                        l.getIsVotedown(d) ? E().threadPageVoteDownPickedColor : E().threadPageVoteUpDownUnpickedColor),
                iconSize: 24,
                onPressed: () {
                  if (l.getIsVotedown(d)) {
                    return;
                  }
                  this.widget.votedownit();
                  l.setIsVotedown(d, true);
                  l.setLikes(d, l.getLikes(d) - (l.getIsLiked(d) ? 1 : 0));
                  l.setVotedowns(d, l.getVotedowns(d) + 1);
                  l.setIsLiked(d, false);
                  if (mounted) {
                    setState(() {});
                  }
                },
              ),
              Text(
                l.getIsVotedownNumberShow(d) ? l.getVotedowns(d).toString() : " ",
                style: TextStyle(fontSize: 14.0, color: E().threadPageVoteUpDownNumberColor),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildTitle(ThreadPageListCellDataLayouter l, dynamic d) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            buildNamePosTime(l, d),
            Text(
              l.getPositionName(d),
              style: TextStyle(fontSize: 12.0, color: l.getPositionColor(d)),
            ),
          ],
        ),
        (this.widget.title == null || this.widget.title == "")
            ? Container()
            : Container(
                padding: EdgeInsets.only(
                  top: 15,
                  bottom: 10,
                ),
                child: Text(
                  this.widget.title,
                  style: TextStyle(
                    fontSize: 18.0,
                    color: E().threadPageTitleColor,
                  ),
                ),
              ),
      ],
    );
  }

  Widget buildSubtitle(ThreadPageListCellDataLayouter l, dynamic d) {
    return Container(
      padding: (this.widget.title == null || this.widget.title == "") ? EdgeInsets.only(left: 45) : EdgeInsets.zero,
      child: l.getIsHiddenByVotedown(d)
          ? Container(
              child: Column(
                children: <Widget>[
                  Text(
                    "hiddenByVotedown".tr,
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      decorationStyle: TextDecorationStyle.dashed,
                      decorationColor: E().threadPageContentColor,
                      color: E().threadPageContentColor,
                    ),
                  ),
                  FlatButton(
                    child: Text(
                      "letmeseesee".tr,
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        decorationStyle: TextDecorationStyle.dashed,
                        decorationColor: E().threadPageContentColor,
                        color: E().threadPageContentColor,
                      ),
                    ),
                    onPressed: () {
                      l.setIsHiddenByVotedown(d, false);
                      if (mounted) {
                        setState(() {});
                      }
                    },
                  )
                ],
              ),
            )
          : ParsedText.uploaded(
              text: l.getContent(d),
              uploads: l.getAttachmentFiles(d),
              title: l.getTitle(d),
            ),
    );
  }

  Widget buildBottomRow(ThreadPageListCellDataLayouter l, dynamic d) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                padding: EdgeInsets.all(0),
                icon: Icon(
                  Icons.thumb_up,
                  color: l.getIsLiked(d) ? E().threadPageVoteUpPickedColor : E().threadPageVoteUpDownUnpickedColor,
                ),
                iconSize: 24,
                onPressed: () {
                  if (l.getIsLiked(d)) {
                    return;
                  }
                  this.widget.likeit();
                  l.setIsLiked(d, true);
                  l.setLikes(d, l.getLikes(d) + 1);
                  l.setVotedowns(d, l.getVotedowns(d) - (l.getIsVotedown(d) ? 1 : 0));
                  l.setIsVotedown(d, false);
                  if (mounted) {
                    setState(() {});
                  }
                },
              ),
              Text(
                l.getLikes(d).toString(),
                style: TextStyle(fontSize: 14.0, color: E().threadPageOtherTextColor),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                padding: EdgeInsets.all(0),
                icon: Icon(Icons.thumb_down,
                    color:
                        l.getIsVotedown(d) ? E().threadPageVoteDownPickedColor : E().threadPageVoteUpDownUnpickedColor),
                iconSize: 24,
                onPressed: () {
                  if (l.getIsVotedown(d)) {
                    return;
                  }
                  this.widget.votedownit();
                  l.setIsVotedown(d, true);
                  l.setLikes(d, l.getLikes(d) - (l.getIsLiked(d) ? 1 : 0));
                  l.setVotedowns(d, l.getVotedowns(d) + 1);
                  l.setIsLiked(d, false);
                  if (mounted) {
                    setState(() {});
                  }
                },
              ),
              Text(
                l.getIsVotedownNumberShow(d) ? l.getVotedowns(d).toString() : " ",
                style: TextStyle(fontSize: 14.0, color: E().threadPageVoteUpDownNumberColor),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.data;
    final l = widget.dataLayouter;
    return InkWell(
      highlightColor: l.getHighlightColor(d),
      splashColor: l.getSplashColor(d),
      onTap: () {},
      onLongPress: () {
        this.widget.onLongPress();
      },
      child: Column(
        children: <Widget>[
          ListTile(
            contentPadding: EdgeInsets.only(
              top: 0,
              left: 18,
              right: 18,
            ),
            onTap: () {
              this.widget.onTap();
            },
            title: buildTitle(l, d),
            subtitle: buildSubtitle(l, d),
          ),
          buildBottomRow(l, d),
        ],
      ),
    );
  }
}
