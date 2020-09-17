import 'package:byr_mobile_app/customizations/board_info.dart';
import 'package:byr_mobile_app/customizations/theme_controller.dart';
import 'package:byr_mobile_app/helper/helper.dart';
import 'package:byr_mobile_app/networking/http_request.dart';
import 'package:byr_mobile_app/nforum/nforum_service.dart';
import 'package:byr_mobile_app/nforum/nforum_structures.dart';
import 'package:byr_mobile_app/pages/page_components.dart';
import 'package:byr_mobile_app/pages/pages.dart';
import 'package:byr_mobile_app/reusable_components/byr_app_bar.dart';
import 'package:byr_mobile_app/reusable_components/no_padding_list_tile.dart';
import 'package:byr_mobile_app/reusable_components/page_initialization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tinycolor/tinycolor.dart';

class SectionPage extends StatefulWidget {
  @override
  SectionPageState createState() => SectionPageState();
  final String sectionName;

  SectionPage(
    this.sectionName,
  );
}

class SectionPageState extends State<SectionPage> with AutomaticKeepAliveClientMixin, InitializationFailureViewMixin {
  SectionListModel _sectionObjects;
  SectionModel _sectionObject;
  List<BoardModel> _boardsObject;

  bool _isRoot;

  @override
  void initState() {
    super.initState();
    if (widget.sectionName == '' || widget.sectionName == null) {
      _isRoot = true;
    } else {
      _isRoot = false;
    }
    initialization();
  }

  @override
  void initialization() {
    initializationStatus = InitializationStatus.Initializing;
    if (_isRoot) {
      NForumService.getSections().then(
        (sections) {
          initializationStatus = InitializationStatus.Initialized;
          _sectionObjects = sections;
          _boardsObject = [];
          if (mounted) {
            setState(() {});
          }
        },
      ).catchError(initializationErrorHandling);
    } else {
      NForumService.getSection(widget.sectionName).then(
        (section) {
          initializationStatus = InitializationStatus.Initialized;
          _sectionObject = section;
          _boardsObject = _sectionObject.board;
          _sectionObjects = new SectionListModel([]);
          for (var sectionName in _sectionObject.subSection) {
            _sectionObjects.sections.add(SectionModel.fromJson({
              'name': sectionName,
              'description': sectionName,
              'is_root': false,
            }));
          }
          if (mounted) {
            setState(() {});
          }
        },
      ).catchError(initializationErrorHandling);
    }
  }

  void initializationErrorHandling(e) {
    setFailureInfo(e);
    initializationStatus = InitializationStatus.Failed;
    if (mounted) {
      setState(() {});
    }
  }

  void refreshErrorHandling(e) {
    setFailureInfo(e);
    if (mounted) {
      setState(() {});
    }
  }

  void loadErrorHandling(e) {
    setFailureInfo(e);
    if (mounted) {
      setState(() {});
    }
  }

  void setFailureInfo(e) {
    switch (e.runtimeType) {
      case NetworkException:
        failureInfo = "networkExceptionTrans".tr;
        break;
      case APIException:
        failureInfo = e.toString();
        break;
      case DataException:
        failureInfo = "dataExceptionTrans".tr;
        break;
      default:
        failureInfo = e.toString();
        break;
    }
  }

  Widget _buildSectionListView() {
    return ListView.separated(
      physics: AlwaysScrollableScrollPhysics(parent: ClampingScrollPhysics()),
      itemCount: _sectionObjects.sections.length + _boardsObject.length,
      padding: const EdgeInsets.all(0),
      separatorBuilder: (context, i) => Container(
        height: 0.0,
        margin: EdgeInsetsDirectional.only(start: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: E().threadListDividerColor, width: 0.8),
          ),
        ),
      ),
      itemBuilder: (context, i) {
        if (i < _sectionObjects.sections.length) {
          return _buildSectionRow(_sectionObjects.sections[i], i);
        }
        int j = i - _sectionObjects.sections.length;
        return _buildBoardRow(_boardsObject[j], j);
      },
    );
  }

  Widget _buildSectionRow(SectionModel sectionObject, int i) {
    String subSectionTrans = "subSectionTrans".tr;
    return InkWell(
      highlightColor: E().threadListBackgroundColor.withOpacity(0.12),
      splashColor: Colors.blueGrey.withOpacity(0.12),
      onTap: () {},
      child: NonPaddingListTile(
        contentPadding: EdgeInsets.only(left: 25, right: 25, top: 0),
        onTap: () {
          Navigator.pushNamed(context, "section_page", arguments: sectionObject.name);
        },
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              backgroundColor: E().isThemeDarkStyle
                  ? BoardInfo.colors[i % BoardInfo.colors.length].darken(30)
                  : BoardInfo.colors[i % BoardInfo.colors.length],
              child: Text(
                sectionObject.description[0].toUpperCase(),
                style: TextStyle(
                  color: E().threadListBackgroundColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Text(
                (sectionObject.isRoot ? "" : subSectionTrans + " - ") + sectionObject.description,
                style: TextStyle(
                  fontSize: 16,
                  color: E().threadListTileTitleColor,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildBoardRow(BoardModel boardObject, int i) {
    return InkWell(
      highlightColor: E().threadListBackgroundColor.withOpacity(0.12),
      splashColor: E().threadListBackgroundColor.withOpacity(0.15),
      onTap: () {},
      child: NonPaddingListTile(
        contentPadding: EdgeInsets.only(left: 25, right: 25, top: 0),
        onTap: () {
          Navigator.pushNamed(context, "board_page", arguments: BoardPageRouteArg(boardObject.name));
        },
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              backgroundColor: BoardInfo.getBoardIconColor(boardObject),
              child: Text(
                boardObject.getBoardCnShort(),
                style: TextStyle(
                  color: E().threadListBackgroundColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 8, right: 16, bottom: 8),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                Text(
                  boardObject.description,
                  style: TextStyle(
                    fontSize: 16,
                    color: E().threadListTileTitleColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  boardObject.name,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 16,
                    color: E().threadListTileTitleColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ]),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: Icon(boardObject.isFavorite ? Icons.star : Icons.star_border),
                  color: boardObject.isFavorite ? Colors.yellow[600] : Colors.grey,
                  onPressed: () {
                    boardObject.isFavorite ? boardObject.delFavorite() : boardObject.addFavorite();
                    boardObject.isFavorite = !boardObject.isFavorite;
                    if (mounted) {
                      setState(() {});
                    }
                  },
                ),
                padding: EdgeInsets.all(0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingView() {
    return Shimmer.fromColors(
      baseColor: !E().isThemeDarkStyle ? Colors.grey[300] : Colors.grey,
      highlightColor: !E().isThemeDarkStyle ? Colors.grey[100] : Colors.white,
      enabled: true,
      child: ListView.separated(
        itemCount: 20,
        padding: const EdgeInsets.all(0),
        separatorBuilder: (context, i) {
          return Container(
            height: 0.0,
            margin: EdgeInsetsDirectional.only(start: 15),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: E().threadListDividerColor, width: 0.5),
              ),
            ),
          );
        },
        itemBuilder: (context, i) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 6),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: 5),
                  height: 45,
                  width: 45,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                ),
                Container(
                  margin: EdgeInsets.only(left: 5),
                  height: 20,
                  width: 80,
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

  @override
  Widget build(BuildContext context) {
    super.build(context);
    String sectionName = widget.sectionName;
    sectionName ??= '';
    return Obx(
      () => Scaffold(
        backgroundColor: E().threadListBackgroundColor,
        appBar: BYRAppBar(
          title: Text(
            "sectionButtonTrans".tr,
          ),
        ),
        body: Center(
          child: widgetCase(
            initializationStatus,
            {
              InitializationStatus.Initializing: _buildLoadingView(),
              InitializationStatus.Failed: buildLoadingFailedView(),
              InitializationStatus.Initialized: initializationStatus != InitializationStatus.Initialized
                  ? _buildLoadingView()
                  : Column(
                      children: <Widget>[
                        Expanded(
                          child: _buildSectionListView(),
                        ),
                      ],
                    ),
            },
            _buildLoadingView(),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
