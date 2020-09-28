import 'dart:async';

import 'package:byr_mobile_app/customizations/board_info.dart';
import 'package:byr_mobile_app/customizations/shimmer_theme.dart';
import 'package:byr_mobile_app/customizations/theme_controller.dart';
import 'package:byr_mobile_app/helper/helper.dart';
import 'package:byr_mobile_app/networking/http_request.dart';
import 'package:byr_mobile_app/nforum/nforum_link_handler.dart';
import 'package:byr_mobile_app/nforum/nforum_service.dart';
import 'package:byr_mobile_app/nforum/nforum_structures.dart';
import 'package:byr_mobile_app/pages/page_components.dart';
import 'package:byr_mobile_app/pages/pages.dart';
import 'package:byr_mobile_app/pages/web_page.dart';
import 'package:byr_mobile_app/reusable_components/circle_icon_button.dart';
import 'package:byr_mobile_app/reusable_components/no_padding_list_tile.dart';
import 'package:byr_mobile_app/reusable_components/page_initialization.dart';
import 'package:byr_mobile_app/reusable_components/refreshers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:speech_recognition/speech_recognition.dart';

class BoardmarksPage extends StatefulWidget {
  @override
  BoardmarksPageState createState() => BoardmarksPageState();
}

class BoardmarksPageState extends State<BoardmarksPage>
    with AutomaticKeepAliveClientMixin, InitializationFailureViewMixin {
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  BannerModel banner;
  Map<int, Widget> bannerWidgets;
  FavBoardsModel favBoards;
  PageController controller;
  String _search = "";
  bool isSpeeching = false;

  SpeechRecognition _speech = SpeechRecognition();

  TextEditingController _controller = TextEditingController();
  Timer _timer;

  int factor;
  @override
  void initState() {
    super.initState();
    factor = RefresherFactory.getFactor();
    bannerWidgets = Map<int, Widget>();
    initialization();
  }

  @override
  void initialization() {
    initializationStatus = InitializationStatus.Initializing;
    if (mounted) {
      setState(() {});
    }
    NForumService.getBanner().then((b) {
      NForumService.getFavBoards().then((f) {
        initializationStatus = InitializationStatus.Initialized;
        banner = b;
        favBoards = f;
        controller = PageController(
          initialPage: banner.count * 2,
        );
        if (mounted) {
          setState(() {});
        }
        keepScrolling();
      }).catchError(initializationErrorHandling);
    }).catchError(initializationErrorHandling);
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
    _refreshController.refreshFailed();
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
        failureInfo = "Unknown Exception";
        break;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    if (_timer?.isActive ?? false) {
      _timer.cancel();
    }
    controller?.dispose();
    _refreshController.dispose();
    super.dispose();
  }

  void keepScrolling() {
    _timer = Timer.periodic(Duration(seconds: 5), (t) {
      if (mounted) {
        controller.nextPage(
          duration: Duration(milliseconds: 500),
          curve: Curves.ease,
        );
      }
    });
  }

  Future<void> _onRefresh() {
    return NForumService.getBanner().then((b) {
      NForumService.getFavBoards().then((f) {
        _refreshController.refreshCompleted();
        banner = b;
        favBoards = f;
        controller = PageController(
          initialPage: banner.count * 2,
        );
        if (mounted) {
          setState(() {});
        }
      });
    });
  }

  Future<void> _onSearch() {
    String s = _controller.text;
    if (s.length == 0) {
      return NForumService.getFavBoards().then((f) {
        _search = s;
        favBoards = f;
        if (mounted) {
          setState(() {});
        }
      });
    } else {
      return NForumService.getBoardSearch(s).then((f) {
        _search = s;
        favBoards = f.getFavBoardList();
        if (mounted) {
          setState(() {});
        }
      });
    }
  }

  Widget _buildLoadingView() {
    return ShimmerTheme(
      child: ListView.separated(
        itemCount: 20,
        padding: const EdgeInsets.all(0),
        separatorBuilder: (context, i) {
          return Container(
            height: 0.0,
            margin: EdgeInsetsDirectional.only(start: 15),
          );
        },
        itemBuilder: (context, i) {
          if (i == 0) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 7),
              color: Colors.white,
              height: 40,
            );
          }
          if (i == 1) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 7),
              color: Colors.white,
              height: 100,
            );
          }
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 7),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 5),
                        height: 45,
                        width: 45,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 5, bottom: 10, top: 8),
                                  height: 15,
                                  width: 80,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(Radius.circular(5)),
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 5),
                            height: 15,
                            width: 100,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 5),
                        height: 45,
                        width: 45,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 5, bottom: 10, top: 8),
                                  height: 15,
                                  width: 80,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(Radius.circular(5)),
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 5),
                            height: 15,
                            width: 100,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context0) {
    super.build(context0);
    return Obx(
      () => Scaffold(
        backgroundColor: E().sectionPageBackgroundColor,
        body: Center(
          child: widgetCase(
            initializationStatus,
            {
              InitializationStatus.Initializing: _buildLoadingView(),
              InitializationStatus.Failed: InitializationFailureView(
                failureInfo: failureInfo,
                textColor: E().sectionPageContentColor,
                buttonColor: E().sectionPageContentColor,
                refresh: initialization,
              ),
              InitializationStatus.Initialized: RefresherFactory(
                factor,
                _refreshController,
                true,
                false,
                _onRefresh,
                null,
                CustomScrollView(
                  slivers: <Widget>[
                    SliverFixedExtentList(
                        itemExtent: 40,
                        delegate: SliverChildBuilderDelegate(
                          (context0, index) {
                            return Container(
                                height: 36,
                                padding: EdgeInsets.only(right: 0),
                                child: Row(children: <Widget>[
                                  Expanded(
                                      child: TextField(
                                    controller: _controller,
                                    autocorrect: false,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(color: E().dialogContentColor),
                                    textInputAction: TextInputAction.search,
                                    onChanged: (s) {
                                      _search = _controller.text;
                                      if (mounted) {
                                        setState(() {});
                                      }
                                    },
                                    onSubmitted: (s) {
                                      _onSearch();
                                    },
                                    decoration: InputDecoration(
                                        hintText: "search".tr,
                                        hintStyle: TextStyle(color: E().dialogContentColor),
                                        suffixIcon: _search.length > 0
                                            ? CircleIconButton(
                                                size: 24,
                                                onPressed: () {
                                                  _controller.clear();
                                                  _onSearch();
                                                },
                                                icon: Icons.clear)
                                            : SizedBox.shrink(),
                                        contentPadding: EdgeInsets.all(4),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            width: 0,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        border: UnderlineInputBorder(
                                            borderSide: BorderSide(width: 0, color: E().sectionPageBackgroundColor))),
                                  )),
                                  Container(
                                    color: E().sectionPageBackgroundColor,
                                    child: IconButton(
                                      icon: Icon(
                                          !isSpeeching ? FlutterIcons.microphone_mco : FlutterIcons.text_to_speech_mco,
                                          color: E().otherPageButtonColor),
                                      onPressed: () {
                                        if (!isSpeeching) {
                                          FlutterAudioRecorder.hasPermissions.then((v) {
                                            _speech.activate().then((res) {
                                              _speech.setRecognitionCompleteHandler((String text) {
                                                if (isSpeeching) {
                                                  isSpeeching = false;
                                                  if (mounted) {
                                                    setState(() {});
                                                  }
                                                  if (text.toString().contains("芝麻开门")) {
                                                    navigator.push(CupertinoPageRoute(
                                                        builder: (_) => WebPage(
                                                            WebPageRouteArg("https://bbs.byr.cn/n/board/IWhisper"))));
                                                  } else {
                                                    _controller.text += text;
                                                  }
                                                }
                                              });
                                              _speech.listen(locale: Locale("zh", "CN").toString()).then((result) {
                                                isSpeeching = true;
                                                if (mounted) {
                                                  setState(() {});
                                                }
                                              });
                                            });
                                          });
                                        } else {
                                          isSpeeching = false;
                                          if (mounted) {
                                            setState(() {});
                                          }
                                          _speech.stop().then((value) {});
                                        }
                                      },
                                    ),
                                  ),
                                  Container(
                                    color: E().sectionPageBackgroundColor,
                                    child: IconButton(
                                      icon: Icon(Icons.search, color: E().otherPageButtonColor),
                                      onPressed: () {
                                        _onSearch();
                                      },
                                    ),
                                  )
                                ]));
                          },
                          childCount: 1,
                        )),
                    SliverFixedExtentList(
                      itemExtent: 100.0,
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          return Container(
                            alignment: Alignment.center,
                            child: banner == null
                                ? Container()
                                : PageView.builder(
                                    controller: controller,
                                    itemBuilder: (BuildContext context, int index) {
                                      if (bannerWidgets[index % banner.count] == null) {
                                        bannerWidgets[index % banner.count] = GestureDetector(
                                          onTap: () {
                                            if (!NForumLinkHandler.byrLinkHandler(
                                                banner.banners[index % banner.count].url)) {
                                              if (banner.banners[index % banner.count].url != null &&
                                                  banner.banners[index % banner.count].url.length > 0 &&
                                                  banner.banners[index % banner.count].url != 'about:blank') {
                                                NForumLinkHandler.webLinkHandler(
                                                    banner.banners[index % banner.count].url);
                                              }
                                            }
                                          },
                                          child: Stack(
                                            fit: StackFit.expand,
                                            children: <Widget>[
                                              CachedNetworkImage(
                                                imageUrl: banner.banners[index % banner.count].imageUrl,
                                                fit: BoxFit.cover,
                                              ),
                                            ],
                                          ),
                                        );
                                      }
                                      return bannerWidgets[index % banner.count];
                                    },
                                  ),
                          );
                        },
                        childCount: 1,
                      ),
                    ),
                    SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: (favBoards?.board?.length ?? 0) == 0
                            ? 1
                            : MediaQuery.of(context).size.shortestSide > 600 ? 4 : 2,
                        mainAxisSpacing: 0.0,
                        crossAxisSpacing: 0.0,
                        childAspectRatio: 3.0,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          return (favBoards?.board?.length ?? 0) == 0
                              ? Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "cantFindBoard".tr,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 16, color: E().sectionPageContentColor),
                                  ))
                              : NonPaddingListTile(
                                  onTap: () {
                                    Navigator.pushNamed(context0, "board_page",
                                        arguments: BoardPageRouteArg(favBoards.board[index].name));
                                  },
                                  title: Row(
                                    children: <Widget>[
                                      CircleAvatar(
                                        backgroundColor: BoardInfo.getBoardIconColor(favBoards.board[index].name),
                                        child: Text(
                                          favBoards.board[index].getBoardCnShort(),
                                          style: TextStyle(
                                            color: E().sectionPageBackgroundColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                        child: Container(
                                          padding: EdgeInsets.only(left: 10),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                favBoards.board[index].description,
                                                style: TextStyle(
                                                  color: E().sectionPageContentColor,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Text(
                                                favBoards.board[index].threadsTodayCount == 0
                                                    ? "noThreadTodayTrans".tr
                                                    : (favBoards.board[index].threadsTodayCount == 1
                                                        ? "newThreadTodayTrans".trArgs(
                                                            [favBoards.board[index].threadsTodayCount.toString()])
                                                        : "newThreadsTodayTrans".trArgs(
                                                            [favBoards.board[index].threadsTodayCount.toString()])),
                                                style: TextStyle(color: E().sectionPageContentColor, fontSize: 13),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                        },
                        childCount: (favBoards?.board?.length ?? 0) == 0 ? 1 : favBoards.board.length,
                      ),
                    ),
                  ],
                ),
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
