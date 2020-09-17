import 'package:flutter/material.dart';

typedef EmoticonTapCallback = void Function(String emoticon);

class EmoticonPanelConfig {
  Map<String, Color> colors;
  Map<String, String> trans;
  EmoticonPanelConfig(this.colors, this.trans);
}

class EmoticonPanel extends StatefulWidget {
  final EmoticonTapCallback onEmoticonTap;
  final EmoticonPanelConfig config;
  EmoticonPanel({Key key, @required this.onEmoticonTap, @required this.config}) : super(key: key);

  @override
  _EmoticonPanelState createState() => _EmoticonPanelState();
}

class _EmoticonPanelState extends State<EmoticonPanel> {
  List<String> _emoticonNameList = ['em', 'ema', 'emb', 'emc'];
  var _emoticonCountList = [73, 42, 25, 59];
  int _curIndex = 0;
  double _panelHeight = 300.0;
  double _panelWidth = 0.0;

  @override
  void initState() {
    super.initState();
  }

  List<Widget> _buildChildren() {
    List<Widget> list = List();
    String emoticonName = _emoticonNameList[_curIndex];
    int startIndex = 0;
    if (emoticonName == 'em') {
      startIndex = 1;
    }
    for (int i = 0; i < _emoticonCountList[_curIndex]; i++) {
      list.add(
        GestureDetector(
          child: Image.asset('resources/em/$emoticonName${startIndex + i}.gif'),
          onTap: () {
            widget.onEmoticonTap('[$emoticonName${startIndex + i}]');
          },
        ),
      );
    }
    return list;
  }

  Widget _emoticonButton(int index, String text) {
    return Container(
      width: _panelWidth / 4,
      child: Theme(
        data: ThemeData(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: FlatButton(
          color: index == _curIndex
              ? this.widget.config.colors['selectedBackgroundColor']
              : this.widget.config.colors['unselectedBackgroundColor'],
          onPressed: () {
            _curIndex = index;
            if (mounted) {
              setState(() {});
            }
          },
          child: Text(
            text,
            style: TextStyle(color: this.widget.config.colors['tabTextColor']),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constrains) {
        var padding = 10.0;
        _panelWidth = constrains.maxWidth - 2 * padding;
        double emoticonHeight = 50.0;
        double columnSpacing = emoticonHeight / 2;
        if (_emoticonNameList[_curIndex] == 'em') {
          emoticonHeight = 20.0;
          columnSpacing = emoticonHeight;
        }
        int columnPerPage = (_panelWidth + columnSpacing) ~/ (emoticonHeight + columnSpacing);
        var selectBtn = Container(
          height: 30,
          margin: EdgeInsets.only(top: 10, bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _emoticonButton(0, this.widget.config.trans['classicsTabTrans']),
              _emoticonButton(1, this.widget.config.trans['yoyociciTabTrans']),
              _emoticonButton(2, this.widget.config.trans['tuzkiTabTrans']),
              _emoticonButton(3, this.widget.config.trans['oniontouTabTrans']),
            ],
          ),
        );
        return Container(
          padding: EdgeInsets.symmetric(horizontal: padding),
          height: _panelHeight,
          color: this.widget.config.colors['backgroundColor'],
          child: Column(
            children: <Widget>[
              selectBtn,
              Expanded(
                child: GridView.count(
                  padding: EdgeInsets.all(0.0),
                  shrinkWrap: true,
                  crossAxisCount: columnPerPage,
                  children: _buildChildren(),
                  mainAxisSpacing: columnSpacing,
                  crossAxisSpacing: columnSpacing,
                  childAspectRatio: 1,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class EmoticonPanelProvider with ChangeNotifier {
  bool _isShow = false;

  get isShow => _isShow;

  void changeState() {
    _isShow = !_isShow;
    if (_isShow) {
      Future.delayed(Duration(milliseconds: 100)).then((_) {
        notifyListeners();
      });
    } else {
      notifyListeners();
    }
  }

  void dismissPanel() {
    _isShow = false;
    notifyListeners();
  }
}
