import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:byr_mobile_app/customizations/theme_controller.dart';
import 'package:byr_mobile_app/reusable_components/adaptive_components.dart';
import 'package:byr_mobile_app/reusable_components/biu_panel.dart';
import 'package:byr_mobile_app/reusable_components/emoticon_panel.dart';
import 'package:byr_mobile_app/reusable_components/post_article_provider.dart';
import 'package:byr_mobile_app/reusable_components/qqkg_url_retrieve_dialog.dart';
import 'package:byr_mobile_app/reusable_components/recorder_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class BottomToolBar extends StatelessWidget {
  final bool allowAttach;
  final AudioPlayer Function() getAudioP;
  const BottomToolBar({
    Key key,
    @required this.allowAttach,
    this.getAudioP,
  }) : super(key: key);

  _buildAttachArea() {
    return Selector<PostArticleProvider, bool>(
      builder: (context, _, __) {
        var attachList = Provider.of<PostArticleProvider>(context, listen: false).attachList;
        var friendlyFileSize = Provider.of<PostArticleProvider>(context, listen: false).friendlyFileSize;
        var canPost = Provider.of<PostArticleProvider>(context, listen: false).canPost;
        if (attachList.length == 0) return Container();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(
              height: 1,
              color: E().otherPageDividerColor,
            ),
            Container(height: 10),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '附件: ${attachList.length}/10 ',
                  ),
                  TextSpan(
                    text: '$friendlyFileSize/5M',
                    style: TextStyle(color: canPost ? E().editPageButtonTextColor : Colors.red),
                  ),
                ],
              ),
              style: TextStyle(
                color: E().editPageButtonTextColor,
                fontSize: 14,
              ),
            ),
            Container(height: 10),
            GridView.count(
              padding: EdgeInsets.all(0.0),
              crossAxisCount: 5,
              crossAxisSpacing: 5.0,
              mainAxisSpacing: 4.0,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: List.generate(
                attachList.length,
                (i) {
                  var mediaPath = attachList[i];
                  bool canDelete = true;
                  if (mediaPath.item2 == 1) {
                    ImageProvider imageProvider;
                    if (mediaPath.item1.contains('file://')) {
                      final file = File.fromUri(Uri.parse(mediaPath.item1));
                      imageProvider = FileImage(file);
                    } else {
                      imageProvider = NetworkImage(attachList[i].item1);
                      canDelete = false;
                    }
                    return Stack(
                      children: [
                        GestureDetector(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                const Radius.circular(5.0),
                              ),
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          onTap: () {
                            Provider.of<PostArticleProvider>(context, listen: false).insertImage(mediaPath);
                          },
                        ),
                        Visibility(
                          visible: canDelete,
                          child: Positioned(
                            right: 2,
                            top: 2,
                            child: GestureDetector(
                              child: Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.red,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 1.5,
                                    style: BorderStyle.solid,
                                  ),
                                ),
                                child: Icon(
                                  FontAwesomeIcons.times,
                                  color: Colors.white,
                                  size: 10,
                                ),
                              ),
                              onTap: () {
                                Provider.of<PostArticleProvider>(context, listen: false).deleteImage(mediaPath);
                              },
                            ),
                          ),
                        ),
                      ],
                    );
                  } else if (mediaPath.item2 == 2) {
                    bool isLocalAudio;
                    if (mediaPath.item1.contains('file://')) {
                      isLocalAudio = true;
                    } else {
                      isLocalAudio = false;
                      canDelete = false;
                    }
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            left: 2,
                            top: 2,
                            child: GestureDetector(
                              child: Container(
                                child: Icon(Icons.audiotrack),
                              ),
                              onTap: () async {
                                if (getAudioP != null) {
                                  var audioPlayer = getAudioP();
                                  if (audioPlayer != null) {
                                    await audioPlayer.stop();
                                    await audioPlayer.play(mediaPath.item1, isLocal: isLocalAudio);
                                  }
                                }
                              },
                            ),
                          ),
                          Positioned(
                            right: 2,
                            bottom: 2,
                            child: GestureDetector(
                              child: Container(
                                child: Icon(Icons.add_to_photos),
                              ),
                              onTap: () {
                                Provider.of<PostArticleProvider>(context, listen: false).insertImage(mediaPath);
                              },
                            ),
                          ),
                          Positioned(
                            left: 2,
                            bottom: 2,
                            child: GestureDetector(
                              child: Container(
                                child: Icon(Icons.stop),
                              ),
                              onTap: () async {
                                if (getAudioP != null) {
                                  var audioPlayer = getAudioP();
                                  if (audioPlayer != null) {
                                    await audioPlayer.stop();
                                  }
                                }
                              },
                            ),
                          ),
                          Visibility(
                            visible: canDelete,
                            child: Positioned(
                              right: 2,
                              top: 2,
                              child: GestureDetector(
                                child: Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.red,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 1.5,
                                      style: BorderStyle.solid,
                                    ),
                                  ),
                                  child: Icon(
                                    FontAwesomeIcons.times,
                                    color: Colors.white,
                                    size: 10,
                                  ),
                                ),
                                onTap: () {
                                  Provider.of<PostArticleProvider>(context, listen: false).deleteImage(mediaPath);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ],
        );
      },
      selector: (_, provider) {
        return provider.attachChange;
      },
    );
  }

  _buildFuncButton(
    IconData iconData,
    String name, {
    bool enable = true,
    VoidCallback onTap,
  }) {
    var color = enable ? E().editPageButtonIconColor : E().editPageButtonIconColor.withOpacity(0.5);
    return GestureDetector(
      child: Container(
        width: 50,
        child: Column(
          children: <Widget>[
            Icon(
              iconData,
              size: 28,
              color: color,
            ),
            Container(height: 5),
            Text(
              name,
              style: TextStyle(
                color: color,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
      onTap: enable ? onTap : null,
    );
  }

  _buildButtonArea(PostArticleProvider provider, BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _buildFuncButton(
              FontAwesomeIcons.smile,
              "emoticon".tr,
              onTap: () {
                provider.toggleEmoticonPanel();
              },
            ),
            _buildFuncButton(
              Icons.text_format,
              'BIU~',
              onTap: () {
                provider.toggleBiuPanel();
              },
            ),
            _buildFuncButton(
              FontAwesomeIcons.fileImage,
              "gallery".tr,
              enable: allowAttach && provider.attachList.length < 10,
              onTap: () async {
                provider.hideKeyBoard();
                AdaptiveComponents.showBottomSheet(
                  context,
                  ["camera".tr, "gallery".tr],
                  textStyle: TextStyle(fontSize: 17, color: E().dialogButtonTextColor),
                  onItemTap: (int index) async {
                    provider.hideKeyBoard();
                    if (index == 0) {
                      var image = await ImagePicker.pickImage(source: ImageSource.camera);
                      if (image == null) {
                        return;
                      }
                      var size = await image.length();
                      provider.addAttach(image.uri.toString(), 1, size);
                    }
                    if (index == 1) {
                      var image = await ImagePicker.pickImage(source: ImageSource.gallery);
                      if (image == null) {
                        return;
                      }
                      var size = await image.length();
                      provider.addAttach(image.uri.toString(), 1, size);
                    }
                  },
                );
              },
            ),
            _buildFuncButton(
              FontAwesomeIcons.fileAudio,
              "audioFileTrans".tr,
              enable: allowAttach && provider.attachList.length < 10,
              onTap: () async {
                provider.hideKeyBoard();
                AdaptiveComponents.showBottomSheet(
                  context,
                  ["audioRecordTrans".tr, "audioFileTrans".tr, "外部音频"],
                  textStyle: TextStyle(fontSize: 17, color: E().dialogButtonTextColor),
                  onItemTap: (int index) async {
                    provider.hideKeyBoard();
                    if (index == 0) {
                      var path = await showDialog(
                          barrierDismissible: false, context: context, builder: (context) => RecorderDialog());
                      if (path == null) {
                        return;
                      }
                      File audioFile = File(path);
                      if (audioFile == null) {
                        return;
                      }
                      var size = await audioFile.length();
                      AdaptiveComponents.showAlertDialog(
                        context,
                        content: "audioPostWarning".tr,
                        onDismiss: (value) {
                          if (value == AlertResult.confirm) {
                            provider.addAttach(audioFile.uri.toString(), 2, size);
                          }
                        },
                      );
                    }
                    if (index == 1) {
                      File audioFile = await FilePicker.getFile(
                        type: FileType.custom,
                        allowedExtensions: ['mp3', 'm4a'],
                      );
                      if (audioFile == null) {
                        return;
                      }
                      var size = await audioFile.length();
                      AdaptiveComponents.showAlertDialog(
                        context,
                        content: "audioPostWarning".tr,
                        onDismiss: (value) {
                          if (value == AlertResult.confirm) {
                            provider.addAttach(audioFile.uri.toString(), 2, size);
                          }
                        },
                      );
                    }
                    if (index == 2) {
                      String qqkgUrl =
                          await showDialog(context: context, builder: (context) => QQKGURLRetrieveDialog());
                      if (qqkgUrl == null) {
                        return;
                      }
                      provider.insertQQKGURL(qqkgUrl);
                    }
                  },
                );
              },
            ),
            _buildFuncButton(
              FontAwesomeIcons.keyboard,
              "close".tr,
              onTap: () {
                provider.dismissKeyBoard();
              },
            ),
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Visibility(
            visible: allowAttach,
            child: Container(
              color: E().editPageBackgroundColor,
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: _buildAttachArea(),
            ),
          ),
          Container(
            color: E().editPageBackgroundColor,
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Consumer<PostArticleProvider>(
              builder: (context, provider, _) {
                return _buildButtonArea(provider, context);
              },
            ),
          ),
          Selector<PostArticleProvider, bool>(
            builder: (context, emoticonIsShow, __) {
              if (!emoticonIsShow) return Container();
              return EmoticonPanel(
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
                  Provider.of<PostArticleProvider>(context, listen: false).insertEmoticon(emoticon);
                },
              );
            },
            selector: (_, provider) {
              return provider.emoticonIsShow;
            },
          ),
          // Selector<PostArticleProvider, bool>(
          //   builder: (context, colorIsShow, __) {
          //     if (!colorIsShow) return Container();
          //     return ColorPanel(
          //       onCancelTap: () {
          //         Provider.of<PostArticleProvider>(context, listen: false)
          //             .dismissColorPanel();
          //       },
          //       onConfirmTap: (Color pickedColor) {
          //         Provider.of<PostArticleProvider>(context, listen: false)
          //             .dismissColorPanel();
          //         Provider.of<PostArticleProvider>(context, listen: false)
          //             .insertColor(pickedColor);
          //       },
          //     );
          //   },
          //   selector: (_, provider) {
          //     return provider.colorIsShow;
          //   },
          // ),
          Selector<PostArticleProvider, bool>(
            builder: (context, biuIsShow, __) {
              if (!biuIsShow) return Container();
              return BiuPanel(
                onCancelTap: () {
                  Provider.of<PostArticleProvider>(context, listen: false).dismissBiuPanel();
                },
                onConfirmColorTap: (Color pickedColor) {
                  // Provider.of<PostArticleProvider>(context, listen: false)
                  //     .dismissColorPanel();
                  Provider.of<PostArticleProvider>(context, listen: false).insertColor(pickedColor);
                },
                onConfirmBiuTap: (String leftText, String rightText) {
                  Provider.of<PostArticleProvider>(context, listen: false).insertBiu(leftText, rightText);
                },
              );
            },
            selector: (_, provider) {
              return provider.biuIsShow;
            },
          ),
        ],
      ),
    );
  }
}
