import 'package:flutter/material.dart';

TextSelection controllerInsertText({
  TextEditingController controller,
  String insertText,
  TextSelection currentSelection,
}) {
  var _currentSelection = currentSelection;
  if (_currentSelection == null) _currentSelection = controller.selection;
  String text = controller.text;
  String newText = text.replaceRange(_currentSelection.start, _currentSelection.end, insertText);
  final textLength = insertText.length;
  controller.text = newText;
  _currentSelection = _currentSelection.copyWith(
    baseOffset: _currentSelection.start + textLength,
    extentOffset: _currentSelection.start + textLength,
  );
  return _currentSelection;
}

TextSelection controllerInsertTextAndMove({
  TextEditingController controller,
  String insertText,
  TextSelection currentSelection,
  int move,
}) {
  var _currentSelection = currentSelection;
  if (_currentSelection == null) _currentSelection = controller.selection;
  String text = controller.text;
  String newText = text.replaceRange(_currentSelection.start, _currentSelection.end, insertText);
  final textLength = insertText.length;
  controller.text = newText;
  _currentSelection = _currentSelection.copyWith(
    baseOffset: _currentSelection.start + textLength + move,
    extentOffset: _currentSelection.start + textLength + move,
  );
  return _currentSelection;
}

TextSelection controllerInsertLeftRightTextAndMove({
  TextEditingController controller,
  String leftText,
  String rightText,
  TextSelection currentSelection,
}) {
  var _currentSelection = currentSelection;
  if (_currentSelection == null) _currentSelection = controller.selection;
  String text = controller.text;
  String newText = text.replaceRange(_currentSelection.end, _currentSelection.end, rightText);
  newText = newText.replaceRange(_currentSelection.start, _currentSelection.start, leftText);
  final textLength = leftText.length + rightText.length;
  controller.text = newText;
  _currentSelection = _currentSelection.copyWith(
    baseOffset: _currentSelection.start,
    extentOffset: _currentSelection.end + textLength,
  );
  return _currentSelection;
}
