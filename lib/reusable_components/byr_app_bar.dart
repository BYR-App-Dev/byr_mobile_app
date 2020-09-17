import 'package:byr_mobile_app/customizations/board_info.dart';
import 'package:byr_mobile_app/customizations/theme_controller.dart';
import 'package:byr_mobile_app/local_objects/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tinycolor/tinycolor.dart';

class BYRAppBar extends StatefulWidget implements PreferredSizeWidget {
  BYRAppBar({
    this.boardName,
    this.leading,
    this.title,
    this.actions,
    this.flexibleSpace,
    this.elevation,
    this.backgroundColor,
    this.brightness,
    this.iconTheme,
    this.textTheme,
    this.centerTitle,
  }) : assert(elevation == null || elevation >= 0.0);
  final String boardName;
  final Widget leading;
  final Widget title;
  final List<Widget> actions;
  final Widget flexibleSpace;
  final double elevation;
  final Color backgroundColor;
  final Brightness brightness;
  final IconThemeData iconTheme;
  final TextTheme textTheme;
  final bool centerTitle;

  @override
  _BYRAppBarState createState() => _BYRAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(48);
}

class _BYRAppBarState extends State<BYRAppBar> {
  @override
  Widget build(BuildContext context) {
    String style = LocalStorage.getAppBarStyle();
    bool centerTitle = style[0] == '1';
    bool colorfulTitle = style[1] == '1';
    bool colorfulBg = style[2] == '1';
    return AppBar(
      leading: widget.leading,
      title: DefaultTextStyle(
        style: TextStyle(
          color: colorfulTitle && widget.boardName != null
              ? BoardInfo.getBoardColor(widget.boardName)
              : (colorfulBg && widget.boardName != null ? Colors.white : E().topBarTitleNormalColor.lighten(10)),
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
        child: widget.title ?? Container(),
      ),
      actions: widget.actions,
      flexibleSpace: widget.flexibleSpace,
      elevation: widget.elevation ?? 0.5,
      backgroundColor: widget.backgroundColor ??
          (colorfulBg && widget.boardName != null
              ? BoardInfo.getBoardColor(widget.boardName)
              : E().topBarBackgroundColor),
      brightness: widget.brightness ?? (!E().isThemeDarkStyle ? Brightness.light : Brightness.dark),
      iconTheme: widget.iconTheme ??
          (colorfulTitle && widget.boardName != null
              ? IconThemeData(
                  color: BoardInfo.getBoardColor(widget.boardName),
                )
              : IconThemeData(
                  color: colorfulBg && widget.boardName != null ? Colors.white : E().topBarTitleNormalColor,
                )),
      centerTitle: widget.centerTitle ?? centerTitle,
    );
  }
}

class AppBarChoosePanel extends StatefulWidget {
  @override
  _AppBarChoosePanelState createState() => _AppBarChoosePanelState();
}

class _AppBarChoosePanelState extends State<AppBarChoosePanel> {
  String _initStyle;
  bool _centerTitle;
  bool _colorfulTitle;
  bool _colorfulBg;

  _saveConfig() {
    LocalStorage.setAppBarStyle('${_centerTitle ? '1' : '0'}${_colorfulTitle ? '1' : '0'}${_colorfulBg ? '1' : '0'}');
    setState(() {});
  }

  @override
  void initState() {
    _initStyle = LocalStorage.getAppBarStyle();
    _centerTitle = _initStyle[0] == '1';
    _colorfulTitle = _initStyle[1] == '1';
    _colorfulBg = _initStyle[2] == '1';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = TextStyle(
      fontSize: 16,
      color: E().settingItemCellMainColor,
    );
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 10),
            child: Text(
              "appBarStyle".tr,
              style: textStyle.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: BYRAppBar(
              boardName: 'Friends',
              title: Text(
                "threadTrans".tr,
              ),
              actions: <Widget>[
                IconButton(
                  padding: EdgeInsets.all(0.0),
                  icon: Icon(
                    Icons.star_border,
                    size: 28,
                  ),
                  onPressed: () {},
                ),
                IconButton(
                  padding: EdgeInsets.all(0.0),
                  icon: Icon(
                    Icons.more_horiz,
                    size: 28,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          Container(
            height: 10,
          ),
          Row(
            children: <Widget>[
              Expanded(
                  child: Text(
                "titleAlignLeft".tr,
                style: textStyle,
              )),
              Switch(
                  value: !_centerTitle,
                  onChanged: (_) {
                    _centerTitle = !_centerTitle;
                    _saveConfig();
                  })
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                  child: Text(
                "titleIconColor".tr,
                style: textStyle,
              )),
              Switch(
                  value: _colorfulTitle,
                  onChanged: (_) {
                    _colorfulTitle = !_colorfulTitle;
                    if (_colorfulTitle) {
                      _colorfulBg = false;
                    }
                    _saveConfig();
                  })
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                  child: Text(
                "backgroundColor".tr,
                style: textStyle,
              )),
              Switch(
                  value: _colorfulBg,
                  onChanged: (_) {
                    _colorfulBg = !_colorfulBg;
                    if (_colorfulBg) {
                      _colorfulTitle = false;
                    }
                    _saveConfig();
                  })
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.info,
                  size: 12,
                  color: E().settingItemCellMainColor,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Text(
                    "appBarStyleComment".tr,
                    style: textStyle.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
