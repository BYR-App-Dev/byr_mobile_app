import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:byr_mobile_app/customizations/board_info.dart';
import 'package:byr_mobile_app/customizations/const_colors.dart';
import 'package:byr_mobile_app/customizations/theme_controller.dart';
import 'package:byr_mobile_app/helper/helper.dart';
import 'package:byr_mobile_app/nforum/board_att_info.dart';
import 'package:byr_mobile_app/nforum/nforum_service.dart';
import 'package:byr_mobile_app/nforum/nforum_structures.dart';
import 'package:byr_mobile_app/nforum/nforum_text_parser.dart';
import 'package:byr_mobile_app/pages/pages.dart';
import 'package:byr_mobile_app/reusable_components/adaptive_components.dart';
import 'package:byr_mobile_app/reusable_components/bottom_tool_bar.dart';
import 'package:byr_mobile_app/reusable_components/byr_app_bar.dart';
import 'package:byr_mobile_app/reusable_components/circle_icon_button.dart';
import 'package:byr_mobile_app/reusable_components/clickable_avatar.dart';
import 'package:byr_mobile_app/reusable_components/no_padding_list_tile.dart';
import 'package:byr_mobile_app/reusable_components/parsed_text.dart';
import 'package:byr_mobile_app/reusable_components/post_article_provider.dart';
import 'package:byr_mobile_app/shared_objects/shared_objects.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class PostPage extends StatefulWidget {
  final PostPageRouteArg arg;

  PostPage(
    this.arg,
  );
  @override
  PostPageState createState() => PostPageState();
}

class PostPageState extends State<PostPage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => false;

  TextEditingController _titleController = TextEditingController();
  GlobalKey _formKey = GlobalKey<FormState>();

  bool _updateMode;
  ThreadArticleModel _articleModel;

  String _toBoard;
  String _toBoardDesc;
  bool _selectBoard;
  int _reid;
  String _existingContent;
  String _replyTail;
  bool _preview;

  TextEditingController _controller = TextEditingController();
  String _search = "";

  FavBoardsModel favBoards;

  bool _allowAtt = true;
  bool _anonymous = NForumSpecs.isAnonymous;

  AudioPlayer _audioPlayer;

  AudioPlayer getAudioPlayer() {
    if (_audioPlayer == null) {
      _audioPlayer = AudioPlayer();
    }
    return _audioPlayer;
  }

  @override
  void initState() {
    super.initState();

    _toBoard = null;
    _toBoardDesc = null;
    _selectBoard = false;
    _updateMode = widget.arg.updateMode ?? false;
    _articleModel = widget.arg.articleModel;
    _reid = widget.arg.reid;
    _existingContent = widget.arg.existingContent;
    _replyTail = widget.arg.replyTail;
    _preview = false;
    if (!_updateMode) {
      if (widget.arg.board != null) {
        _toBoard = widget.arg.board.name;
        _toBoardDesc = widget.arg.board.description;
        _allowAtt = widget.arg.board.allowAttachment;
        _reid = widget.arg.reid;
        _existingContent = NForumTextParser.retrieveEmojis(_existingContent);
      }
      NForumService.getFavBoards().then((f) {
        favBoards = f;
        if (mounted) {
          setState(() {});
        }
      });
    } else if (_articleModel != null) {
      _toBoard = _articleModel.boardName;
      _toBoardDesc = _articleModel.boardDescription;
      _titleController.text = _articleModel.title;
      _allowAtt = BoardAttInfo.allowAttachment(_toBoard);
      _reid = null;
      _existingContent = NForumTextParser.retrieveEmojis(_articleModel.content);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _controller.dispose();
    if (_audioPlayer != null) {
      _audioPlayer.dispose();
      _audioPlayer = null;
    }
    super.dispose();
  }

  Future<void> _send(context, PostArticleProvider provider) async {
    if (!provider.canPost) {
      AdaptiveComponents.showToast(context, "uploadExceedLimit".tr);
      return false;
    }
    if (_toBoard == "" || _toBoard == null) {
      AdaptiveComponents.showToast(context, "selectBoard".tr);
      return false;
    }
    FormState _form = _formKey.currentState as FormState;
    if (_preview || (_form != null && _form.validate())) {
      AdaptiveComponents.showLoading(
        context,
        content: _updateMode ? "updating".tr : "sendingTrans".tr,
      );
      if (_allowAtt && provider.attachList.length > 0) {
        for (var imagePath in provider.attachList) {
          if (imagePath.item1.contains('file://')) {
            var newimagePath = imagePath.item1.replaceFirst('file://', '');
            var img = File(newimagePath);
            AttachmentModel _att;
            if (_updateMode) {
              _att = await NForumService.uploadAttachmentToArticle(
                _toBoard,
                img,
                _articleModel.id,
              );
            } else {
              _att = await NForumService.uploadAttachment(_toBoard, img);
            }
            if (_att.remainCount == -1) {
              AdaptiveComponents.hideLoading();
              AdaptiveComponents.showToast(context, _att.remainSpace);
              return false;
            }
          }
        }
      }
      if (_updateMode) {
        Map tt = await NForumService.updateArticle(
          _toBoard,
          _articleModel.id,
          _titleController.text,
          NForumTextParser.stripEmojis(provider.controller.text),
        );
        AdaptiveComponents.hideLoading();
        if (tt['code'] != null) {
          AdaptiveComponents.showToast(context, tt['msg']);
        } else {
          AdaptiveComponents.showToast(context, "update".tr + "succeed".tr);
          Navigator.of(context).pop(true);
        }
      } else if (_reid != null) {
        Map tt = await NForumService.postArticle(
          _toBoard,
          _titleController.text,
          NForumTextParser.stripEmojis(provider.controller.text) + _replyTail,
          reId: _reid,
        );
        AdaptiveComponents.hideLoading();
        if (tt['code'] != null) {
          AdaptiveComponents.showToast(context, tt['msg']);
        } else {
          AdaptiveComponents.showToast(context, "sendSuccessTrans".tr);
          Navigator.of(context).pop(true);
        }
      } else {
        Map tt = await NForumService.postArticle(
          _toBoard,
          _titleController.text,
          NForumTextParser.stripEmojis(provider.controller.text),
          reId: _reid,
        );
        AdaptiveComponents.hideLoading();
        if (tt['code'] != null) {
          AdaptiveComponents.showToast(context, tt['msg']);
        } else {
          AdaptiveComponents.showToast(context, "sendSuccessTrans".tr);
          Navigator.popAndPushNamed(
            context,
            'board_page',
            arguments: BoardPageRouteArg(tt['board_name']),
          );
        }
      }
    }
  }

  Widget _buildPostForm(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Form(
          key: _formKey,
          autovalidate: false,
          child: Column(
            children: <Widget>[
              Container(
                child: Visibility(
                  visible: _reid == null,
                  child: TextFormField(
                    autocorrect: false,
                    style: TextStyle(
                      color: E().threadPageContentColor,
                    ),
                    controller: _titleController,
                    decoration: InputDecoration(
                      hintText: "titleTrans".tr,
                      hintStyle: TextStyle(
                        color: E().editPagePlaceholderColor,
                      ),
                    ),
                    validator: (v) {
                      return _reid != null ? null : (v.trim().length > 0 ? null : "titleTrans".tr + "nonBlankTrans".tr);
                    },
                  ),
                ),
              ),
              Expanded(
                child: Selector<PostArticleProvider, Tuple2<TextEditingController, FocusNode>>(
                  builder: (_, Tuple2 value, __) {
                    return TextFormField(
                      autocorrect: false,
                      style: TextStyle(
                        color: E().threadPageContentColor,
                      ),
                      controller: value.item1,
                      focusNode: value.item2,
                      maxLines: null,
                      scrollPadding: EdgeInsets.all(5),
                      expands: true,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration.collapsed(
                          hintText: "contentTrans".tr, hintStyle: TextStyle(color: E().editPagePlaceholderColor)),
                      validator: (v) {
                        return v.trim().length > 0 ? null : "contentTrans".tr + "nonBlankTrans".tr;
                      },
                    );
                  },
                  selector: (_, provider) {
                    return Tuple2(provider.controller, provider.focusNode);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
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

  Widget _buildToBoardName(String name, String desc) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        CircleAvatar(
          backgroundColor: BoardInfo.getBoardIconColor(name),
          child: Text(
            BoardInfo.getBoardCnShort(name, desc),
            style: TextStyle(
              color: E().editPageBackgroundColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(14.0),
          child: Text(
            desc,
            style: TextStyle(
              fontSize: 16,
              color: E().otherPagePrimaryTextColor,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildSelectBoard(BuildContext context) {
    return Expanded(
      child: CustomScrollView(
        slivers: <Widget>[
          SliverFixedExtentList(
            itemExtent: 40,
            delegate: SliverChildBuilderDelegate(
              (context0, index) {
                return Container(
                  height: 36,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          autocorrect: false,
                          textAlign: TextAlign.left,
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
                              suffixIcon: _search.length > 0
                                  ? CircleIconButton(
                                      size: 24,
                                      onPressed: () {
                                        _controller.clear();
                                      },
                                      icon: Icons.clear)
                                  : SizedBox.shrink(),
                              contentPadding: EdgeInsets.all(4),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: E().editPageBackgroundColor),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(0),
                              )),
                        ),
                      ),
                      Container(
                        color: E().editPageBackgroundColor,
                        child: IconButton(
                          icon: Icon(Icons.search, color: E().editPageButtonIconColor),
                          onPressed: () {
                            _onSearch();
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
              childCount: 1,
            ),
          ),
          SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount:
                  (favBoards?.board?.length ?? 0) == 0 ? 1 : (MediaQuery.of(context).size.shortestSide > 600 ? 4 : 2),
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
                          style: TextStyle(
                            fontSize: 16,
                            color: E().otherPagePrimaryTextColor,
                          ),
                        ),
                      )
                    : NonPaddingListTile(
                        onTap: () {
                          _toBoard = favBoards.board[index].name;
                          _toBoardDesc = favBoards.board[index].description;
                          _selectBoard = false;
                          _allowAtt = favBoards.board[index].allowAttachment ?? false;
                          if (mounted) {
                            setState(() {});
                          }
                        },
                        title: Row(
                          children: <Widget>[
                            CircleAvatar(
                              backgroundColor: BoardInfo.getBoardIconColor(favBoards.board[index].name),
                              child: Text(
                                favBoards.board[index].getBoardCnShort(),
                                style: TextStyle(
                                  color: E().editPageBackgroundColor,
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
                                        color: E().otherPagePrimaryTextColor,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      favBoards.board[index].threadsTodayCount == 0
                                          ? "noThreadTodayTrans".tr
                                          : (favBoards.board[index].threadsTodayCount == 1
                                              ? "newThreadTodayTrans"
                                                  .trArgs([favBoards.board[index].threadsTodayCount.toString()])
                                              : "newThreadsTodayTrans"
                                                  .trArgs([favBoards.board[index].threadsTodayCount.toString()])),
                                      style: TextStyle(
                                        color: E().otherPagePrimaryTextColor,
                                        fontSize: 14,
                                      ),
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
    );
  }

  Widget _buildContent(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Visibility(
            visible: !_updateMode && _reid == null,
            child: NonPaddingListTile(
              contentPadding: EdgeInsets.only(left: 16, right: 16, top: 0),
              onTap: () {
                _selectBoard = !_selectBoard;
                if (mounted) {
                  setState(() {});
                }
              },
              title: _toBoard == null
                  ? Text(
                      "selectBoard".tr,
                      style: TextStyle(color: E().otherPagePrimaryTextColor),
                    )
                  : _buildToBoardName(_toBoard, _toBoardDesc),
            ),
          ),
          Visibility(
            visible: _toBoard == 'IWhisper' && !_selectBoard && !_updateMode,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Checkbox(
                    value: _anonymous,
                    onChanged: (b) {
                      _anonymous = b;
                      NForumSpecs.setAnonymous(value: _anonymous);
                      if (mounted) {
                        setState(() {});
                      }
                    },
                  ),
                  Text(
                    "anonymous".tr,
                    style: TextStyle(
                      color: E().otherPagePrimaryTextColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          _selectBoard && !_updateMode && _reid == null ? _buildSelectBoard(context) : _buildPostForm(context),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              NForumTextParser.retrieveEmojis(_replyTail),
              style: TextStyle(fontSize: 14.0, color: E().otherPageSecondaryTextColor),
              maxLines: 6,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewThreadRow(AsyncSnapshot userSnapshot) {
    return Selector<PostArticleProvider, Tuple3<TextEditingController, FocusNode, List<Tuple2<String, int>>>>(
      builder: (_, Tuple3 value, __) {
        String content = value.item1.text;
        String title = '';
        if (_reid == null) {
          title = _titleController.text;
          if (_updateMode && _articleModel.position != 0) {
            title = '';
          }
        }
        return InkWell(
          highlightColor: E().editPageBackgroundColor.withOpacity(0.12),
          splashColor: BoardInfo.getBoardIconColor(_toBoard).withOpacity(0.15),
          onTap: () {},
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              ClickableAvatar(
                                radius: 18,
                                isWhisper: (userSnapshot.data?.id ?? "").startsWith("IWhisper"),
                                imageLink: userSnapshot.hasData
                                    ? NForumService.makeGetURL(userSnapshot.data.faceUrl ?? "")
                                    : null,
                                emptyUser: (_toBoard == 'IWhisper' && _anonymous)
                                    ? true
                                    : userSnapshot.hasData ? userSnapshot.data?.faceUrl == null : true,
                                onTap: null,
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      (_toBoard == 'IWhisper' && _anonymous)
                                          ? 'IWhisper#XXX'
                                          : userSnapshot.hasData ? userSnapshot.data?.id : "username",
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          color: (_toBoard == 'IWhisper' && _anonymous)
                                              ? E().otherUserIdColor
                                              : ConstColors.getUsernameColor(
                                                  userSnapshot.hasData ? userSnapshot.data?.gender : null)),
                                    ),
                                    Text(
                                      Helper.convTimestampToRelative(DateTime.now().millisecondsSinceEpoch),
                                      style: TextStyle(fontSize: 12.0, color: E().threadPageOtherTextColor),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Text(
                            NForumTextParser.getArticlePositionName(
                                _updateMode ? _articleModel.position : (_reid == null ? 0 : 9999)),
                            style: TextStyle(fontSize: 12.0, color: E().threadPageOtherTextColor),
                          ),
                        ],
                      ),
                      (title == null || title == "")
                          ? Container()
                          : Container(
                              padding: EdgeInsets.only(
                                top: 15,
                                bottom: 10,
                              ),
                              child: Text(
                                title,
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: E().threadPageTitleColor,
                                ),
                              ),
                            ),
                    ],
                  ),
                  subtitle: Container(
                    padding: (title == null || title == "") ? EdgeInsets.only(left: 45) : EdgeInsets.zero,
                    child: ParsedText.preview(
                      text: (content + _replyTail).trim().replaceAll(RegExp(r'\n+--\n*$'), '\n'),
                      uploads: value.item3.map<PreviewUpload>((e) => PreviewUpload(e.item1, e.item2)).toList(),
                      title: title,
                    ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Container(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          IconButton(
                            padding: EdgeInsets.all(0),
                            icon: Icon(Icons.thumb_up, color: E().threadPageVoteUpDownUnpickedColor),
                            iconSize: 24,
                            onPressed: () {},
                          ),
                          Text(
                            '0',
                            style: TextStyle(fontSize: 14.0, color: E().threadPageVoteUpDownNumberColor),
                          ),
                        ],
                      )),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          IconButton(
                            padding: EdgeInsets.all(0),
                            icon: Icon(Icons.thumb_down, color: E().threadPageVoteUpDownUnpickedColor),
                            iconSize: 24,
                            onPressed: () {},
                          ),
                          Text(
                            '0',
                            style: TextStyle(fontSize: 14.0, color: E().threadPageVoteUpDownNumberColor),
                          ),
                        ],
                      )),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
      selector: (_, provider) {
        return Tuple3(provider.controller, provider.focusNode, provider.attachList);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    List<Tuple2<String, int>> _attachList = [];
    List<int> _sizeList = [];
    int _totalSize = 0;
    if (_articleModel != null && _articleModel.attachment != null) {
      for (UploadedModel file in _articleModel.attachment.file) {
        if (file.thumbnailMiddle != "") {
          _attachList.add(Tuple2(
              NForumService.makeGetAttachmentURL(file.thumbnailMiddle),
              UploadedModelUploadedExtractor().getIsAudio(file)
                  ? 2
                  : (UploadedModelUploadedExtractor().getIsImage(file) ? 1 : 0)));
          int size = convertSizeString(file.size);
          _sizeList.add(size);
          _totalSize += size;
        }
      }
    }
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<PostArticleProvider>(
          create: (_) => PostArticleProvider(
            existingContent: _existingContent,
            attachList: _attachList,
            sizeList: _sizeList,
            totalSize: _totalSize,
          ),
        ),
      ],
      child: Obx(
        () => Scaffold(
          appBar: BYRAppBar(
            title: Text(
              _updateMode ? "edit".tr : _reid == null ? "postArticle".tr : "replyTrans".tr,
            ),
            actions: <Widget>[
              Consumer<PostArticleProvider>(
                builder: (_, provider, __) {
                  return FlatButton.icon(
                    icon: Icon(
                      Icons.compare,
                      color: E().editPageTopBarButtonColor,
                    ),
                    onPressed: () {
                      if (!_preview) {
                        FormState _form = _formKey.currentState as FormState;
                        if (_form != null && _form.validate()) {
                          _preview = !_preview;
                          if (mounted) {
                            setState(() {});
                          }
                        }
                      } else {
                        _preview = !_preview;
                        if (mounted) {
                          setState(() {});
                        }
                      }
                    },
                    label: Text(
                      _preview ? "close".tr + "preview".tr : "preview".tr,
                      style: TextStyle(
                        fontSize: 17,
                        color: E().topBarTitleNormalColor,
                      ),
                    ),
                  );
                },
              ),
              Consumer<PostArticleProvider>(
                builder: (_, provider, __) {
                  return FlatButton.icon(
                    icon: Icon(
                      Icons.send,
                      color: E().editPageTopBarButtonColor,
                    ),
                    onPressed: () {
                      _send(context, provider);
                    },
                    label: Text(
                      "submitTrans".tr,
                      style: TextStyle(
                        fontSize: 17,
                        color: E().topBarTitleNormalColor,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          backgroundColor: E().editPageBackgroundColor,
          body: _preview
              ? Visibility(
                  visible: _preview,
                  child: SingleChildScrollView(
                      child: FutureBuilder<UserModel>(
                    builder: (context, snapshot) => _buildPreviewThreadRow(snapshot),
                    future: SharedObjects.me,
                  )),
                )
              : Column(
                  children: <Widget>[
                    Expanded(
                      child: _buildContent(context),
                    ),
                    BottomToolBar(allowAttach: _allowAtt, getAudioP: getAudioPlayer),
                  ],
                ),
        ),
      ),
    );
  }
}

class PostPageRouteArg {
  final BoardModel board;
  final bool updateMode;
  final ThreadArticleModel articleModel;
  final int reid;
  final String existingContent;
  final String replyTail;

  PostPageRouteArg({
    this.board,
    this.updateMode = false,
    this.articleModel,
    this.reid,
    this.existingContent = '',
    this.replyTail = '',
  });
}
