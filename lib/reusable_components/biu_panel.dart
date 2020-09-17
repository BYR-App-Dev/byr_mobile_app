import 'package:byr_mobile_app/customizations/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

const _colorOptions = [
  'e74c3c',
  'f39c12',
  'f9ca24',
  '4cd137',
  'b8e994',
  '81ecec',
  '3498db',
  '8e44ad',
  'f78fb3',
  'a0512d',
  '808e9b',
];

typedef BiuPanelCancelTapCallback = void Function();
typedef ColorPanelConfirmTapCallback = void Function(Color pickedColor);
typedef BiuPanelConfirmTapCallback = void Function(String leftText, String rightText);

class BiuPanel extends StatefulWidget {
  final BiuPanelCancelTapCallback onCancelTap;
  final BiuPanelConfirmTapCallback onConfirmBiuTap;
  final ColorPanelConfirmTapCallback onConfirmColorTap;
  BiuPanel({
    Key key,
    this.onCancelTap,
    this.onConfirmColorTap,
    this.onConfirmBiuTap,
  }) : super(key: key);

  @override
  _BiuPanelState createState() => _BiuPanelState();
}

class _BiuPanelState extends State<BiuPanel> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            PopupMenuButton<Color>(
              icon: Icon(
                Icons.color_lens,
                color: E().editPageButtonIconColor,
              ),
              onSelected: (Color result) {
                this.widget.onConfirmColorTap(result);
              },
              color: E().editPageBackgroundColor,
              itemBuilder: (BuildContext context) => _colorOptions
                  .map(
                    (e) => PopupMenuItem<Color>(
                      value: Color(int.tryParse("0xff" + e)),
                      height: 40,
                      child: Text(
                        '                    ',
                        style: TextStyle(
                          backgroundColor: Color(int.tryParse("0xff" + e)),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            FlatButton(
              child: Icon(Icons.format_bold),
              textColor: E().editPageButtonTextColor,
              onPressed: () {
                this.widget.onConfirmBiuTap('[b]', '[/b]');
              },
            ),
            FlatButton(
              child: Icon(Icons.format_italic),
              textColor: E().editPageButtonTextColor,
              onPressed: () {
                this.widget.onConfirmBiuTap('[i]', '[/i]');
              },
            ),
            FlatButton(
              child: Icon(Icons.format_underlined),
              textColor: E().editPageButtonTextColor,
              onPressed: () {
                this.widget.onConfirmBiuTap('[u]', '[/u]');
              },
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            FlatButton(
              child: Text("cancelTrans".tr),
              textColor: E().editPageButtonTextColor,
              onPressed: () {
                this.widget.onCancelTap();
              },
            ),
            PopupMenuButton<int>(
              icon: Icon(
                Icons.text_fields,
                color: E().editPageButtonIconColor,
              ),
              onSelected: (int result) {
                this.widget.onConfirmBiuTap('[size=' + (result).toString() + ']', '[/size]');
              },
              color: E().editPageBackgroundColor,
              itemBuilder: (BuildContext context) => List.generate(
                9,
                (index) => PopupMenuItem<int>(
                  value: index + 1,
                  child: Text(
                    (index + 1).toString(),
                    style: TextStyle(
                      fontSize: (index + 1.0) * 1 + 16,
                      color: E().editPageButtonTextColor,
                    ),
                  ),
                ),
              ),
            ),
            FlatButton(
              child: Text('MARKDOWN'),
              textColor: E().editPageButtonTextColor,
              onPressed: () {
                this.widget.onConfirmBiuTap('\n[md]\n', '\n[/md]\n');
              },
            ),
          ],
        ),
      ],
    );
  }
}
