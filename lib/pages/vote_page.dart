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
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:share/share.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tinycolor/tinycolor.dart';

typedef VoteItemCellTapCallback = void Function(int tappedVoteItem);

class VoteItemCell extends StatefulWidget {
  final Key key;
  final VoteModel vote;
  final VoteItemModel voteItem;
  final bool isVotable;
  final VoteItemCellTapCallback onTap;
  final int Function() getGroupValue;
  final bool Function(int) getIsSelected;
  VoteItemCell(this.key, this.vote, this.voteItem, this.isVotable, this.onTap, this.getGroupValue, this.getIsSelected)
      : super(key: key);
  @override
  VoteItemCellState createState() => VoteItemCellState();
}

class VoteItemCellState extends State<VoteItemCell> with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation _animation;

  void refresh() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

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
  Widget build(BuildContext context) {
    return NonPaddingListTile(
      contentPadding: EdgeInsets.all(1),
      onTap: !widget.isVotable
          ? null
          : () {
              widget.onTap(int.tryParse(widget.voteItem.viid));
              if (mounted) {
                setState(() {});
              }
            },
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(left: 0, right: 0, top: 6, bottom: 3),
            child: Text(
              widget.voteItem.label + ": " + widget.voteItem.number,
              style: TextStyle(
                fontSize: 14.0,
                color: E().voteBetOptionTextColor,
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                flex: 7,
                child: Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: Colors.grey[300],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: (_animation.value *
                                ((int.tryParse(widget.voteItem.number) == null ||
                                        int.tryParse(widget.voteItem.number) == 0)
                                    ? 0
                                    : ((int.tryParse(widget.voteItem.number) ?? 0) / widget.vote.voteCount * 10000)))
                            .round(),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            color:
                                widget.isVotable ? E().voteBetBarFillColor : E().voteBetBarFillColor.withOpacity(0.9),
                          ),
                          height: 10.0,
                        ),
                      ),
                      Expanded(
                        flex: 10000 -
                            (_animation.value *
                                    ((int.tryParse(widget.voteItem.number) == null ||
                                            int.tryParse(widget.voteItem.number) == 0)
                                        ? 0
                                        : ((int.tryParse(widget.voteItem.number) ?? 0) /
                                            widget.vote.voteCount *
                                            10000)))
                                .round(),
                        child: Container(
                          height: 10.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Theme(
                  data: ThemeData(
                    unselectedWidgetColor: E().voteBetOptionTickUnselectedColor,
                    disabledColor: E().voteBetOptionTickUnselectedColor,
                  ),
                  child: widget.vote.type == '1'
                      ? Checkbox(
                          onChanged: !widget.isVotable
                              ? null
                              : (bool value) {
                                  widget.onTap(int.tryParse(widget.voteItem.viid));
                                  if (mounted) {
                                    setState(() {});
                                  }
                                },
                          value: widget.getIsSelected(int.tryParse(widget.voteItem.viid)),
                        )
                      : Radio(
                          value: widget.voteItem.viid,
                          groupValue: widget.getGroupValue().toString(),
                          onChanged: !widget.isVotable
                              ? null
                              : (String value) {
                                  widget.onTap(int.tryParse(widget.voteItem.viid));
                                  if (mounted) {
                                    setState(() {});
                                  }
                                },
                        ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  ((int.tryParse(widget.voteItem.number) == null || int.tryParse(widget.voteItem.number) == 0)
                              ? 0
                              : ((int.tryParse(widget.voteItem.number) ?? 0) / widget.vote.voteCount * 100))
                          .toStringAsFixed(2) +
                      "%",
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: E().voteBetOptionPercentageTextColor,
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

class VoteCell extends StatefulWidget {
  final VoteModel vote;
  final String desc;
  final Function reload;
  VoteCell(this.vote, this.desc, this.reload);
  @override
  VoteCellState createState() => VoteCellState();
}

class VoteCellState extends State<VoteCell> {
  Map<int, bool> votedTickets;
  int votedTicket;

  Set<GlobalKey<VoteItemCellState>> itemCells;

  @override
  void initState() {
    super.initState();
  }

  void restart() {
    itemCells = Set<GlobalKey<VoteItemCellState>>();
    votedTicket = null;
    votedTickets = Map<int, bool>();
    widget.vote.options.forEach((e) {
      if (int.tryParse(e.viid) != null) {
        votedTickets[int.tryParse(e.viid)] = false;
      }
    });
    if (widget.vote.voteStatus != null) {
      widget.vote.voteStatus.viid.forEach((e) {
        votedTickets[int.tryParse(e) ?? 0] = true;
        votedTicket = int.tryParse(e) ?? 0;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void itemTap(int viid) {
    votedTickets[viid] = !votedTickets[viid];
    votedTicket = viid;
    itemCells.forEach((i) {
      if (i != null && i.currentState != null) {
        i.currentState.refresh();
      }
    });
  }

  void castVote() {
    if (widget.vote.type == "0") {
      if (votedTicket == null) {
        AdaptiveComponents.showAlertDialog(
          context,
          title: "voteLimitAlert".tr,
          hideCancel: true,
        );
      } else {
        voteOn([votedTicket]);
      }
    } else {
      List<int> selected = List<int>();
      votedTickets.forEach((k, v) {
        if (v == true) {
          selected.add(k);
        }
      });
      if (selected.length < 1 ||
          ((int.tryParse(widget.vote.limit) ?? 0) != 0 && selected.length > (int.tryParse(widget.vote.limit) ?? 0))) {
        AdaptiveComponents.showAlertDialog(
          context,
          title: "voteLimitAlert".tr,
          hideCancel: true,
        );
      } else {
        voteOn(selected);
      }
    }
  }

  bool getIsSelected(int viid) {
    return votedTickets[viid];
  }

  int getGroupValue() {
    return votedTicket;
  }

  void voteOn(List<int> viids) {
    if (int.tryParse(widget.vote?.vid) != null) {
      NForumService.voteOn(int.tryParse(widget.vote.vid), viids, widget.vote.type == '1').then((value) {
        widget.reload();
      }).catchError((e) {});
    }
  }

  @override
  Widget build(BuildContext context) {
    restart();
    itemCells.clear();
    return InkWell(
      highlightColor: E().threadPageBackgroundColor.withOpacity(0.12),
      splashColor: E().isBoardDefaultColorsUsed
          ? BoardInfo.getBoardIconColor('vote').withOpacity(0.12)
          : E().threadPageBackgroundColor.lighten(10).withOpacity(0.12),
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
                      child: (widget.vote.title == null || widget.vote.title == "")
                          ? Container()
                          : Container(
                              padding: EdgeInsets.only(
                                top: 15,
                                bottom: 10,
                              ),
                              child: Text(
                                widget.vote.title,
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
                          widget.desc,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14.0,
                            color: E().voteBetOtherTextColor,
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          widget.vote.type == "1"
                              ? "voteTypeMultiple".tr +
                                  (widget.vote.limit == '0' ? "" : "voteLimit".tr.replaceAll("@", widget.vote.limit))
                              : "voteTypeSingle".tr,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14.0,
                            color: E().voteBetOtherTextColor,
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          "resultAfterVote".tr,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14.0,
                            color: E().voteBetOtherTextColor,
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          widget.vote.userCount + "userVoted".tr,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14.0,
                            color: E().voteBetOtherTextColor,
                          ),
                        ),
                      ),
                      widget.vote.isEnd || widget.vote.isDel
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
                                  DateTime.fromMillisecondsSinceEpoch(int.tryParse(widget.vote.start) * 1000)
                                          .toString()
                                          .replaceAll(RegExp(r'....$'), '') +
                                      " - " +
                                      DateTime.fromMillisecondsSinceEpoch(int.tryParse(widget.vote.end) * 1000)
                                          .toString()
                                          .replaceAll(RegExp(r'....$'), ''),
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
                          children: widget.vote.options.map<Widget>((vitem) {
                            return Container(
                              padding: EdgeInsets.symmetric(vertical: 0.2),
                              child: VoteItemCell(
                                  (itemCells..add(GlobalKey<VoteItemCellState>())).last,
                                  widget.vote,
                                  vitem,
                                  !(widget.vote.isEnd || widget.vote.isDel || (widget.vote.voteStatus != null)),
                                  itemTap,
                                  getGroupValue,
                                  getIsSelected),
                            );
                          }).toList(),
                        ),
                      ),
                      widget.vote.voteStatus != null
                          ? Container()
                          : Center(
                              child: FlatButton(
                                color: E().voteBetOptionButtonBackgroundColor.darken(5),
                                child: Text("vote".tr,
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: E().voteBetOptionButtonTextColor,
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.normal,
                                    )),
                                onPressed: castVote,
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
                            widget.vote.title + ": " + NForumService.makeVoteURL(widget.vote.vid) + ' 北邮人论坛');
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

class VoteData extends ThreadBaseData {
  VoteModel vote;
  String desc;
}

class VotePageRouteArg extends ThreadBasePageRouteArg {
  final int voteId;
  final bool keepAlive;

  VotePageRouteArg(this.voteId, {this.keepAlive = false}) : super('nVote', -1, keepAlive: keepAlive);
}

class VotePage extends ThreadBasePage {
  final VotePageRouteArg arg;

  VotePage(this.arg) : super(arg);

  @override
  State<StatefulWidget> createState() {
    return VotePageState();
  }
}

class VotePageState extends ThreadPageBaseState<VotePage, VoteData> {
  @override
  Future<void> initialDataLoader({Function afterLoad}) {
    setScreenshotTitle(NForumService.makeVoteURL(widget.arg.voteId.toString()));
    data = VoteData();
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
    return NForumService.getVote(widget.arg.voteId).then((vote) {
      data.vote = vote;
      if (int.tryParse(vote.aid) != null) {
        data.groupId = int.tryParse(vote.aid);

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
            if (thread.article[0].isSubject) {
              data.desc = RegExp(r'描述:(.*)\s').firstMatch(thread.article[0].content).group(1) ?? "";
            } else {
              data.desc = "";
            }
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
    return NForumService.getVote(widget.arg.voteId).then((vote) {
      data.vote = vote;
      if (vote.aid != null) {
        data.groupId = int.tryParse(vote.aid);

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
    if (data.vote?.vid != null) {
      await Share.share(data.vote.title + ": " + NForumService.makeBetURL(data.vote.vid) + ' 北邮人论坛');
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
        return Container(
          alignment: Alignment.center,
          child: Image.asset(
            'resources/delete_bg.png',
          ),
        );
      }
      return AutoScrollTag(
        key: ValueKey(i),
        controller: scrollController,
        index: i,
        highlightColor: E().threadPageBackgroundColor,
        child: VoteCell(data.vote, data.desc, () {
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 7,
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
            Container(
              margin: EdgeInsets.only(left: 5, right: 5, top: 10),
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
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
                    margin: EdgeInsets.only(left: 25, right: 25, top: 10),
                    height: 15,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 30, right: 30, top: 10),
                    height: 15,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 22, right: 22, top: 10),
                    height: 15,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 28, right: 28, top: 10, bottom: 5),
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
