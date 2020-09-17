import 'package:byr_mobile_app/customizations/board_info.dart';
import 'package:byr_mobile_app/customizations/theme_controller.dart';
import 'package:byr_mobile_app/nforum/board_att_info.dart';
import 'package:byr_mobile_app/nforum/nforum_service.dart';
import 'package:byr_mobile_app/nforum/nforum_structures.dart';
import 'package:byr_mobile_app/pages/pages.dart';
import 'package:byr_mobile_app/pages/thread_base_page.dart';
import 'package:byr_mobile_app/reusable_components/adaptive_components.dart';
import 'package:byr_mobile_app/reusable_components/article_cell.dart';
import 'package:byr_mobile_app/reusable_components/no_padding_list_tile.dart';
import 'package:byr_mobile_app/shared_objects/shared_objects.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:share/share.dart';
import 'package:shimmer/shimmer.dart';

typedef BetItemCellTapCallback = void Function(BetItemModel tappedBetItem);

class BetItemCell extends StatefulWidget {
  final BetItemModel betItem;
  final MyBetItemModel myBet;
  final bool isBetable;
  final bool isWinner;
  final BetItemCellTapCallback onTap;
  BetItemCell(this.betItem, this.myBet, this.isBetable, this.isWinner, this.onTap);
  @override
  BetItemCellState createState() => BetItemCellState();
}

class BetItemCellState extends State<BetItemCell> with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(duration: Duration(seconds: 1), vsync: this);
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_animationController);
    _animation.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NonPaddingListTile(
      contentPadding: EdgeInsets.all(1),
      onTap: (!widget.isBetable || (widget.myBet != null && widget.betItem.biid != widget.myBet.biid))
          ? null
          : () {
              widget.onTap(widget.betItem);
            },
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(left: 0, right: 0, top: 6, bottom: 3),
            child: Text(
              widget.betItem.label + ": " + widget.betItem.score,
              style: TextStyle(
                fontSize: 14.0,
                color: widget.isWinner ? Colors.red : E().voteBetOptionTextColor,
              ),
            ),
          ),
          (!(widget.myBet != null && widget.betItem.biid == widget.myBet.biid))
              ? Container()
              : Container(
                  padding: EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 3),
                  child: Text(
                    "betStakeTrans".tr +
                        ": " +
                        widget.myBet.score +
                        ", " +
                        "betPotentialCollectTrans".tr +
                        ": " +
                        widget.myBet.bonus.toString(),
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.blue,
                    ),
                  ),
                ),
          Row(
            children: [
              Expanded(
                flex: 8,
                child: Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: E().voteBetBarBaseColor,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: (_animation.value * ((double.tryParse(widget.betItem.percent) ?? 0) * 100)).round(),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            color: widget.isWinner
                                ? E().voteBetOptionResultBarFillColor
                                : widget.isBetable ? E().voteBetBarFillColor : E().voteBetBarFillColor.withOpacity(0.9),
                          ),
                          height: 10.0,
                        ),
                      ),
                      Expanded(
                        flex:
                            10000 - (_animation.value * ((double.tryParse(widget.betItem.percent) ?? 0) * 100)).round(),
                        child: Container(
                          height: 10.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  widget.betItem.percent + "%",
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: widget.isWinner ? Colors.red : E().voteBetOptionPercentageTextColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BetCell extends StatefulWidget {
  final BetModel bet;
  final Function reload;
  BetCell(this.bet, this.reload);
  @override
  BetCellState createState() => BetCellState();
}

class BetCellState extends State<BetCell> {
  TextEditingController _controller;
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void itemTap(BetItemModel bitem) {
    _controller.clear();
    SharedObjects.me.then((userInfo) {
      AdaptiveComponents.showAlertDialog(
        context,
        title: "betOnTrans".tr + " " + bitem.label,
        contentWidget: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                "minimumBetTrans".tr +
                    ": " +
                    widget.bet.limit +
                    ", " +
                    "myTokenBalanceTrans".tr +
                    ": " +
                    (userInfo?.score ?? 0).toString(),
                style: TextStyle(
                  fontSize: 17.0,
                  color: E().dialogTitleColor,
                ),
              ),
              Material(
                color: Colors.transparent,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        style: TextStyle(color: E().dialogTitleColor),
                        decoration: InputDecoration(
                            labelText: "profileScore".tr, labelStyle: TextStyle(color: E().dialogTitleColor)),
                        controller: _controller,
                        keyboardType: TextInputType.numberWithOptions(signed: false, decimal: false),
                      ),
                    ),
                    GestureDetector(
                      child: Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Text(
                          "allinTrans".tr + "!",
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      onTap: () {
                        _controller.text = userInfo.score.toString();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        onDismiss: (value) {
          if (value == AlertResult.confirm) {
            if (int.tryParse(bitem.biid) != null && int.tryParse(_controller.text) != null) {
              betOn(int.tryParse(bitem.biid), int.tryParse(_controller.text));
              _controller.clear();
            }
          }
        },
      );
    });
  }

  void betOn(int biid, int score) {
    if (int.tryParse(widget.bet.bid) != null) {
      NForumService.betOn(int.tryParse(widget.bet.bid), biid, score).then((value) {
        widget.reload();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: E().threadPageBackgroundColor.withOpacity(0.12),
      splashColor: BoardInfo.getBoardIconColor('bet').withOpacity(0.12),
      child: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              ListTile(
                contentPadding: EdgeInsets.only(
                  top: 0,
                  left: 18,
                  right: 18,
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[],
                        ),
                      ],
                    ),
                    Center(
                      child: (widget.bet.title == null || widget.bet.title == "")
                          ? Container()
                          : Container(
                              padding: EdgeInsets.only(
                                top: 15,
                                bottom: 10,
                              ),
                              child: Text(
                                widget.bet.title,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: E().voteBetTitleColor,
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
                subtitle: Container(
                  padding: EdgeInsets.zero,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          widget.bet.desc,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14.0,
                            color: E().voteBetOtherTextColor,
                          ),
                        ),
                      ),
                      widget.bet.isEnd || widget.bet.isDel
                          ? Center(
                              child: Container(
                                padding: EdgeInsets.only(
                                  top: 15,
                                  bottom: 10,
                                ),
                                child: Text(
                                  "betEndTrans".tr,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: E().voteBetOtherTextColor,
                                  ),
                                ),
                              ),
                            )
                          : Center(
                              child: Container(
                                padding: EdgeInsets.only(
                                  top: 15,
                                  bottom: 10,
                                ),
                                child: Text(
                                  widget.bet.start + " - " + widget.bet.end,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: E().voteBetOtherTextColor,
                                  ),
                                ),
                              ),
                            ),
                      Center(
                        child: Column(
                          children: widget.bet.bitems.map<Widget>((bitem) {
                            if (bitem.biid == widget.bet.mybet?.biid) {}
                            return Container(
                              padding: EdgeInsets.symmetric(vertical: 0.2),
                              child: BetItemCell(bitem, widget.bet.mybet, !(widget.bet.isEnd || widget.bet.isDel),
                                  widget.bet.hasResult && widget.bet.result == bitem.biid, itemTap),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: ButtonTheme(
                    minWidth: 100,
                    child: FlatButton.icon(
                      onPressed: () async {
                        await Share.share(
                            widget.bet.title + ": " + NForumService.makeBetURL(widget.bet.bid) + ' 北邮人论坛');
                      },
                      icon: Icon(
                        Icons.share,
                        size: 24,
                        color: E().threadPageButtonUnselectedColor,
                      ),
                      label: Text("share".tr,
                          style: TextStyle(
                            fontSize: 14.0,
                            color: E().threadPageTextUnselectedColor,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.normal,
                          )),
                    )),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BetData extends ThreadBaseData {
  BetModel bet;
}

class BetPageRouteArg extends ThreadBasePageRouteArg {
  final int betId;
  final bool keepAlive;

  BetPageRouteArg(this.betId, {this.keepAlive = false}) : super('bet', -1, keepAlive: keepAlive);
}

class BetPage extends ThreadBasePage {
  final BetPageRouteArg arg;

  BetPage(this.arg) : super(arg);

  @override
  State<StatefulWidget> createState() {
    return BetPageState();
  }
}

class BetPageState extends ThreadPageBaseState<BetPage, BetData> {
  @override
  Future<void> initialDataLoader({Function afterLoad}) {
    setScreenshotTitle(NForumService.makeBetURL(widget.arg.betId.toString()));
    data = BetData();
    data.boardName = widget.arg.boardName;
    var startingPg = widget.arg.startingPage;
    if (startingPg == 1 && widget.arg.startingPosition != -1) {
      startingPg = 1 + widget.arg.startingPosition ~/ PageConfig.pageItemCount;
    }
    data.currentMinPage = startingPg;
    data.currentMaxPage = startingPg;
    data.isAnonymous = NForumSpecs.isAnonymous;

    currentPage = startingPg;
    maxPage = startingPg;
    isLoading = false;

    return NForumService.getBet(widget.arg.betId).then((bet) {
      data.bet = bet;
      if (int.tryParse(bet.aid) != null) {
        data.groupId = int.tryParse(bet.aid);
        reid = data.groupId;
        repos = 0;
        threadId = data.groupId;
        boardName = data.boardName;
        boardDescription = BoardAttInfo.desc(data.boardName);
        replyTail = "";
        SharedObjects.me = NForumService.getSelfUserInfo();
        return SharedObjects.me.then((userInfo) {
          return NForumService.getThread(data.boardName, data.groupId, page: startingPg).then((thread) {
            if (data.authorToShow != null && data.authorToShow != "") {
              thread.likeArticles = [];
            }
            data.thread = thread;
            firstPageJump = data.thread.likeArticles?.length ?? 0;
            maxPage = thread.pagination?.pageAllCount ?? maxPage;
            data.isCollected = data.thread?.collect;
            if (afterLoad != null) {
              afterLoad();
            }
          });
        });
      } else {
        return null;
      }
    });
  }

  @override
  Future<void> firstTopDataLoader({Function afterLoad}) {
    return NForumService.getBet(widget.arg.betId).then((bet) {
      data.bet = bet;
      if (int.tryParse(bet.aid) != null) {
        data.groupId = int.tryParse(bet.aid);
        reid = data.groupId;
        repos = 0;
        threadId = data.groupId;
        boardName = data.boardName;
        boardDescription = BoardAttInfo.desc(data.boardName);
        replyTail = "";
        SharedObjects.me = NForumService.getSelfUserInfo();
        return SharedObjects.me.then((userInfo) {
          return NForumService.getThread(
            data.boardName,
            data.groupId,
            author: data.authorToShow,
          ).then((thread) {
            if (data.authorToShow != null && data.authorToShow != "") {
              thread.likeArticles = [];
            }
            refreshController.refreshCompleted();
            data.currentMinPage = 1;
            data.currentMaxPage = 1;
            data.thread = thread;
            pagerRedraw();
            if (afterLoad != null) {
              afterLoad();
            }
          });
        });
      } else {
        return null;
      }
    });
  }

  @override
  Future<void> shareArticle() async {
    if (data.bet?.bid != null) {
      await Share.share(data.bet.title + ": " + NForumService.makeBetURL(data.bet.bid) + ' 北邮人论坛');
    }
  }

  @override
  Widget buildCell(BuildContext context, int index) {
    int delSubjectLength = 1;
    if (data.thread?.id != null) {
      delSubjectLength = data.thread.article[0].isSubject == false && data.currentMinPage == 1 ? 1 : 0;
    }
    int i = index;
    int j = i - delSubjectLength;
    if (i == 0 && data.currentMinPage == 1) {
      if (j == -1) {
        if (data.authorToShow != null && data.authorToShow.isNotEmpty) {
          return Container();
        }
        return Container(
          alignment: Alignment.center,
          child: Image.asset(
            'resources/thread/delete_bg.png',
          ),
        );
      }
      return AutoScrollTag(
        key: ValueKey(i),
        controller: scrollController,
        index: i,
        highlightColor: E().threadPageBackgroundColor,
        child: BetCell(data.bet, () {
          AdaptiveComponents.showLoading(context);
          this.onTopRefresh().then((x) {
            AdaptiveComponents.hideLoading();
          });
        }),
      );
    }
    return super.buildCell(context, index);
  }

  @override
  Widget buildLoadingView() {
    var getCell = () {
      return Container(
        child: Row(
          children: [
            Expanded(
              flex: 8,
              child: Container(
                margin: EdgeInsets.only(left: 5, right: 5, top: 10),
                height: 10,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                margin: EdgeInsets.only(left: 5, right: 5, top: 10),
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              ),
            ),
          ],
        ),
      );
    };
    return Shimmer.fromColors(
      baseColor: !E().isThemeDarkStyle ? Colors.grey[300] : Colors.grey,
      highlightColor: !E().isThemeDarkStyle ? Colors.grey[100] : Colors.white,
      enabled: true,
      child: ListView.separated(
        itemCount: 10,
        padding: const EdgeInsets.all(0),
        separatorBuilder: (context, i) => Container(
          height: 0.0,
          margin: EdgeInsetsDirectional.only(start: 15),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: E().threadPageDividerColor, width: 0.5),
            ),
          ),
        ),
        itemBuilder: (context, i) {
          if (i == 0) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                    height: 25,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 28, right: 28, top: 10),
                    height: 15,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 25, right: 25, top: 10),
                    height: 15,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 5, right: 5, top: 10),
                    height: 15,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 5, right: 5, top: 10),
                    height: 25,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 5, right: 5, top: 10),
                    height: 15,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  ),
                  getCell(),
                  Container(
                    margin: EdgeInsets.only(left: 5, right: 5, top: 10),
                    height: 15,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  ),
                  getCell(),
                  Container(
                    margin: EdgeInsets.only(left: 5, right: 5, top: 10),
                    height: 15,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  ),
                  getCell(),
                  Container(
                    margin: EdgeInsets.only(left: 5, right: 5, top: 10),
                    height: 15,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  ),
                  getCell(),
                  Container(
                    margin: EdgeInsets.only(left: 5, right: 5, top: 10),
                    height: 15,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  ),
                  getCell(),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Flexible(
                        child: Container(
                          margin: EdgeInsets.only(left: 5, top: 20, bottom: 10),
                          height: 25,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                        ),
                      ),
                      Flexible(
                        child: Container(
                          margin: EdgeInsets.only(left: 5, top: 20, bottom: 10),
                          height: 25,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                        ),
                      ),
                      Flexible(
                        child: Container(
                          margin: EdgeInsets.only(left: 5, top: 20, bottom: 10),
                          height: 25,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: PostInfoView(
                        user: null,
                        postTime: null,
                        emptyView: true,
                        contentColor: E().threadPageContentColor,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 5),
                      height: 15,
                      width: 70,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(left: 5, top: 10),
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                ),
                Container(
                  margin: EdgeInsets.only(left: 5, top: 10),
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                ),
                Container(
                  margin: EdgeInsets.only(left: 5, top: 10),
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
