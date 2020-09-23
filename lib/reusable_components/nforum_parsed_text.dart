import 'dart:math' as math;

import 'package:byr_mobile_app/customizations/theme_controller.dart';
import 'package:byr_mobile_app/nforum/nforum_text_parser.dart';
import 'package:byr_mobile_app/pages/pages.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

typedef bool BYRLinkHandler(String link);
typedef bool WebLinkHandler(String link);
typedef Widget WidgetSpanChildHandler(int upId);
typedef Widget WidgetSpanExternalImageChildHandler(String link);

class NForumTextParsingConfig {
  final String text;
  final List uploads;
  final UploadedExtractor uploadedExtractor;
  final String title;
  final bool isMDBackgroundDark;
  final BYRLinkHandler byrLinkHandler;
  final WebLinkHandler webLinkHandler;
  final Color contentColor;
  final Color quoteColor;
  final WidgetSpanChildHandler imageAttachmentWidget;
  final WidgetSpanExternalImageChildHandler externalImageWidget;
  final WidgetSpanChildHandler audioAttachmentWidget;
  final WidgetSpanChildHandler themeAttachmentWidget;
  final WidgetSpanChildHandler refresherAttachmentWidget;
  final WidgetSpanChildHandler otherAttachmentWidget;

  NForumTextParsingConfig(
    this.text,
    this.uploads, {
    this.uploadedExtractor,
    this.title,
    this.isMDBackgroundDark,
    this.byrLinkHandler,
    this.webLinkHandler,
    this.contentColor,
    this.quoteColor,
    this.imageAttachmentWidget,
    this.externalImageWidget,
    this.audioAttachmentWidget,
    this.themeAttachmentWidget,
    this.refresherAttachmentWidget,
    this.otherAttachmentWidget,
  });

  NForumTextParsingConfig.uploaded(
    this.text,
    this.uploads, {
    this.title,
    this.isMDBackgroundDark,
    this.byrLinkHandler,
    this.webLinkHandler,
    this.contentColor,
    this.quoteColor,
    this.imageAttachmentWidget,
    this.externalImageWidget,
    this.audioAttachmentWidget,
    this.themeAttachmentWidget,
    this.refresherAttachmentWidget,
    this.otherAttachmentWidget,
  }) : uploadedExtractor = UploadedModelUploadedExtractor();

  NForumTextParsingConfig.preview(
    this.text,
    this.uploads, {
    this.title,
    this.isMDBackgroundDark,
    this.byrLinkHandler,
    this.webLinkHandler,
    this.contentColor,
    this.quoteColor,
    this.imageAttachmentWidget,
    this.externalImageWidget,
    this.audioAttachmentWidget,
    this.themeAttachmentWidget,
    this.refresherAttachmentWidget,
    this.otherAttachmentWidget,
  }) : uploadedExtractor = PreviewUploadedExtractor();
}

class NForumParsedText extends StatelessWidget {
  final NForumTextParsingConfig config;
  NForumParsedText(
    this.config,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _makeText(this.config),
    );
  }

  static TextStyle bbPlain(NForumTextParsingConfig parsingConfig) => TextStyle(
        color: parsingConfig.contentColor,
        fontStyle: FontStyle.normal,
        fontSize: 16,
        fontWeight: FontWeight.normal,
        height: 1.5,
        decoration: TextDecoration.none,
      );

  static Map<String, int> bbCode = {
    "b": 1,
    "i": 1,
    "u": 1,
    "size": 1,
    "color": 1,
    "mp3": 1,
  };

  static RegExp bbPattern = RegExp(r'\[(.+?)(=.*?)?\]((?:.|[\n\r])*?)\[\/\1\]');
  static RegExp emPattern = RegExp(r'\[(em.*?)\]');
  static RegExp byrPattern = RegExp(r"(?:http(s)?:\/\/)(bbs(6?)|m)\.byr\.cn\/\S+");
  static RegExp byrStartPattern = RegExp(r"^(?:http(s)?:\/\/)(bbs(6?)|m)\.byr\.cn\/.+$");
  static RegExp urlPattern = RegExp(r"(?:http(s)?:\/\/)[\w-]+(?:\.[\w-]+)+[\w\-\._~:/?#[\]@!\$&'`\*\+%,;=.]+");
  static RegExp threadPattern = RegExp(r'article\/(\w+)\/(\d+)');
  static RegExp betPattern = RegExp(r'bet\/view\/(\d+)');
  static RegExp votePattern = RegExp(r'vote\/view\/(\d+)');
  static RegExp boardPattern = RegExp(r'board\/(\w+)$');
  static RegExp emojiPattern = RegExp(r'\[bbsemoji([0-9|,]*?)\]');
  static RegExp quotePattern = RegExp(r'【 ?在.*的大作中提到: ?】 ?(\n:.*)*');

  static String _stripText(String str) {
    var strs = str;
    var bb = [
      r'\/?b',
      r'\/?i',
      r'\/?u',
      r'size=.*?',
      r'\/size',
      r'color=.*?',
      r'\/color',
      r'\/?md',
      r'em.*?',
      r'upload=.*?',
      r'\/upload',
    ];

    RegExp rg = RegExp(r'\[(.*?)\]');

    var rgm = rg.firstMatch(strs);

    if (rgm != null && rgm.group(1) != null) {
      for (final b in bb) {
        var rgmm = RegExp(b).firstMatch(rgm.group(1));
        if (rgmm != null) {
          return strs.substring(0, rgm.start) + _stripText(strs.substring(rgm.end));
        }
      }
      return strs.substring(0, rgm.end) + _stripText(strs.substring(rgm.end));
    }
    return strs;
  }

  static String stripEmojis(String str) {
    return NForumTextParser.stripEmojis(str);
  }

  static _retrieveEmojis(String str) {
    return NForumTextParser.retrieveEmojis(str);
  }

  static String _computeEmojiStr(String str) {
    return NForumTextParser.computeEmojiStr(str);
  }

  static TextStyle _makeStyle(TextStyle st, String sts, [String arg]) {
    var rst;
    switch (sts) {
      case "b":
        rst = TextStyle(
          color: st.color,
          fontStyle: st.fontStyle,
          fontSize: st.fontSize,
          fontWeight: FontWeight.bold,
          decoration: st.decoration,
        );
        break;
      case "i":
        rst = TextStyle(
          color: st.color,
          fontStyle: FontStyle.italic,
          fontSize: st.fontSize,
          fontWeight: st.fontWeight,
          decoration: st.decoration,
        );
        break;
      case "u":
        rst = TextStyle(
          color: st.color,
          fontStyle: st.fontStyle,
          fontSize: st.fontSize,
          fontWeight: st.fontWeight,
          decoration: TextDecoration.underline,
        );
        break;
      case "size":
        rst = TextStyle(
          color: st.color,
          fontStyle: st.fontStyle,
          fontSize: (double.tryParse(arg) ?? ((st.fontSize - 16) / 1 + 1) - 1) * 1 + 16,
          fontWeight: st.fontWeight,
          decoration: st.decoration,
        );
        break;
      case "color":
        rst = TextStyle(
          color: Color(int.tryParse("0xFF" + arg.substring(1)) ?? st.color.value),
          fontStyle: st.fontStyle,
          fontSize: st.fontSize,
          fontWeight: st.fontWeight,
          decoration: st.decoration,
        );
        break;
      case "url":
        rst = TextStyle(
          color: Colors.blueAccent[700],
          fontStyle: st.fontStyle,
          fontSize: st.fontSize,
          fontWeight: st.fontWeight,
          decoration: TextDecoration.underline,
          decorationColor: Colors.blue,
        );
        break;
      case "byr":
        Gradient gradient = LinearGradient(
          colors: [
            Color(0xff000000 + 0x00c0ff),
            Color(0xff000000 + 0x0072ff),
          ],
          tileMode: TileMode.mirror,
        );
        Shader shader = gradient.createShader(
          Rect.fromLTWH(0, 0, 56, 40),
        );
        rst = TextStyle(
          fontStyle: st.fontStyle,
          fontSize: st.fontSize,
          fontWeight: st.fontWeight,
          decoration: TextDecoration.underline,
          decorationColor: Colors.blue,
          foreground: Paint()..shader = shader,
        );
        break;
      case "mp3":
        rst = TextStyle(
          color: st.color,
          fontStyle: st.fontStyle,
          fontSize: st.fontSize,
          fontWeight: st.fontWeight,
          decoration: st.decoration,
        );
        break;
      default:
        rst = TextStyle(
          color: st.color,
          fontStyle: FontStyle.normal,
          fontSize: st.fontSize,
          fontWeight: st.fontWeight,
          decoration: st.decoration,
        );
        break;
    }
    return rst;
  }

  static InlineSpan _getImageAttachmentSpan(NForumTextParsingConfig parsingConfig, int upId) {
    return WidgetSpan(
      child: parsingConfig.imageAttachmentWidget(upId),
    );
  }

  static InlineSpan _getAudioAttachmentSpan(NForumTextParsingConfig parsingConfig, int upId) {
    return WidgetSpan(
      child: parsingConfig.audioAttachmentWidget(upId),
    );
  }

  static InlineSpan _getThemeAttachmentSpan(NForumTextParsingConfig parsingConfig, int upId) {
    return WidgetSpan(
      child: parsingConfig.themeAttachmentWidget(upId),
    );
  }

  static InlineSpan _getRefresherAttachmentSpan(NForumTextParsingConfig parsingConfig, int upId) {
    return WidgetSpan(
      child: parsingConfig.refresherAttachmentWidget(upId),
    );
  }

  static InlineSpan _getOtherAttachmentSpan(NForumTextParsingConfig parsingConfig, int upId) {
    return WidgetSpan(
      child: parsingConfig.otherAttachmentWidget(upId),
    );
  }

  static List<InlineSpan> getAttachmentSpan(NForumTextParsingConfig parsingConfig, String str, TextStyle defT,
      GestureRecognizer rec, int upId, RegExpMatch m) {
    bool isImg = parsingConfig.uploadedExtractor.getIsImage(parsingConfig.uploads[upId]);
    bool isAudio = parsingConfig.uploadedExtractor.getIsAudio(parsingConfig.uploads[upId]);
    bool isTheme = parsingConfig.uploadedExtractor.getIsTheme(parsingConfig.uploads[upId]);
    bool isRefresher = parsingConfig.uploadedExtractor.getIsRefresher(parsingConfig.uploads[upId]);

    return [
      TextSpan(
        children: _bbText(parsingConfig, str.substring(0, m.start) + "\n", defT, rec),
        recognizer: rec,
      ),
      if (isImg)
        _getImageAttachmentSpan(parsingConfig, upId)
      else if (isAudio)
        _getAudioAttachmentSpan(parsingConfig, upId)
      else if (isTheme)
        _getThemeAttachmentSpan(parsingConfig, upId)
      else if (isRefresher)
        _getRefresherAttachmentSpan(parsingConfig, upId)
      else
        _getOtherAttachmentSpan(parsingConfig, upId),
      TextSpan(
        children: _bbText(parsingConfig, str.substring(m.end), defT, rec),
        recognizer: rec,
      ),
    ];
  }

  static List<InlineSpan> _quoteTextSpan(
      NForumTextParsingConfig parsingConfig, String str, TextStyle defT, GestureRecognizer rec, RegExpMatch quote) {
    return [
      TextSpan(
        children: _bbText(parsingConfig, str.substring(0, quote.start).trim(), defT, rec),
        recognizer: rec,
      ),
      WidgetSpan(
        child: Container(
          margin: EdgeInsets.only(top: 8.0),
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
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Transform.rotate(
                  angle: math.pi,
                  child: Icon(
                    Icons.format_quote,
                    color: parsingConfig.quoteColor,
                  ),
                ),
              ),
              Expanded(
                child: Container(
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
                  padding: EdgeInsets.only(top: 8.0, left: 0, bottom: 8, right: 8),
                  child: Text(
                    _stripText(_retrieveEmojis(str.substring(quote.start, quote.end))),
                    style: defT.copyWith(
                      color: parsingConfig.quoteColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      TextSpan(
        children: _bbText(parsingConfig, str.substring(quote.end), defT, rec),
        recognizer: rec,
      ),
    ];
  }

  static List<InlineSpan> _emTextSpan(
      NForumTextParsingConfig parsingConfig, String str, TextStyle defT, GestureRecognizer rec, RegExpMatch mm) {
    String n = mm.group(1).substring(2, 3);
    double sz = (n == 'a' || n == 'b' || n == 'c') ? 50 : 19;
    return [
      TextSpan(
          children: _bbText(
            parsingConfig,
            str.substring(0, mm.start),
            defT,
            rec,
          ),
          recognizer: rec),
      WidgetSpan(
          child: Image.asset(
        'resources/em/' + mm.group(1) + '.gif',
        width: sz,
        height: sz,
      )),
      TextSpan(
        children: _bbText(parsingConfig, str.substring(mm.end), defT, rec),
        recognizer: rec,
      ),
    ];
  }

  static List<InlineSpan> _bbText(
      NForumTextParsingConfig parsingConfig, String str, TextStyle defT, GestureRecognizer rec) {
    var t = defT;
    var quote = quotePattern.firstMatch(str);
    if (quote != null) {
      return _quoteTextSpan(parsingConfig, str, defT, rec, quote);
    }
    var m = bbPattern.firstMatch(str);
    if (m != null) {
      var gar = m.group(2);
      var s = m.group(3);
      if (bbCode[m.group(1)] != null) {
        t = _makeStyle(defT, m.group(1), gar != null ? gar.substring(1) : null);
      } else {
        if (m.group(1) == 'upload' &&
            gar != null &&
            gar.length >= 2 &&
            int.tryParse(gar.substring(1)) != null &&
            int.tryParse(gar.substring(1)) <= parsingConfig.uploads.length &&
            (s == null || s == '')) {
          var upId = int.tryParse(gar.substring(1)) - 1;
          if (parsingConfig.uploads[upId].used) {
            return [
              TextSpan(
                children: _bbText(parsingConfig, str.substring(0, m.start) + "\n", defT, rec),
                recognizer: rec,
              ),
              TextSpan(
                text: str.substring(m.start, m.end),
                style: defT,
              ),
              TextSpan(
                children: _bbText(parsingConfig, str.substring(m.end), defT, rec),
                recognizer: rec,
              ),
            ];
          }
          parsingConfig.uploads[upId].used = true;
          return getAttachmentSpan(parsingConfig, str, defT, rec, upId, m);
        } else if (m.group(1) == 'img' && gar != null && gar.length >= 2) {
          var upAddr = gar.substring(1);
          return [
            TextSpan(
              children: _bbText(parsingConfig, str.substring(0, m.start) + "\n", defT, rec),
              recognizer: rec,
            ),
            WidgetSpan(
              child: parsingConfig.externalImageWidget(upAddr),
            ),
            TextSpan(
              children: _bbText(parsingConfig, str.substring(m.end), defT, rec),
              recognizer: rec,
            ),
          ];
        } else if (m.group(1) == 'url' && gar != null && gar.length >= 2 && (s != null && s != '')) {
          String nStr = gar != null ? gar.substring(1) : '';
          var mm = byrStartPattern.firstMatch(nStr);
          if (mm != null) {
            return [
              TextSpan(
                children: _bbText(parsingConfig, str.substring(0, m.start), defT, rec),
                recognizer: rec,
              ),
              TextSpan(
                text: s,
                style: _makeStyle(defT, 'byr'),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    parsingConfig.byrLinkHandler(nStr.substring(mm.start, mm.end));
                  },
              ),
              TextSpan(
                children: _bbText(parsingConfig, str.substring(m.end), defT, rec),
                recognizer: rec,
              ),
            ];
          } else {
            return [
              TextSpan(
                children: _bbText(
                  parsingConfig,
                  str.substring(0, m.start),
                  defT,
                  rec,
                ),
                recognizer: rec,
              ),
              TextSpan(
                text: s,
                style: _makeStyle(defT, 'url'),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    parsingConfig.webLinkHandler(gar != null ? gar.substring(1) : '');
                  },
              ),
              TextSpan(
                children: _bbText(
                  parsingConfig,
                  str.substring(m.end),
                  defT,
                  rec,
                ),
                recognizer: rec,
              ),
            ];
          }
        }
      }
      return [
        TextSpan(
          children: _bbText(parsingConfig, str.substring(0, m.start), defT, rec),
          recognizer: rec,
        ),
        TextSpan(
          children: _bbText(
            parsingConfig,
            (s ?? ''),
            t,
            TapGestureRecognizer()
              ..onTap = () {
                parsingConfig.webLinkHandler(gar != null ? gar.substring(1) : null);
              },
          ),
          recognizer: rec,
        ),
        TextSpan(
          children: _bbText(parsingConfig, str.substring(m.end), defT, rec),
          recognizer: rec,
        ),
      ];
    } else {
      var mm = emPattern.firstMatch(str);
      if (mm != null) {
        return _emTextSpan(parsingConfig, str, defT, rec, mm);
      } else {
        var mm = byrPattern.firstMatch(str);
        if (mm != null) {
          return [
            TextSpan(children: _bbText(parsingConfig, str.substring(0, mm.start), defT, rec), recognizer: rec),
            TextSpan(
              text: str.substring(mm.start, mm.end),
              style: _makeStyle(defT, 'byr'),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  parsingConfig.byrLinkHandler(str.substring(mm.start, mm.end));
                },
            ),
            TextSpan(
              children: _bbText(parsingConfig, str.substring(mm.end), defT, rec),
              recognizer: rec,
            ),
          ];
        } else {
          var mm = urlPattern.firstMatch(str);
          if (mm != null) {
            return [
              TextSpan(
                  children: _bbText(
                    parsingConfig,
                    str.substring(0, mm.start),
                    defT,
                    rec,
                  ),
                  recognizer: rec),
              TextSpan(
                text: str.substring(mm.start, mm.end),
                style: _makeStyle(defT, 'url'),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    parsingConfig.webLinkHandler(str.substring(mm.start, mm.end));
                  },
              ),
              TextSpan(
                children: _bbText(parsingConfig, str.substring(mm.end), defT, rec),
                recognizer: rec,
              ),
            ];
          }
          return [TextSpan(text: str, style: defT, recognizer: rec)];
        }
      }
    }
  }

  static List<Widget> _buildText(NForumTextParsingConfig parsingConfig, String strn) {
    var str = strn;
    var m = RegExp(r'\[md\]((?:.|[\n\r])+?)\[\/md\]').firstMatch(str);
    if (m != null) {
      List<Widget> richTextWidgets = [
        Text.rich(
          TextSpan(
            children: _bbText(parsingConfig, str.substring(0, m.start), bbPlain(parsingConfig), null),
          ),
          strutStyle: StrutStyle(height: 2),
        ),
      ];
      richTextWidgets.add(Theme(
          data: parsingConfig.isMDBackgroundDark ? ThemeData.dark() : ThemeData.light(),
          child: MarkdownBody(
            data: m.group(1),
            onTapLink: (link) {
              if (!parsingConfig.byrLinkHandler(link)) {
                parsingConfig.webLinkHandler(link);
              }
            },
          )));
      richTextWidgets.addAll(_buildText(parsingConfig, str.substring(m.end)));
      return richTextWidgets;
    } else {
      return [
        Text.rich(
          TextSpan(
            children: _bbText(parsingConfig, str, bbPlain(parsingConfig), null),
          ),
          strutStyle: StrutStyle(height: 2),
        ),
      ];
    }
  }

  static List<Widget> _makeText(NForumTextParsingConfig parsingConfig) {
    var str = _computeEmojiStr(parsingConfig.text).trim().replaceAll(RegExp(r'\n+--\n*$'), '\n');
    for (int i = 0; i < parsingConfig.uploads.length; ++i) {
      parsingConfig.uploads[i].used = false;
    }
    List<Widget> richTextWidgets = _buildText(parsingConfig, str);
    String uploadsRest = '';
    for (int i = 0; i < parsingConfig.uploads.length; ++i) {
      if (parsingConfig.uploads[i].used == false) {
        uploadsRest += "[upload=${i + 1}][/upload]\n";
      }
    }
    if (uploadsRest != '') {
      richTextWidgets.addAll([
        Text.rich(
          TextSpan(
            children: _bbText(parsingConfig, "\n" + uploadsRest, bbPlain(parsingConfig), null),
          ),
          strutStyle: StrutStyle(height: 2),
        ),
      ]);
    }
    return richTextWidgets;
  }
}
