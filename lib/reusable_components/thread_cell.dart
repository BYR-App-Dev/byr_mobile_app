import 'package:byr_mobile_app/customizations/board_info.dart';
import 'package:byr_mobile_app/customizations/theme_controller.dart';
import 'package:byr_mobile_app/helper/helper.dart';
import 'package:byr_mobile_app/local_objects/local_models.dart';
import 'package:byr_mobile_app/nforum/nforum_service.dart';
import 'package:byr_mobile_app/nforum/nforum_structures.dart';
import 'package:byr_mobile_app/nforum/nforum_text_parser.dart';
import 'package:byr_mobile_app/pages/pages.dart';
import 'package:byr_mobile_app/reusable_components/adaptive_components.dart';
import 'package:byr_mobile_app/reusable_components/clickable_avatar.dart';
import 'package:byr_mobile_app/reusable_components/parsed_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:like_button/like_button.dart';

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
    if (d.boardName == 'Constellations' && (d.groupId == 326533 || d.groupId == 408580)) {
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

  @override
  int getArticleId(ThreadArticleModel d) {
    return d.id;
  }

  @override
  bool isLikeModel(ThreadArticleModel d) {
    return false;
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

  @override
  int getArticleId(LikeArticleModel d) {
    return d.id;
  }

  @override
  bool isLikeModel(LikeArticleModel d) {
    return true;
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
  int getArticleId(T d);
  bool isLikeModel(T d);
}

class ThreadPageListCell<T> extends StatefulWidget {
  final T data;
  final ThreadPageListCellDataLayouter<T> dataLayouter;

  final String title;
  final String boardName;
  final Function onLongPress;
  final Function onTap;
  final Function onOnlyAuthor;
  final bool isSubject;
  final String authorShown;
  final String threadAuthor;
  final bool isBlocklistBlocked;

  ThreadPageListCell(
    this.data,
    this.dataLayouter,
    this.title,
    this.boardName,
    this.onLongPress,
    this.onTap,
    this.onOnlyAuthor, {
    this.isSubject = false,
    this.authorShown = '',
    this.threadAuthor = "",
    this.isBlocklistBlocked = true,
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
    Function onOnlyAuthor, {
    isSubject = false,
    authorShown = '',
    String threadAuthor = "",
    this.onBackToBoard,
    bool isBlocklistBlocked,
  }) : super(
          data,
          dataLayouter,
          title,
          boardName,
          onLongPress,
          onTap,
          onOnlyAuthor,
          isSubject: isSubject,
          authorShown: authorShown,
          threadAuthor: threadAuthor,
          isBlocklistBlocked: isBlocklistBlocked,
        );
  final Function onBackToBoard;
  @override
  ThreadPageSubjectCellState createState() {
    return ThreadPageSubjectCellState();
  }
}

class ThreadPageSubjectCellState extends ThreadPageListCellState<ThreadPageListSubjectCell> {
  Widget _buildBoardName(String name, String desc) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: widget.onBackToBoard,
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
                        color: Colors.white,
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

  // @override
  // Widget buildTopRightCorner(ThreadPageListCellDataLayouter l, dynamic d) {
  //   return _buildBoardName(
  //     l.getBoardName(d),
  //     l.getBoardDescription(d),
  //   );
  // }

  @override
  Widget buildTitle(ThreadPageListCellDataLayouter l, dynamic d) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            buildNamePosTime(l, d),
            _buildBoardName(
              l.getBoardName(d),
              l.getBoardDescription(d),
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
}

class ThreadPageListCellState<T extends ThreadPageListCell> extends State<T> {
  final GlobalKey<LikeButtonState> _voteUpKey = GlobalKey<LikeButtonState>();
  final GlobalKey<LikeButtonState> _voteDownKey = GlobalKey<LikeButtonState>();

  _voteUp(ThreadPageListCellDataLayouter l, dynamic d) {
    NForumService.likeArticle(l.getBoardName(d), l.getArticleId(d)).then((flag) {
      // if (flag) {
      // l.setIsLiked(d, true);
      // l.setIsVotedown(d, false);
      // } else {
      //   if (l.getIsVotedown(d)) {
      //     // 返回原始的状态
      //     _voteDownKey?.currentState?.handleIsLikeChanged(true);
      //   }
      //   _voteUpKey?.currentState?.handleIsLikeChanged(false);
      // }
    }).catchError((_) {
      if (l.getIsVotedown(d)) {
        // 返回原始的状态
        _voteDownKey?.currentState?.handleIsLikeChanged(true);
      }
      _voteUpKey?.currentState?.handleIsLikeChanged(false);
    });
  }

  _voteDown(ThreadPageListCellDataLayouter l, dynamic d) {
    NForumService.votedownArticle(l.getBoardName(d), l.getArticleId(d)).then((flag) {
      // if (flag) {
      // l.setIsVotedown(d, true);
      // l.setIsLiked(d, false);
      // } else {
      //   if (l.getIsLiked(d)) {
      //     // 返回原始的状态
      //     _voteUpKey?.currentState?.handleIsLikeChanged(true);
      //   }
      //   _voteDownKey?.currentState?.handleIsLikeChanged(false);
      // }
    }).catchError((_) {
      if (l.getIsLiked(d)) {
        // 返回原始的状态
        _voteUpKey?.currentState?.handleIsLikeChanged(true);
      }
      _voteDownKey?.currentState?.handleIsLikeChanged(false);
    });
  }

  Widget buildNamePosTime(ThreadPageListCellDataLayouter l, dynamic d) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ClickableAvatar(
          radius: 18,
          isWhisper: (l.getUser(d)?.id ?? "").startsWith("IWhisper"),
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
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ParsedText.uploaded(
                  text: l.getContent(d),
                  uploads: l.getAttachmentFiles(d),
                  title: l.getTitle(d),
                ),
                Container(
                  child: buildBottomRow(l, d),
                  margin: EdgeInsets.only(top: 10, bottom: 5),
                ),
              ],
            ),
    );
  }

  Widget buildBottomRow(ThreadPageListCellDataLayouter l, dynamic d) {
    TextStyle textStyle = TextStyle(fontSize: 14.0, color: E().threadPageOtherTextColor);
    return DefaultTextStyle(
      style: textStyle,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          LikeButton(
            key: _voteUpKey,
            isLiked: l.getIsLiked(d),
            likeBuilder: (bool voteUp) {
              return Icon(
                FontAwesomeIcons.thumbsUp,
                color: voteUp ? E().threadPageVoteUpPickedColor : E().threadPageVoteUpDownUnpickedColor,
                size: 18,
              );
            },
            size: 18,
            circleColor: CircleColor(
              start: E().threadPageVoteUpPickedColor.withOpacity(0.5),
              end: E().threadPageVoteUpPickedColor,
            ),
            bubblesColor: BubblesColor(
              dotPrimaryColor: E().threadPageVoteUpPickedColor,
              dotSecondaryColor: E().threadPageVoteUpPickedColor.withOpacity(0.5),
            ),
            likeCountAnimationType: LikeCountAnimationType.none,
            likeCount: l.getLikes(d),
            likeCountPadding: EdgeInsets.only(left: 5),
            countBuilder: (int voteUpCount, bool voteUp, String text) {
              return Text(
                ' 赞($voteUpCount)',
                style: voteUp ? textStyle.copyWith(color: E().threadPageVoteUpPickedColor) : null,
              );
            },
            onTap: (bool voteUp) async {
              HapticFeedback.lightImpact();
              if (l.getIsLiked(d)) {
                AdaptiveComponents.showToast(context, '赞后不能取消');
              } else {
                if (l.getIsVotedown(d)) {
                  // 取消踩的状态
                  _voteDownKey?.currentState?.handleIsLikeChanged(false);
                }
                l.setIsLiked(d, true);
                l.setIsVotedown(d, false);
                l.setLikes(d, l.getLikes(d) + 1);
                _voteUp(l, d);
              }
              return Future.value(true);
            },
          ),
          // 热门回复不显示踩
          if (!l.isLikeModel(d))
            Container(
              margin: EdgeInsets.only(left: 50),
              child: LikeButton(
                key: _voteDownKey,
                isLiked: l.getIsVotedown(d),
                likeBuilder: (bool voteDown) {
                  return Icon(
                    FontAwesomeIcons.thumbsDown,
                    color: voteDown ? E().threadPageVoteDownPickedColor : E().threadPageVoteUpDownUnpickedColor,
                    size: 18,
                  );
                },
                size: 18,
                circleColor: CircleColor(
                  start: E().threadPageVoteDownPickedColor.withOpacity(0.5),
                  end: E().threadPageVoteDownPickedColor,
                ),
                bubblesColor: BubblesColor(
                  dotPrimaryColor: E().threadPageVoteDownPickedColor,
                  dotSecondaryColor: E().threadPageVoteDownPickedColor.withOpacity(0.5),
                ),
                likeCountAnimationType: LikeCountAnimationType.none,
                likeCount: l.getVotedowns(d),
                likeCountPadding: EdgeInsets.only(left: 5),
                countBuilder: (int voteDownCount, bool voteDown, String text) {
                  return Text(
                    ' 踩($voteDownCount)',
                    style: voteDown ? textStyle.copyWith(color: E().threadPageVoteDownPickedColor) : null,
                  );
                },
                onTap: (bool voteDown) async {
                  HapticFeedback.lightImpact();
                  if (l.getIsVotedown(d)) {
                    AdaptiveComponents.showToast(context, '踩后不能取消');
                  } else {
                    if (l.getIsLiked(d)) {
                      // 取消赞的状态
                      _voteUpKey?.currentState?.handleIsLikeChanged(false);
                    }
                    l.setIsVotedown(d, true);
                    l.setIsLiked(d, false);
                    l.setVotedowns(d, l.getVotedowns(d) + 1);
                    _voteDown(l, d);
                  }
                  return Future.value(true);
                },
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.data;
    final l = widget.dataLayouter;
    return widget.isBlocklistBlocked == true && Blocklist.getBlocklist()[l.getUser(d)?.id] == true
        ? Container()
        : InkWell(
            highlightColor: l.getHighlightColor(d),
            splashColor: l.getSplashColor(d),
            onTap: () {},
            onLongPress: () {
              this.widget.onLongPress();
            },
            child: ListTile(
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
          );
  }
}
