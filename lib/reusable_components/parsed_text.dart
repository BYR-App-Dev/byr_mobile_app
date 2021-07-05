import 'package:byr_mobile_app/customizations/theme_controller.dart';
import 'package:byr_mobile_app/customizations/theme_manager.dart';
import 'package:byr_mobile_app/nforum/nforum_link_handler.dart';
import 'package:byr_mobile_app/nforum/nforum_text_parser.dart';
import 'package:byr_mobile_app/reusable_components/adaptive_components.dart';
import 'package:byr_mobile_app/reusable_components/audio_player_view.dart';
import 'package:byr_mobile_app/reusable_components/nforum_parsed_text.dart';
import 'package:byr_mobile_app/reusable_components/pic_swiper.dart';
import 'package:byr_mobile_app/reusable_components/refreshers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tuple/tuple.dart';

class ParsedText extends StatelessWidget {
  final String text;
  final List uploads;
  final String title;
  final bool isPreview;
  final UploadedExtractor uploadedExtractor;
  final Function tap;

  const ParsedText({
    Key key,
    this.text,
    this.uploads,
    this.title,
    this.isPreview,
    this.uploadedExtractor,
    this.tap,
  }) : super(key: key);

  ParsedText.uploaded({
    Key key,
    this.text,
    this.uploads,
    this.title,
    this.isPreview = false,
    this.tap,
  })  : uploadedExtractor = UploadedModelUploadedExtractor(),
        super(key: key);

  ParsedText.preview({
    Key key,
    this.text,
    this.uploads,
    this.title,
    this.isPreview = true,
    this.tap,
  })  : uploadedExtractor = PreviewUploadedExtractor(),
        super(key: key);

  Widget _imagePlaceHolder() {
    return Container(
      width: 150,
      height: 150,
      color: E().isThemeDarkStyle
          ? Color.fromARGB(
              255,
              E().threadPageBackgroundColor.red + 8,
              E().threadPageBackgroundColor.green + 9,
              E().threadPageBackgroundColor.blue + 10,
            )
          : Color.fromARGB(
              255,
              E().threadPageBackgroundColor.red - 10,
              E().threadPageBackgroundColor.green - 9,
              E().threadPageBackgroundColor.blue - 8,
            ),
      alignment: Alignment.center,
      child: Text(
        'BYR',
        style: TextStyle(
          color: E().threadPageQuoteColor,
          fontWeight: FontWeight.w600,
          fontSize: 50,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }

  WidgetSpanChildHandler imageAttachmentHandlerGenerator(BuildContext context) {
    WidgetSpanChildHandler ret = (int upId) {
      List<PicSwiperItem> _pics = [];
      for (var _item in uploads) {
        if (uploadedExtractor.getIsGroupShowable(_item) == true) {
          _pics.add(PicSwiperItem(picUrl: uploadedExtractor.getShowUrl(_item)));
        }
      }
      return GestureDetector(
        onTap: () {
          showGeneralDialog(
            barrierColor: Colors.black,
            barrierDismissible: false,
            transitionDuration: Duration(milliseconds: 200),
            barrierLabel: "PicDialog",
            pageBuilder: (c, _, __) {
              return PicSwiper(
                index: upId,
                pics: _pics,
              );
            },
            context: context,
          );
        },
        child: Center(
          child: CachedNetworkImage(
            alignment: Alignment.center,
            imageUrl: uploadedExtractor.getShowUrl(uploads[upId]),
            placeholder: (context, url) => _imagePlaceHolder(),
          ),
        ),
      );
    };
    return ret;
  }

  WidgetSpanChildHandler audioAttachmentHandlerGenerator(BuildContext context) {
    WidgetSpanChildHandler ret = (int upId) {
      return Container(
        child: Row(
          children: <Widget>[
            FlatButton(
              child: Icon(
                Icons.music_note,
                color: E().threadPageContentColor,
              ),
              onPressed: () {
                if (uploadedExtractor.getIsPreview(uploads[upId])) {
                  return;
                }
                AudioPlayerView.show(
                  context,
                );
              },
            ),
            FlatButton(
              child: Icon(
                Icons.play_circle_filled,
                color: E().threadPageContentColor,
              ),
              onPressed: () {
                if (uploadedExtractor.getIsPreview(uploads[upId])) {
                  return;
                }
                AudioPlayerView.setCurrentPlaying(
                  Tuple3(
                    title ?? "...",
                    uploadedExtractor.getAudioLoc(uploads[upId]),
                    uploadedExtractor.getIsAudioLocal(uploads[upId]),
                  ),
                  context,
                );
              },
            ),
            FlatButton(
              child: Icon(
                Icons.playlist_add,
                color: E().threadPageContentColor,
              ),
              onPressed: () {
                if (uploadedExtractor.getIsPreview(uploads[upId])) {
                  return;
                }
                AudioPlayerView.addMusic(
                  Tuple3(
                    title ?? "...",
                    uploadedExtractor.getAudioLoc(uploads[upId]),
                    uploadedExtractor.getIsAudioLocal(uploads[upId]),
                  ),
                  context,
                );
              },
            ),
          ],
        ),
      );
    };
    return ret;
  }

  WidgetSpanChildHandler themeAttachmentHandlerGenerator(BuildContext context) {
    WidgetSpanChildHandler ret = (int upId) {
      return FlatButton(
        child: Row(
          children: [
            Icon(
              Icons.style,
              color: E().threadPageContentColor,
            ),
            Text(
              uploadedExtractor.getFileName(uploads[upId]),
              style: TextStyle(
                color: E().threadPageContentColor,
              ),
            ),
          ],
        ),
        onPressed: () {
          AdaptiveComponents.showAlertDialog(context,
              title: "themeAdd".tr + uploadedExtractor.getFileName(uploads[upId]), onDismiss: (value) {
            if (value == AlertResult.confirm) {
              BYRThemeManager.instance()
                  .importOnlineTheme(uploadedExtractor.getShowUrl(uploads[upId]), null, BYRTheme.originLightTheme)
                  .then((succeeded) {
                if (succeeded) {
                  String currentThemeName = BYRThemeManager.instance().currentTheme.themeName;
                  BYRThemeManager.instance().turnTheme(currentThemeName);
                  AdaptiveComponents.showToast(context, "themeAdd".tr + "succeed".tr);
                } else {
                  AdaptiveComponents.showToast(context, "themeAdd".tr + "fail".tr);
                }
              }).catchError((handleError) {
                print(handleError);
                AdaptiveComponents.showToast(context, "themeAdd".tr + "fail".tr);
              });
            }
          });
        },
      );
    };
    return ret;
  }

  WidgetSpanChildHandler refresherAttachmentHandlerGenerator(BuildContext context) {
    WidgetSpanChildHandler ret = (int upId) {
      return FlatButton(
        child: Row(
          children: [
            Icon(
              Icons.slow_motion_video,
              color: E().threadPageContentColor,
            ),
            Text(
              uploadedExtractor.getFileName(uploads[upId]),
              style: TextStyle(
                color: E().threadPageContentColor,
              ),
            ),
          ],
        ),
        onPressed: () {
          AdaptiveComponents.showAlertDialog(context,
              title: "refresherAdd".tr + uploadedExtractor.getFileName(uploads[upId]), onDismiss: (value) {
            if (value == AlertResult.confirm) {
              BYRRefresherManager.instance()
                  .importOnlineRefresher(uploadedExtractor.getShowUrl(uploads[upId]), null)
                  .then((succeeded) {
                if (succeeded) {
                  AdaptiveComponents.showToast(context, "refresherAdd".tr + "succeed".tr);
                } else {
                  AdaptiveComponents.showToast(context, "refresherAdd".tr + "fail".tr);
                }
              }).catchError((handleError) {
                print(handleError);
                AdaptiveComponents.showToast(context, "refresherAdd".tr + "fail".tr);
              });
            }
          });
        },
      );
    };
    return ret;
  }

  WidgetSpanChildHandler otherAttachmentHandlerGenerator(BuildContext context) {
    WidgetSpanChildHandler ret = (int upId) {
      return Text("Please download on web");
    };
    return ret;
  }

  WidgetSpanExternalImageChildHandler externalImageHandlerGenerator(BuildContext context) {
    WidgetSpanExternalImageChildHandler ret = (String url) {
      return GestureDetector(
        onTap: () {
          showGeneralDialog(
            barrierColor: Colors.black,
            barrierDismissible: false,
            transitionDuration: Duration(milliseconds: 200),
            barrierLabel: "PicDialog",
            pageBuilder: (c, _, __) => PicSwiper(
              index: 0,
              pics: [PicSwiperItem(picUrl: url)],
            ),
            context: context,
          );
        },
        child: Center(
          child: CachedNetworkImage(
            alignment: Alignment.center,
            imageUrl: url,
            placeholder: (context, url) => _imagePlaceHolder(),
          ),
        ),
      );
    };
    return ret;
  }

  WidgetSpanExternalAudioChildHandler externalAudioHandlerGenerator(BuildContext context) {
    WidgetSpanExternalAudioChildHandler ret = (String url) {
      return Container(
        child: Row(
          children: <Widget>[
            FlatButton(
              child: Icon(
                Icons.music_note,
                color: E().threadPageContentColor,
              ),
              onPressed: () {
                AudioPlayerView.show(
                  context,
                );
              },
            ),
            FlatButton(
              child: Icon(
                Icons.play_circle_filled,
                color: E().threadPageContentColor,
              ),
              onPressed: () {
                AudioPlayerView.setCurrentPlaying(
                  Tuple3(
                    title ?? "...",
                    url,
                    false,
                  ),
                  context,
                );
              },
            ),
            FlatButton(
              child: Icon(
                Icons.playlist_add,
                color: E().threadPageContentColor,
              ),
              onPressed: () {
                AudioPlayerView.addMusic(
                  Tuple3(
                    title ?? "...",
                    url,
                    false,
                  ),
                  context,
                );
              },
            ),
          ],
        ),
      );
    };
    return ret;
  }

  WidgetSpanExternalAudioChildHandler externalVideoHandlerGenerator(BuildContext context) {
    WidgetSpanExternalAudioChildHandler ret = (String url) {
      return Container(
        child: Row(
          children: <Widget>[
            FlatButton(
              child: Icon(
                Icons.video_library,
                color: E().threadPageContentColor,
              ),
              onPressed: () {
                navigator.pushNamed("video_page", arguments: url);
              },
            ),
          ],
        ),
      );
    };
    return ret;
  }

  @override
  Widget build(BuildContext context) {
    return NForumParsedText(
      NForumTextParsingConfig(
        text.replaceAll("\r--\n", ""),
        uploads,
        title: title,
        tap: tap,
        isMDBackgroundDark: E().isThemeDarkStyle,
        byrLinkHandler: NForumLinkHandler.byrLinkHandler,
        webLinkHandler: NForumLinkHandler.webLinkHandler,
        contentColor: E().threadPageContentColor,
        quoteColor: E().threadPageQuoteColor,
        imageAttachmentWidget: imageAttachmentHandlerGenerator(context),
        audioAttachmentWidget: audioAttachmentHandlerGenerator(context),
        themeAttachmentWidget: themeAttachmentHandlerGenerator(context),
        refresherAttachmentWidget: refresherAttachmentHandlerGenerator(context),
        otherAttachmentWidget: otherAttachmentHandlerGenerator(context),
        externalImageWidget: externalImageHandlerGenerator(context),
        externalAudioWidget: externalAudioHandlerGenerator(context),
        externalVideoWidget: externalVideoHandlerGenerator(context),
        uploadedExtractor: uploadedExtractor,
      ),
    );
  }
}
