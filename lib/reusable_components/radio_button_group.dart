import 'package:flutter/material.dart';

class RadioButtonGroup extends StatefulWidget {
  RadioButtonGroup({
    @required this.buttonValues,
    this.radioButtonValue,
    @required this.buttonColor,
    @required this.buttonSelectedColor,
    this.textColor = Colors.black,
    this.textSelectedColor = Colors.white,
    this.horizontalSpace = 10,
    this.verticalSpace = 10,
    this.fontSize = 15,
    this.horizontalButtonCount = 3,
    this.buttonAspectRatio = 3 / 1,
    this.buttonBorderRadius = 5.0,
    this.defaultIndex = 0,
  })  : assert(buttonColor != null),
        assert(buttonSelectedColor != null);

  final double fontSize;
  final List buttonValues;
  final Function(dynamic) radioButtonValue;
  final int defaultIndex;

  final double horizontalSpace;
  final double verticalSpace;
  final int horizontalButtonCount;
  final double buttonAspectRatio;

  final Color buttonColor;
  final Color buttonSelectedColor;
  final Color textColor;
  final Color textSelectedColor;

  final double buttonBorderRadius;

  _RadioButtonGroupState createState() => _RadioButtonGroupState();
}

class _RadioButtonGroupState extends State<RadioButtonGroup> {
  int currentSelected = 0;

  @override
  void initState() {
    super.initState();
    currentSelected = widget.defaultIndex;
  }

  _buildButton(int index) {
    return GestureDetector(
      onTap: () {
        widget.radioButtonValue(index);
        currentSelected = index;
        if (mounted) {
          setState(() {});
        }
      },
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.buttonBorderRadius),
          color: currentSelected == index ? widget.buttonSelectedColor : widget.buttonColor,
        ),
        child: Text(
          widget.buttonValues[index],
          style: TextStyle(
            color: currentSelected == index ? widget.textSelectedColor : widget.textColor,
            fontSize: widget.fontSize,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(0.0),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: widget.buttonValues.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.horizontalButtonCount,
        crossAxisSpacing: widget.verticalSpace,
        mainAxisSpacing: widget.horizontalSpace,
        childAspectRatio: widget.buttonAspectRatio,
      ),
      itemBuilder: (BuildContext context, int index) {
        return _buildButton(index);
      },
    );
  }
}
