import 'package:byr_mobile_app/customizations/board_info.dart';
import 'package:byr_mobile_app/customizations/const_colors.dart';
import 'package:byr_mobile_app/customizations/theme_controller.dart';
import 'package:byr_mobile_app/helper/helper.dart';
import 'package:byr_mobile_app/nforum/nforum_service.dart';
import 'package:byr_mobile_app/nforum/nforum_structures.dart';
import 'package:byr_mobile_app/pages/pages.dart';
import 'package:byr_mobile_app/reusable_components/clickable_avatar.dart';
import 'package:byr_mobile_app/reusable_components/no_padding_list_tile.dart';
import 'package:byr_mobile_app/reusable_components/radio_button_group.dart';
import 'package:byr_mobile_app/reusable_components/refreshers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

getColor(CupertinoDynamicColor dynamicColor) {
  return E().isThemeDarkStyle ? dynamicColor.darkColor : dynamicColor.color;
}

class SearchThreadPageRouteArg {
  SearchThreadPageRouteArg(this.boardName);

  final String boardName;
}

class SearchThreadPage extends StatefulWidget {
  final SearchThreadPageRouteArg arg;
  SearchThreadPage(this.arg);

  @override
  _SearchThreadPageState createState() => _SearchThreadPageState();
}

class _SearchThreadPageState extends State<SearchThreadPage> with TickerProviderStateMixin {
  FocusNode _wordFocusNode = FocusNode();
  FocusNode _idFocusNode = FocusNode();
  int factor;
  TextEditingController _wordController = TextEditingController();
  TextEditingController _idController = TextEditingController();
  String _searchWord;
  String _searchId;
  bool _showConditionPanel = false;
  int _timeIndex = 0;
  var _timeList = [100000, 7, 31, 365];
  int _attachIndex = 0;
  bool _searchSuccess = false;
  bool _searchIsEmpty = false;

  ThreadSearchModel _threadSearchModel;
  String _boardName;
  int _currentPage;
  int _lastReplyTime;
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    _wordController.dispose();
    _idController.dispose();
    _refreshController.dispose();
    super.dispose();
  }

  _conditionButtonGroup({
    String title,
    List<String> values,
    int initIndex = 0,
    Function(int) onSelected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(bottom: 10),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: E().topBarTitleNormalColor,
            ),
          ),
        ),
        RadioButtonGroup(
          buttonValues: values,
          buttonColor: getColor(CupertinoColors.tertiarySystemBackground),
          buttonSelectedColor: CupertinoTheme.of(context).primaryColor,
          radioButtonValue: (value) => onSelected(value),
          horizontalButtonCount: 4,
          defaultIndex: initIndex,
          textColor: getColor(CupertinoColors.label),
        )
      ],
    );
  }

  _conditionPanel() {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(bottom: 15, top: 15),
          child: _conditionButtonGroup(
            title: '${"timeRage".tr}:',
            values: [
              "unlimited".tr,
              "oneWeek".tr,
              "oneMonth".tr,
              "oneYear".tr,
            ],
            initIndex: _timeIndex,
            onSelected: (index) {
              _timeIndex = index;
            },
          ),
        ),
        _conditionButtonGroup(
          title: '${"attach".tr}:',
          values: [
            "unlimited".tr,
            "withAttach".tr,
            "withoutAttach".tr,
          ],
          initIndex: _attachIndex,
          onSelected: (index) {
            _attachIndex = index;
          },
        ),
      ],
    );
  }

  _searchPanel() {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 10, top: 5, right: 10),
          child: Row(
            children: [
              Flexible(
                flex: 2,
                child: TextField(
                  focusNode: _wordFocusNode,
                  controller: _wordController,
                  style: TextStyle(
                    color: E().otherPagePrimaryTextColor,
                  ),
                  decoration: InputDecoration(
                    hintText: "titleKeywords".tr,
                    hintStyle: TextStyle(
                      color: E().otherPageSecondaryTextColor,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.fromLTRB(10, 8, 10, 8),
                    isDense: true,
                    filled: true,
                    fillColor: Colors.grey.withAlpha(50),
                  ),
                  maxLines: 1,
                  minLines: 1,
                ),
              ),
              Container(width: 10),
              Flexible(
                flex: 1,
                child: TextField(
                  focusNode: _idFocusNode,
                  controller: _idController,
                  style: TextStyle(
                    color: E().otherPagePrimaryTextColor,
                  ),
                  decoration: InputDecoration(
                    hintText: "authorId".tr,
                    hintStyle: TextStyle(
                      color: E().otherPageSecondaryTextColor,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.fromLTRB(10, 8, 10, 8),
                    isDense: true,
                    filled: true,
                    fillColor: Colors.grey.withAlpha(50),
                  ),
                  maxLines: 1,
                  minLines: 1,
                ),
              ),
              IconButton(
                padding: EdgeInsets.all(0),
                icon: Icon(
                  FontAwesome.filter,
                  color: E().otherPageSecondaryTextColor,
                ),
                onPressed: () {
                  _showConditionPanel = !_showConditionPanel;
                  if (mounted) {
                    setState(() {});
                  }
                },
              ),
              GestureDetector(
                child: Container(
                  child: Text(
                    "cancelTrans".tr,
                    style: TextStyle(
                      color: E().otherPageSecondaryTextColor,
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
        AnimatedSize(
          vsync: this,
          alignment: Alignment.topCenter,
          duration: Duration(milliseconds: 500),
          curve: Curves.fastOutSlowIn,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: _showConditionPanel ? _conditionPanel() : null,
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(10, 15, 10, 5),
          width: MediaQuery.of(context).size.width,
          child: CupertinoButton.filled(
            pressedOpacity: 0.6,
            borderRadius: BorderRadius.all(
              Radius.circular(6),
            ),
            padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 110.0),
            onPressed: () {
              _idFocusNode.unfocus();
              _wordFocusNode.unfocus();
              _onSearch();
            },
            child: Text("search".tr),
          ),
        ),
      ],
    );
  }

  _onSearch() {
    _searchSuccess = false;
    _searchIsEmpty = false;
    _searchWord = _wordController.text.trim();
    _searchId = _idController.text.trim();
    NForumService.getThreadSearch(
      board: _boardName,
      keyword: _searchWord == '' ? null : _searchWord,
      author: _searchId == '' ? null : _searchId,
      attach: _attachIndex == 0 ? null : _attachIndex == 1,
      day: _timeList[_timeIndex],
    ).then((search) {
      _threadSearchModel = search;
      _currentPage = _threadSearchModel.pagination.pageCurrentCount;
      _searchSuccess = true;
      if (search.pagination.itemAllCount == 0) {
        _searchIsEmpty = true;
        _threadSearchModel.articles = List<FrontArticleModel>();
      } else {
        _showConditionPanel = false;
        _lastReplyTime = _threadSearchModel.articles.last.lastReplyTime;
      }
      if (mounted) {
        setState(() {});
      }
    });
  }

  _onLoad() {
    NForumService.getThreadSearch(
      board: _boardName,
      keyword: _searchWord == '' ? null : _searchWord,
      author: _searchId == '' ? null : _searchId,
      attach: _attachIndex == 0 ? null : _attachIndex == 1,
      day: _timeList[_timeIndex],
      page: _currentPage + 1,
    ).then((search) {
      _threadSearchModel.pagination = search.pagination;
      _currentPage = search.pagination.pageCurrentCount;
      bool hasNewData = false;
      for (var article in search.articles) {
        if (_lastReplyTime > article.lastReplyTime) {
          _lastReplyTime = article.lastReplyTime;
          _threadSearchModel.articles.add(article);
          hasNewData = true;
        }
      }
      if (hasNewData) {
        _refreshController.loadComplete();
      } else {
        _refreshController.loadNoData();
      }
      _showConditionPanel = false;
      if (mounted) {
        setState(() {});
      }
    });
  }

  Widget _buildBoardRow(FrontArticleModel article) {
    return Container(
      color: E().otherPagePrimaryColor,
      child: InkWell(
        highlightColor: E().otherPagePrimaryColor.withOpacity(0.12),
        splashColor: BoardInfo.getBoardIconColor(article.boardName).withOpacity(0.12),
        onTap: () {},
        child: NonPaddingListTile(
          contentPadding: EdgeInsets.only(left: 16, right: 16, top: 0),
          onTap: () {
            Navigator.pushNamed(context, "thread_page",
                arguments: ThreadPageRouteArg(article.boardName, article.groupId));
          },
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                article.title,
                style: TextStyle(
                  fontSize: 17.0,
                  color: E().otherPagePrimaryTextColor,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(
                      right: 10,
                      top: 5,
                      bottom: 10,
                    ),
                    child: ClickableAvatar(
                      radius: 10,
                      imageLink: NForumService.makeGetURL(article.user?.faceUrl ?? ""),
                      emptyUser: article.user == null || article.user.faceUrl == null,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      right: 10,
                      top: 5,
                      bottom: 10,
                    ),
                    child: Text(
                      article.user?.id ?? "",
                      style: TextStyle(
                        fontSize: 15.0,
                        color: ConstColors.getUsernameColor(
                          article.user?.gender,
                        ),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      right: 10,
                      top: 5,
                      bottom: 10,
                    ),
                    child: Text(
                      "updatedOn".tr +
                          ' ' +
                          Helper.convTimestampToRelative(
                            article.lastReplyTime,
                          ),
                      style: TextStyle(fontSize: 12.0, color: E().otherPageSecondaryTextColor),
                      overflow: TextOverflow.fade,
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.only(
                  bottom: 10,
                ),
                child: Text(
                  (article.replyCount - 1).toString() + ' ' + "repliersTrans".tr,
                  textWidthBasis: TextWidthBasis.parent,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: E().otherPageSecondaryTextColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _searchResultView() {
    return Visibility(
      visible: _searchSuccess,
      child: RefresherFactory(
        factor,
        _refreshController,
        false,
        true,
        null,
        _onLoad,
        ListView.separated(
          controller: _scrollController,
          physics: AlwaysScrollableScrollPhysics(parent: ClampingScrollPhysics()),
          itemCount: _threadSearchModel.articles.length + 1,
          padding: const EdgeInsets.all(0),
          separatorBuilder: (context, i) => Container(
            height: 0.0,
            margin: EdgeInsetsDirectional.only(start: 16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: E().otherPageDividerColor, width: 0.8),
              ),
            ),
          ),
          itemBuilder: (context, i) {
            if (i == 0) {
              return Container(
                color: E().otherPagePrimaryColor,
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 16),
                height: 30,
                child: Text(
                  _searchIsEmpty
                      ? "searchNoResults".tr
                      : '${"searchHintPart1".tr} ${_threadSearchModel.pagination.itemAllCount} ${"searchHintPart2".tr}',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: E().otherPagePrimaryTextColor,
                  ),
                ),
              );
            } else {
              return _buildBoardRow(_threadSearchModel.articles[i - 1]);
            }
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    factor = RefresherFactory.getFactor();
    _threadSearchModel = ThreadSearchModel(
      PaginationModel(0, 0, 0, 0),
      List<FrontArticleModel>(),
    );
    _boardName = widget.arg.boardName;
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: E().isThemeDarkStyle ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: E().otherPagePrimaryColor,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _searchPanel(),
              Expanded(
                child: _searchResultView(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
