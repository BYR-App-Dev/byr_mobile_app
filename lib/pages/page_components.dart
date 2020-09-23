import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:byr_mobile_app/customizations/byr_icons.dart';
import 'package:byr_mobile_app/customizations/theme_controller.dart';
import 'package:byr_mobile_app/nforum/board_att_info.dart';
import 'package:byr_mobile_app/nforum/nforum_service.dart';
import 'package:byr_mobile_app/nforum/nforum_structures.dart';
import 'package:byr_mobile_app/nforum/nforum_text_parser.dart';
import 'package:byr_mobile_app/pages/pages.dart';
import 'package:byr_mobile_app/reusable_components/controller_insert_text.dart';
import 'package:byr_mobile_app/reusable_components/custom_cupertino_text_selection_controls.dart';
import 'package:byr_mobile_app/reusable_components/custom_material_text_selection_controls.dart';
import 'package:byr_mobile_app/reusable_components/emoticon_panel.dart';
import 'package:byr_mobile_app/reusable_components/page_initialization.dart';
import 'package:byr_mobile_app/reusable_components/screenshot_controller.dart';
import 'package:extended_text_field/extended_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:get/get.dart' as GetXLib;
import 'package:loaded_list_view/loaded_list_view.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:rxdart/rxdart.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:share/share.dart';
import 'package:tinycolor/tinycolor.dart';

class PagedBaseData {
  int currentMinPage;
  int currentMaxPage;
  int articleOffset;
}

enum ScreenshotStatus { Selecting, Capturing, Previewing, Dismissed }

@optionalTypeArgs
mixin ScrollableListMixin<X extends StatefulWidget, T> on State<X> {
  ScreenshotStatus screenshotStatus = ScreenshotStatus.Dismissed;
  Map<int, bool> screenshotIndexes;
  double lengthPercentage;
  AutoScrollController scrollController;
  BehaviorSubject<int> streamController;
  ScreenshotController screenshotController;
  String screenshotTitle;
  ui.Image screenshotImg;
  T data;

  Widget buildSeparator(BuildContext context, int index, {bool isLast = false});

  Widget buildCell(BuildContext context, int index);

  Widget buildList() {
    if (screenshotStatus == ScreenshotStatus.Selecting) {
      return Container(
        color: E().threadPageBackgroundColor,
        child: SingleChildScrollView(
          child: Screenshot(
            controller: screenshotController,
            child: Container(
              color: E().threadPageBackgroundColor,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  cellCount() * 2 + 1,
                  (index) {
                    if (index % 2 == 0) {
                      if (index == cellCount() * 2) {
                        return buildSeparator(context, (index / 2).round(), isLast: true);
                      }
                      return buildSeparator(context, (index / 2).round());
                    } else {
                      return GestureDetector(
                        onTap: () {
                          screenshotIndexes[(index / 2).floor()] = !(screenshotIndexes[(index / 2).floor()] ?? false);
                          if (mounted) {
                            setState(() {});
                          }
                        },
                        child: AbsorbPointer(
                          absorbing: true,
                          child: Container(
                            color: screenshotIndexes[(index / 2).floor()] ?? false
                                ? E().isThemeDarkStyle
                                    ? E().threadPageBackgroundColor.lighten(10)
                                    : E().threadPageBackgroundColor.darken(10)
                                : E().threadPageBackgroundColor,
                            child: buildCell(
                              context,
                              (index / 2).floor(),
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ),
        ),
      );
    } else if (screenshotStatus == ScreenshotStatus.Previewing || screenshotStatus == ScreenshotStatus.Capturing) {
      var entries = screenshotIndexes.entries;
      List<int> toCapture = entries.fold([], (old, e) {
        if (e.value == true) {
          return old..add(e.key);
        }
        return old;
      });
      toCapture.sort();
      return Container(
        color: E().threadPageBackgroundColor,
        child: SingleChildScrollView(
          child: Screenshot(
            controller: screenshotController,
            child: Container(
              color: E().threadPageBackgroundColor,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  toCapture.length * 2 + 1,
                  (index) {
                    if (index % 2 == 0) {
                      if (index == 0) {
                        return Column(
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Column(
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Icon(
                                          BYRIcons.circle_butterfly_solid,
                                          color: E().threadPageButtonSelectedColor,
                                          size: 16,
                                        ),
                                        Text(
                                          "北邮人论坛",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(color: E().threadPageTextSelectedColor),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      "长按浏览原帖",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: E().threadPageTextSelectedColor),
                                    ),
                                  ],
                                ),
                                QrImage(
                                  data: screenshotTitle,
                                  version: QrVersions.auto,
                                  size: 80.0,
                                  foregroundColor: E().threadPageContentColor,
                                ),
                              ],
                            ),
                            Text(
                              screenshotTitle,
                              textAlign: TextAlign.center,
                              style: TextStyle(color: E().threadPageTextSelectedColor),
                            ),
                            Container(
                              height: 1.0,
                              margin: EdgeInsetsDirectional.zero,
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: E().threadPageDividerColor.lighten(10), width: 0.5),
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                      if (index == cellCount() * 2) {
                        return buildSeparator(context, (index / 2).round(), isLast: true);
                      }
                      return buildSeparator(context, (index / 2).round());
                    } else {
                      return IgnorePointer(
                        ignoring: true,
                        child: buildCell(
                          context,
                          toCapture[(index / 2).floor()],
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ),
        ),
      );
    }
    return LoadedListView.builder(
      controller: scrollController,
      itemCount: cellCount() * 2 + 1,
      padding: const EdgeInsets.all(0.0),
      itemBuilder: (BuildContext context, int index) {
        if (index % 2 == 0) {
          if (index == cellCount() * 2) {
            return buildSeparator(context, (index / 2).round(), isLast: true);
          }
          return buildSeparator(context, (index / 2).round());
        } else {
          return AutoScrollTag(
            key: ValueKey(
              (index / 2).floor(),
            ),
            controller: scrollController,
            index: (index / 2).floor(),
            highlightColor: E().threadPageBackgroundColor,
            child: buildCell(
              context,
              (index / 2).floor(),
            ),
          );
        }
      },
    );
  }

  @mustCallSuper
  @override
  void initState() {
    screenshotTitle = '';
    lengthPercentage = 0.0;
    screenshotIndexes = Map<int, bool>();
    screenshotStatus = ScreenshotStatus.Dismissed;
    screenshotController = ScreenshotController();
    streamController = BehaviorSubject<int>();
    streamController
        .bufferTime(const Duration(
          milliseconds: 300,
        ))
        .where((batch) => batch.isNotEmpty)
        .listen(scrollListen);

    scrollController = AutoScrollController();
    scrollController.addListener(onScroll);
    super.initState();
  }

  void setScreenshotTitle(String title) {
    screenshotTitle = title;
  }

  void scrollSolver(int index1, int index2, double extentBefore, double extentAfter);

  int cellCount();

  void scrollListen(List<int> _) {
    int index1 = scrollController.currentTagIndexInViewport(preferPosition: AutoScrollPosition.begin);
    int index2 = scrollController.currentTagIndexInViewport(preferPosition: AutoScrollPosition.end);
    scrollSolver(index1, index2, scrollController.position.extentBefore, scrollController.position.extentAfter);
  }

  void onScroll() {
    streamController.add(0);
  }

  void captureScreenshot() {
    if (screenshotStatus != ScreenshotStatus.Dismissed) {
      return;
    }
    lengthPercentage = 0;
    screenshotIndexes.clear();
    screenshotImg = null;
    screenshotStatus = ScreenshotStatus.Selecting;
    if (mounted) {
      setState(() {});
    }
  }

  void backToSelecting() {
    if (screenshotStatus != ScreenshotStatus.Previewing) {
      return;
    }
    screenshotImg = null;
    screenshotStatus = ScreenshotStatus.Selecting;
    if (mounted) {
      setState(() {});
    }
  }

  void cancelScreenshot() {
    lengthPercentage = 0;
    screenshotIndexes.clear();
    screenshotImg = null;
    screenshotStatus = ScreenshotStatus.Dismissed;
    if (mounted) {
      setState(() {});
    }
  }

  void previewing() {
    if (screenshotStatus != ScreenshotStatus.Selecting) {
      return;
    }
    screenshotImg = null;
    screenshotStatus = ScreenshotStatus.Previewing;
    lengthPercentage = 0;
    if (mounted) {
      setState(() {});
    }
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      try {
        var r = await screenshotController.checkCaptureLength(
          pixelRatio: MediaQuery.of(GetXLib.Get.context).devicePixelRatio,
          delay: Duration(milliseconds: 10),
        );
        lengthPercentage = r.item1;
        screenshotImg = r.item2;
        if (mounted) {
          setState(() {});
        }
      } on Exception catch (_) {}
    });
  }

  void capturing() {
    if (screenshotStatus != ScreenshotStatus.Previewing) {
      return;
    }
    screenshotStatus = ScreenshotStatus.Capturing;
    if (mounted) {
      setState(() {});
    }
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      try {
        var imgPath = "";
        if (screenshotImg != null) {
          ByteData byteData = await screenshotImg.toByteData(format: ui.ImageByteFormat.png);
          Uint8List pngBytes = byteData.buffer.asUint8List();
          final directory = (await getApplicationDocumentsDirectory()).path;
          String fileName = DateTime.now().toIso8601String();
          var path = '$directory/$fileName.png';
          File image = new File(path);
          await image.writeAsBytes(pngBytes).then((onValue) {});
          lengthPercentage = 0;
          screenshotIndexes.clear();
          screenshotStatus = ScreenshotStatus.Dismissed;
          GallerySaver.saveImage(image.path, albumName: 'BYRDownload');
          imgPath = path;
        } else {
          var image = await screenshotController.capture(
            delay: Duration(milliseconds: 10),
            pixelRatio: MediaQuery.of(GetXLib.Get.context).devicePixelRatio,
          );
          lengthPercentage = 0;
          screenshotIndexes.clear();
          screenshotStatus = ScreenshotStatus.Dismissed;
          GallerySaver.saveImage(image.path, albumName: 'BYRDownload');
          imgPath = image.path;
        }
        if (mounted) {
          setState(() {});
        }
        await Share.shareFiles([imgPath], text: screenshotTitle + ' 北邮人论坛');
      } on Exception catch (_) {
        screenshotStatus = ScreenshotStatus.Dismissed;
        if (mounted) {
          setState(() {});
        }
      }
    });
  }

  @mustCallSuper
  @override
  void dispose() {
    scrollController.dispose();
    streamController.close();
    return super.dispose();
  }
}

class ThreadPager extends StatefulWidget {
  final int pageNum;
  final int maxPage;
  final Function(int) presser;
  ThreadPager(this.pageNum, this.maxPage, this.presser, {Key key}) : super(key: key);
  @override
  ThreadPagerState createState() => ThreadPagerState(this.pageNum, this.maxPage, this.presser);
}

class ThreadPagerState extends State<ThreadPager> {
  int pageNum;
  int maxPage;
  Function presser;

  final _pageController = TextEditingController();

  ThreadPagerState(this.pageNum, this.maxPage, this.presser);

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void redraw(int _currentPage, int _maxPage) {
    pageNum = _currentPage;
    maxPage = _maxPage;
    if (mounted) {
      setState(() {});
    }
  }

  Future<int> _showPageDialog() {
    return showDialog<int>(
      context: context,
      builder: (context) {
        return Dialog(
            backgroundColor: E().dialogBackgroundColor,
            child: Container(
                width: 300,
                height: 180,
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        "jumpPage".tr,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: E().dialogTitleColor),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                            width: 120,
                            height: 36,
                            child: TextField(
                              controller: _pageController,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              autofocus: true,
                              style: TextStyle(color: E().dialogContentColor),
                              decoration: InputDecoration(
                                hintText: "pleaseInputPage".tr,
                                contentPadding: EdgeInsets.all(4),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                hintStyle: TextStyle(color: E().dialogContentColor),
                              ),
                            )),
                        Text(
                          '  ' + "current".tr + ' ' + pageNum.toString() + '/' + maxPage.toString() + ' ' + "page".tr,
                          style: TextStyle(fontSize: 16, color: E().dialogContentColor),
                        )
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      width: 200,
                      child: RaisedButton(
                        child: Text("confirmTrans".tr),
                        color: Colors.blue,
                        textColor: Colors.white,
                        onPressed: () {
                          int page = int.tryParse(_pageController.text);
                          _pageController.clear();
                          Navigator.of(context).pop(page);
                        },
                      ),
                    ),
                  ],
                )));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return maxPage <= 1
        ? Container()
        : Positioned(
            right: 15,
            bottom: 40,
            child: AnimatedOpacity(
              opacity: maxPage > 1 ? 1.0 : 0,
              duration: Duration(milliseconds: 100),
              child: ButtonTheme(
                  minWidth: 40,
                  height: 36,
                  child: RaisedButton(
                    onPressed: () async {
                      int page = await _showPageDialog();
                      if (page != null) {
                        presser(page);
                      }
                    },
                    child: Text(pageNum.toString() + '/' + maxPage.toString()),
                    textColor: Colors.white,
                    padding: EdgeInsets.only(left: 15, right: 15),
                    color: Colors.black.withOpacity(0.5),
                  )),
            ),
          );
  }
}

@optionalTypeArgs
mixin PagerMixin<T extends StatefulWidget, E> on State<T> {
  GlobalKey<ThreadPagerState> threadPagerGlobalKey;

  int currentPage;
  int maxPage;

  @mustCallSuper
  @override
  initState() {
    super.initState();
    threadPagerGlobalKey = GlobalKey();
  }

  Future<void> goToPage(int page);

  void pagerRedraw() {
    if (threadPagerGlobalKey != null && threadPagerGlobalKey.currentState != null) {
      threadPagerGlobalKey.currentState.redraw(currentPage, maxPage);
    }
  }

  Widget buildPager() {
    return ThreadPager(
      currentPage,
      maxPage,
      goToPage,
      key: threadPagerGlobalKey,
    );
  }
}

@optionalTypeArgs
mixin ReplyFormMixin<Z extends StatefulWidget, Y> on State<Z> {
  int currentPage;
  int maxPage;
  TextSelection _textSelection;
  GlobalKey<FormState> _formKey;
  TextEditingController replyController;
  DualListener dualListener;
  TextFormFieldWrapper textFormFieldWrapper;
  int reid;
  int repos;
  int threadId;
  String replyTail;
  String boardName;
  String boardDescription;

  @override
  dispose() {
    replyController.dispose();
    super.dispose();
  }

  bool canCancelReplyTarget() {
    return reid != this.threadId || replyTail != "";
  }

  void cancelReplyTarget() {
    reid = this.threadId;
    repos = 0;
    replyTail = "";
    changePlaceHolder();
  }

  void changeReplyPointer(int id, int position, String tail) {
    reid = id;
    repos = position;
    replyTail = tail;
  }

  void changePlaceHolder() {
    if (replyTail == null || replyTail.length == 0) {
      dualListener.f("replycontentTrans".tr);
    } else {
      dualListener.f("replyTrans".tr + NForumTextParser.getArticlePositionName(repos));
    }
  }

  void advancedReply() async {
    var result = await Navigator.pushNamed(
      context,
      'post_page',
      arguments: PostPageRouteArg(
        board: BoardModel(
          name: boardName,
          description: boardDescription,
          allowAttachment: BoardAttInfo.allowAttachment(boardName),
        ),
        reid: reid,
        existingContent: NForumTextParser.stripEmojis(replyController.text),
        replyTail: replyTail,
      ),
    );
    replyController.clear();
    if (result == true) {
      afterReply();
    }
  }

  @mustCallSuper
  @override
  initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    replyController = TextEditingController();
    dualListener = DualListener();
    textFormFieldWrapper = TextFormFieldWrapper(
      replyController,
      dualListener,
      canCancelReplyTarget,
      cancelReplyTarget,
      () {
        _textSelection = replyController.selection;
      },
    );
  }

  void afterEdit();

  void afterReply();

  Widget buildReplyForm() {
    EmoticonPanel _emoticonPanel = EmoticonPanel(
      config: EmoticonPanelConfig(
        {
          'backgroundColor': E().threadPageBackgroundColor,
          'unselectedBackgroundColor': E().emoticonPanelTopBarTitleUnselectedBackgroundColor,
          'selectedBackgroundColor': E().emoticonPanelTopBarTitleSelectedBackgroundColor,
          'tabTextColor': E().emoticonPanelTopBarTitleSelectedTextColor,
        },
        {
          'classicsTabTrans': "emoticonTransClassicsTabTrans".tr,
          'yoyociciTabTrans': "emoticonTransYoyociciTabTrans".tr,
          'tuzkiTabTrans': "emoticonTransTuzkiTabTrans".tr,
          'oniontouTabTrans': "emoticonTransOniontouTabTrans".tr,
        },
      ),
      onEmoticonTap: (String emoticon) {
        _textSelection = controllerInsertText(
          controller: replyController,
          insertText: emoticon,
          currentSelection: _textSelection,
        );
        dualListener.updateSelection(_textSelection);
      },
    );
    return Container(
      color: E().threadPageReplyBarBackgroundColor,
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2.0),
                  child: ButtonTheme(
                    minWidth: 60,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.add_circle_outline),
                      iconSize: 30,
                      color: Color.fromARGB(
                        255,
                        (E().threadPageReplyBarButtonBackgroundColor.red +
                                        E().threadPageReplyBarButtonBackgroundColor.green +
                                        E().threadPageReplyBarButtonBackgroundColor.blue) /
                                    3 >
                                128
                            ? Color(0xFF888888).red
                            : Color(0xFFAAAAAA).red,
                        (E().threadPageReplyBarButtonBackgroundColor.red +
                                        E().threadPageReplyBarButtonBackgroundColor.green +
                                        E().threadPageReplyBarButtonBackgroundColor.blue) /
                                    3 >
                                128
                            ? Color(0xFF888888).green
                            : Color(0xFFAAAAAA).green,
                        (E().threadPageReplyBarButtonBackgroundColor.red +
                                        E().threadPageReplyBarButtonBackgroundColor.green +
                                        E().threadPageReplyBarButtonBackgroundColor.blue) /
                                    3 >
                                128
                            ? Color(0xFF888888).blue
                            : Color(0xFFAAAAAA).blue,
                      ),
                      onPressed: advancedReply,
                    ),
                  ),
                ),
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(5, 5, 0, 5),
                          child: textFormFieldWrapper,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: ButtonTheme(
                    minWidth: 60,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Consumer<EmoticonPanelProvider>(
                      builder: (context, emoticonPanelProvider, child) => RaisedButton(
                        color: E().threadPageReplyBarButtonBackgroundColor,
                        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                        onPressed: () async {
                          FocusScope.of(context).requestFocus(
                            FocusNode(),
                          );
                          Scaffold.of(context).showSnackBar(
                            SnackBar(
                              content: Text('sending'),
                            ),
                          );
                          if (replyController.text == null || replyController.text.trim() == "") {
                            Scaffold.of(context).removeCurrentSnackBar();
                            Scaffold.of(context).showSnackBar(
                              SnackBar(
                                content: Text('invalid content'),
                                duration: Duration(seconds: 1),
                              ),
                            );
                            return;
                          }
                          var tt = await NForumService.postArticle(
                            boardName,
                            "",
                            NForumTextParser.stripEmojis(replyController.text) + replyTail,
                            reId: reid,
                          );
                          if (tt["error"] == null) {
                            Scaffold.of(context).removeCurrentSnackBar();
                            Scaffold.of(context).showSnackBar(
                              SnackBar(
                                content: Text("sendSuccessTrans".tr),
                                duration: Duration(seconds: 1),
                              ),
                            );
                            replyController.clear();
                            emoticonPanelProvider.dismissPanel();
                            reid = this.threadId;
                            repos = 0;
                            replyTail = "";
                            dualListener.f("replycontentTrans".tr);
                            afterReply();
                          } else {
                            Scaffold.of(context).removeCurrentSnackBar();
                            Scaffold.of(context).showSnackBar(
                              SnackBar(
                                content: Text("sendFailedTrans".tr),
                                duration: Duration(milliseconds: 1500),
                              ),
                            );
                          }
                        },
                        child: Text(
                          "submitTrans".tr,
                          style: TextStyle(
                            color: Color.fromARGB(
                              255,
                              (E().threadPageReplyBarButtonBackgroundColor.red +
                                              E().threadPageReplyBarButtonBackgroundColor.green +
                                              E().threadPageReplyBarButtonBackgroundColor.blue) /
                                          3 >
                                      128
                                  ? Color(0xFF888888).red
                                  : Color(0xFFAAAAAA).red,
                              (E().threadPageReplyBarButtonBackgroundColor.red +
                                              E().threadPageReplyBarButtonBackgroundColor.green +
                                              E().threadPageReplyBarButtonBackgroundColor.blue) /
                                          3 >
                                      128
                                  ? Color(0xFF888888).green
                                  : Color(0xFFAAAAAA).green,
                              (E().threadPageReplyBarButtonBackgroundColor.red +
                                              E().threadPageReplyBarButtonBackgroundColor.green +
                                              E().threadPageReplyBarButtonBackgroundColor.blue) /
                                          3 >
                                      128
                                  ? Color(0xFF888888).blue
                                  : Color(0xFFAAAAAA).blue,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Consumer<EmoticonPanelProvider>(
              builder: (context, emoticonPanelProvider, child) {
                if (emoticonPanelProvider.isShow) {
                  return _emoticonPanel;
                } else {
                  return Container();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

typedef SDLF = void Function(String s);
typedef UTS = void Function(TextSelection textSelection);

class DualListener {
  SDLF ff;
  UTS update;

  void f(String s) {
    if (ff != null) {
      ff(s);
    }
  }

  void updateSelection(TextSelection textSelection) {
    if (update != null) {
      update(textSelection);
    }
  }
}

typedef BoolCallback = bool Function();

class TextFormFieldWrapper extends StatefulWidget {
  @override
  TextFormFieldWrapperState createState() => TextFormFieldWrapperState();

  final TextEditingController replyController;

  final DualListener dl;

  final BoolCallback canCancelReplyTarget;

  final VoidCallback cancelReplyTarget;

  final VoidCallback emoticonTap;

  TextFormFieldWrapper(
    this.replyController,
    this.dl,
    this.canCancelReplyTarget,
    this.cancelReplyTarget,
    this.emoticonTap,
  );
}

class TextFormFieldWrapperState extends State<TextFormFieldWrapper> {
  String _placeholder;
  FocusNode _focusNode;
  TextSelection _textSelection = TextSelection(baseOffset: 0, extentOffset: 0);

  _focusNodeListener() {
    if (_focusNode.hasFocus) {
      Provider.of<EmoticonPanelProvider>(context, listen: false).dismissPanel();
      widget.replyController.selection = _textSelection;
    }
  }

  @override
  void initState() {
    super.initState();
    widget.dl.ff = changePlaceHolder;
    widget.dl.update = updateSelection;
    _focusNode = FocusNode();
    _focusNode.addListener(_focusNodeListener);
  }

  @override
  void dispose() {
    super.dispose();
    _focusNode.removeListener(_focusNodeListener);
  }

  void changePlaceHolder(String placeholder) {
    this._placeholder = placeholder;
    if (mounted) {
      setState(() {});
    }
  }

  void updateSelection(TextSelection textSelection) {
    _textSelection = textSelection;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 50,
        child: ExtendedTextField(
          textSelectionControls: Platform.isAndroid
              ? CustomMaterialTextSelectionControls(
                  canCancelTarget: widget.canCancelReplyTarget,
                  cancelTarget: widget.cancelReplyTarget,
                )
              : CustomCupertinoTextSelectionControls(
                  canCancelTarget: widget.canCancelReplyTarget,
                  cancelTarget: widget.cancelReplyTarget,
                ),
          maxLines: null,
          textInputAction: TextInputAction.newline,
          controller: widget.replyController,
          focusNode: _focusNode,
          decoration: InputDecoration(
            prefixIcon: IconButton(
              icon: Icon(
                FontAwesomeIcons.smile,
                color: Color.fromARGB(
                  255,
                  (E().threadPageReplyBarButtonBackgroundColor.red +
                                  E().threadPageReplyBarButtonBackgroundColor.green +
                                  E().threadPageReplyBarButtonBackgroundColor.blue) /
                              3 >
                          128
                      ? Color(0xFF888888).red
                      : Color(0xFFAAAAAA).red,
                  (E().threadPageReplyBarButtonBackgroundColor.red +
                                  E().threadPageReplyBarButtonBackgroundColor.green +
                                  E().threadPageReplyBarButtonBackgroundColor.blue) /
                              3 >
                          128
                      ? Color(0xFF888888).green
                      : Color(0xFFAAAAAA).green,
                  (E().threadPageReplyBarButtonBackgroundColor.red +
                                  E().threadPageReplyBarButtonBackgroundColor.green +
                                  E().threadPageReplyBarButtonBackgroundColor.blue) /
                              3 >
                          128
                      ? Color(0xFF888888).blue
                      : Color(0xFFAAAAAA).blue,
                ),
              ),
              onPressed: () {
                widget.emoticonTap();
                if (_focusNode.hasFocus) {
                  _focusNode.unfocus();
                }
                Provider.of<EmoticonPanelProvider>(context, listen: false).changeState();
              },
            ),
            hintText: _placeholder ?? "replycontentTrans".tr,
            hintStyle: TextStyle(
              color: Color.fromARGB(
                255,
                (E().threadPageReplyBarInputBackgroundColor.red +
                                E().threadPageReplyBarInputBackgroundColor.green +
                                E().threadPageReplyBarInputBackgroundColor.blue) /
                            3 >
                        128
                    ? Color(0xFFAAAAAA).red
                    : Color(0xFF888888).red,
                (E().threadPageReplyBarInputBackgroundColor.red +
                                E().threadPageReplyBarInputBackgroundColor.green +
                                E().threadPageReplyBarInputBackgroundColor.blue) /
                            3 >
                        128
                    ? Color(0xFFAAAAAA).green
                    : Color(0xFF888888).green,
                (E().threadPageReplyBarInputBackgroundColor.red +
                                E().threadPageReplyBarInputBackgroundColor.green +
                                E().threadPageReplyBarInputBackgroundColor.blue) /
                            3 >
                        128
                    ? Color(0xFFAAAAAA).blue
                    : Color(0xFF888888).blue,
              ),
            ),
            filled: true,
            fillColor: E().threadPageReplyBarInputBackgroundColor,
            contentPadding: const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 13.0),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: E().threadPageReplyBarInputBackgroundColor),
              borderRadius: BorderRadius.circular(12),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: E().threadPageReplyBarInputBackgroundColor),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          style: TextStyle(
            height: 1.2,
            color: Color.fromARGB(
              255,
              (E().threadPageReplyBarInputBackgroundColor.red +
                              E().threadPageReplyBarInputBackgroundColor.green +
                              E().threadPageReplyBarInputBackgroundColor.blue) /
                          3 >
                      128
                  ? Color(0xFF555555).red
                  : Color(0xFFDDDDDD).red,
              (E().threadPageReplyBarInputBackgroundColor.red +
                              E().threadPageReplyBarInputBackgroundColor.green +
                              E().threadPageReplyBarInputBackgroundColor.blue) /
                          3 >
                      128
                  ? Color(0xFF555555).green
                  : Color(0xFFDDDDDD).green,
              (E().threadPageReplyBarInputBackgroundColor.red +
                              E().threadPageReplyBarInputBackgroundColor.green +
                              E().threadPageReplyBarInputBackgroundColor.blue) /
                          3 >
                      128
                  ? Color(0xFF555555).blue
                  : Color(0xFFDDDDDD).blue,
            ),
          ),
        ));
  }
}

@optionalTypeArgs
mixin InitializationFailureViewMixin<Z extends StatefulWidget, Y> on State<Z> {
  InitializationStatus initializationStatus;
  String failureInfo;

  @mustCallSuper
  @override
  initState() {
    super.initState();
    initializationStatus = InitializationStatus.Initializing;
    failureInfo = '';
  }

  void initialization();

  Widget buildLoadingFailedView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Text(
          failureInfo,
          style: TextStyle(color: E().threadPageOtherTextColor),
        ),
        IconButton(
          icon: Icon(
            Icons.refresh,
            color: E().threadPageButtonSelectedColor,
          ),
          onPressed: () {
            initialization();
            if (mounted) {
              setState(() {});
            }
          },
        ),
      ],
    );
  }
}
