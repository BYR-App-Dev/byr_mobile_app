import 'package:byr_mobile_app/customizations/theme_controller.dart';
import 'package:flutter/material.dart';

class VoteBetDropDownHeader extends StatelessWidget {
  final String title;
  final bool menuIsShowing;
  VoteBetDropDownHeader(this.title, this.menuIsShowing);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      alignment: Alignment.center,
      color: E().voteBetListBackgroundColor,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 10),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: menuIsShowing ? E().voteBetListOptionSelectedColor : E().voteBetListOptionUnselectedColor,
              ),
            ),
          ),
          Icon(
            menuIsShowing ? Icons.expand_less : Icons.expand_more,
            color: menuIsShowing ? E().voteBetListOptionSelectedColor : E().voteBetListOptionUnselectedColor,
            size: 20,
          ),
        ],
      ),
    );
  }
}

class VoteBetDropDownItem extends StatelessWidget {
  final String title;
  final bool isSelected;
  VoteBetDropDownItem(this.title, this.isSelected);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      height: 50,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            width: 1,
            color: E().voteBetListOptionDividerColor,
          ),
        ),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Material(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  color: isSelected ? E().voteBetListOptionSelectedColor : E().voteBetListOptionUnselectedColor,
                ),
              ),
              color: Colors.transparent,
            ),
          ),
          if (isSelected)
            Icon(
              Icons.check,
              size: 20,
              color: E().voteBetListOptionSelectedColor,
            ),
        ],
      ),
    );
  }
}
