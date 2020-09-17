import 'package:byr_mobile_app/nforum/nforum_service.dart';
import 'package:byr_mobile_app/reusable_components/controller_insert_text.dart';
import 'package:byr_mobile_app/reusable_components/friendly_file_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tuple/tuple.dart';

int convertSizeString(String sizeString) {
  if (sizeString.contains('MB')) {
    sizeString = sizeString.replaceAll('MB', '');
    double size = double.parse(sizeString);
    size += 0.06;
    return (size * 1024 * 1024).toInt();
  }
  if (sizeString.contains('KB')) {
    sizeString = sizeString.replaceAll('KB', '');
    double size = double.parse(sizeString);
    size += 0.06;
    return (size * 1024).toInt();
  }
  sizeString = sizeString.replaceAll('B', '');
  int size = int.parse(sizeString);
  return size + 1;
}

class PostArticleProvider with ChangeNotifier {
  List<Tuple2<String, int>> _attachList = [];
  List<int> _sizeList = [];
  TextEditingController _controller = TextEditingController();
  FocusNode _focusNode = FocusNode();
  bool _emoticonIsShow = false;
  bool _colorIsShow = false;
  bool _biuIsShow = false;
  TextSelection _textSelection = TextSelection(baseOffset: 0, extentOffset: 0);
  bool _attachChange = false;
  int _totalSize = 0;

  PostArticleProvider({
    String existingContent,
    List<Tuple2<String, int>> attachList,
    List<int> sizeList,
    int totalSize,
  }) {
    _controller.text = existingContent ?? '';
    _controller.selection = _textSelection;
    _attachList = attachList;
    _sizeList = sizeList;
    _totalSize = totalSize;

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _emoticonIsShow = false;
        _colorIsShow = false;
        _biuIsShow = false;
        _controller.selection = _textSelection;
        notifyListeners();
      }
    });
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<Tuple2<String, int>> get attachList => _attachList;
  get attachChange => _attachChange;
  get controller => _controller;
  get focusNode => _focusNode;
  get emoticonIsShow => _emoticonIsShow;
  get colorIsShow => _colorIsShow;
  get biuIsShow => _biuIsShow;
  get canPost => _totalSize < NForumSpecs.attachmentSize;
  get friendlyFileSize => filesize(_totalSize);

  addAttach(String imagePath, int type, int size) {
    _attachList.add(Tuple2<String, int>(imagePath, type));
    _sizeList.add(size);
    _attachChange = !_attachChange;
    _totalSize += size;
    notifyListeners();
  }

  showEmoticonPanel() {
    dismissBiuPanel();
    hideKeyBoard();
    _emoticonIsShow = true;
    Future.delayed(Duration(milliseconds: 100)).then((_) {
      notifyListeners();
    });
  }

  dismissEmoticonPanel() {
    _emoticonIsShow = false;
    notifyListeners();
  }

  toggleEmoticonPanel() {
    if (!_emoticonIsShow) {
      showEmoticonPanel();
    } else {
      dismissEmoticonPanel();
    }
  }

  showColorPanel() {
    dismissEmoticonPanel();
    dismissBiuPanel();
    hideKeyBoard();
    _colorIsShow = true;
    Future.delayed(Duration(milliseconds: 100)).then((_) {
      notifyListeners();
    });
  }

  dismissColorPanel() {
    _colorIsShow = false;
    notifyListeners();
  }

  toggleColorPanel() {
    if (!_colorIsShow) {
      showColorPanel();
    } else {
      dismissColorPanel();
    }
  }

  showBiuPanel() {
    dismissEmoticonPanel();
    hideKeyBoard();
    _biuIsShow = true;
    Future.delayed(Duration(milliseconds: 100)).then((_) {
      notifyListeners();
    });
  }

  dismissBiuPanel() {
    _biuIsShow = false;
    notifyListeners();
  }

  toggleBiuPanel() {
    if (!_biuIsShow) {
      showBiuPanel();
    } else {
      dismissBiuPanel();
    }
  }

  hideKeyBoard() {
    if (_focusNode.hasFocus) {
      _textSelection = _controller.selection;
      _focusNode.unfocus();
    }
  }

  dismissKeyBoard() {
    dismissEmoticonPanel();
    dismissBiuPanel();
    if (_focusNode.hasFocus) {
      _textSelection = _controller.selection;
      _focusNode.unfocus();
    }
  }

  insertEmoticon(String emoticon) {
    _textSelection = controllerInsertText(
      controller: _controller,
      insertText: emoticon,
      currentSelection: _textSelection,
    );
  }

  insertColor(Color color) {
    if (_textSelection.start == _textSelection.end) {
      _textSelection = controllerInsertTextAndMove(
        controller: _controller,
        insertText: '[color=#' + color.value.toRadixString(16).substring(2) + '][/color]',
        currentSelection: _textSelection,
        move: -8,
      );
    } else {
      _textSelection = controllerInsertLeftRightTextAndMove(
        controller: _controller,
        leftText: '[color=#' + color.value.toRadixString(16).substring(2) + ']',
        rightText: '[/color]',
        currentSelection: _textSelection,
      );
    }
  }

  insertBiu(String leftText, String rightText) {
    if (_textSelection.start == _textSelection.end) {
      _textSelection = controllerInsertTextAndMove(
        controller: _controller,
        insertText: leftText + rightText,
        currentSelection: _textSelection,
        move: -rightText.length,
      );
    } else {
      _textSelection = controllerInsertLeftRightTextAndMove(
        controller: _controller,
        leftText: leftText,
        rightText: rightText,
        currentSelection: _textSelection,
      );
    }
  }

  insertImage(Tuple2<String, int> imagePath) {
    hideKeyBoard();
    var index = _attachList.indexOf(imagePath);
    _textSelection = controllerInsertText(
      controller: _controller,
      insertText: '\n[upload=${index + 1}][/upload]',
      currentSelection: _textSelection,
    );
  }

  deleteImage(Tuple2<String, int> imagePath) {
    var index = _attachList.indexOf(imagePath);
    if (index == -1) return;
    _controller.text = _controller.text.replaceAll('[upload=${index + 1}][/upload]', '');
    if (index == _attachList.length - 1) {
      _attachList.removeAt(index);
      _totalSize -= _sizeList[index];
      _attachChange = !_attachChange;
      notifyListeners();
    } else {
      for (int i = index + 1; i < _attachList.length; i++) {
        _controller.text = _controller.text.replaceAll('[upload=${i + 1}][/upload]', '[upload=$i][/upload]');
      }
      _attachList.removeAt(index);
      _totalSize -= _sizeList[index];
      _attachChange = !_attachChange;
      notifyListeners();
    }
  }
}
