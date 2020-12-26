import 'package:byr_mobile_app/customizations/theme_controller.dart';
import 'package:byr_mobile_app/local_objects/local_storage.dart';
import 'package:flutter/material.dart';

class SettingItemCell extends StatefulWidget {
  SettingItemCell({
    @required this.title,
    this.leading,
    this.value,
    this.newFeatureKey,
    this.showArrow = true,
    this.onTap,
    this.height = 66,
  });
  final Widget leading;
  final String title;
  final String value;
  final String newFeatureKey;
  final bool showArrow;
  final VoidCallback onTap;
  final double height;
  @override
  _SettingItemCellState createState() => _SettingItemCellState();
}

class _SettingItemCellState extends State<SettingItemCell> {
  _closeFeatureHint() {
    if (widget.newFeatureKey != null &&
        widget.newFeatureKey.isNotEmpty &&
        (LocalStorage.getFeatureKeys()[widget.newFeatureKey] ?? true) == true) {
      Map<String, bool> featureKeys = LocalStorage.getFeatureKeys();
      featureKeys[widget.newFeatureKey] = false;
      LocalStorage.setFeatureKeys(featureKeys);
      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _closeFeatureHint();
        if (widget.onTap != null) {
          widget.onTap();
        }
      },
      child: Container(
        width: double.infinity,
        height: widget.height,
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          children: <Widget>[
            if (widget.leading != null)
              Padding(
                padding: EdgeInsets.only(right: 20),
                child: widget.leading,
              ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(right: 20),
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.title,
                  style: TextStyle(
                    color: E().settingItemCellMainColor,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            if (widget.value != null && widget.value.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(right: 0),
                child: Text(
                  widget.value,
                  style: TextStyle(
                    color: E().settingItemCellSubColor,
                    fontSize: 16,
                  ),
                ),
              ),
            if (widget.newFeatureKey != null &&
                widget.newFeatureKey.isNotEmpty &&
                (LocalStorage.getFeatureKeys()[widget.newFeatureKey] ?? true) == true)
              Padding(
                padding: EdgeInsets.only(right: 10),
                child: Container(
                  padding: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                    // borderRadius: BorderRadius.circular(6),
                  ),
                  constraints: BoxConstraints(
                    minWidth: 8,
                    minHeight: 8,
                  ),
                ),
              ),
            if (widget.showArrow)
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: E().settingItemCellSubColor,
              )
          ],
        ),
      ),
    );
  }
}
