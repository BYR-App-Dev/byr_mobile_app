import 'package:flutter/material.dart';

class DropdownMenuController extends ChangeNotifier {
  DropdownMenuController({int initSelectIndex = 0}) {
    curSelectedIndex = initSelectIndex;
  }
  bool menuIsShowing = false;
  int curSelectedIndex = 0;

  void showMenu() {
    menuIsShowing = true;
    notifyListeners();
  }

  void hideMenu() {
    menuIsShowing = false;
    notifyListeners();
  }

  void toggleMenu() {
    menuIsShowing = !menuIsShowing;
    notifyListeners();
  }
}

class DropdownMenu extends StatefulWidget {
  /// 初级用法
  final double headerWidth;
  final double headerHeight;
  final List<String> itemTextList;
  final Color barrierColor;
  final Color backgroundColor;
  final int initSelectedIndex;
  final void Function(int selectedIndex) onItemSelected;
  final int itemLength;
  final Widget Function(int index, bool isSelected) itemBuilder;
  final DropdownMenuController controller;

  /// 高级用法
  final Widget Function(bool menuIsShowing) headerBuilder;
  final Widget Function(int selectedIndex) menuBuilder;
  DropdownMenu({
    this.headerWidth = double.infinity,
    this.headerHeight = 50,
    this.itemTextList,
    this.barrierColor = Colors.black54,
    this.backgroundColor = Colors.white,
    this.itemLength,
    this.itemBuilder,
    this.initSelectedIndex = 0,
    this.onItemSelected,
    this.controller,
    this.headerBuilder,
    this.menuBuilder,
  }) : assert((itemTextList != null && itemTextList.isNotEmpty) || (itemLength != null && itemBuilder != null));
  @override
  _DropdownMenuState createState() => _DropdownMenuState();
}

class _DropdownMenuState extends State<DropdownMenu> {
  DropdownMenuController _controller;
  OverlayEntry _overlayEntry;
  GlobalKey _headerKey = GlobalKey();

  _updateView() {
    if (_controller.menuIsShowing) {
      _showMenu();
    } else {
      _hideMenu();
    }
    setState(() {});
  }

  _showMenu() {
    _buildOverlay();
    Overlay.of(context).insert(_overlayEntry);
  }

  _hideMenu() {
    _overlayEntry?.remove();
  }

  /// 这里是DropdownMenu的实现原理：
  /// 首先最基本的，使用overlay的方式插入到context的整个Overlay，这就实现了显示
  /// 其次，坐标定位借助于RenderBox与Offset找到位置与大小
  /// 需要注意的时，像这类DropdownMenu，只要它被触发展示出来，这时用户点击除menu其他位置都将触发【消失】事件
  /// 因此在下面代码的_overlayEntry布局中，menu上下都需要两个GestureDetector消费点击事件。
  _buildOverlay() {
    if (_headerKey == null) return;
    RenderBox renderBox = _headerKey.currentContext.findRenderObject();
    Offset offset = renderBox.localToGlobal(Offset.zero);
    double top = renderBox.size.height + offset.dy;
    double itemHeight = 50.0;
    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: <Widget>[
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _controller.hideMenu,
                child: Container(
                  height: top,
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                color: widget.backgroundColor,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: widget.menuBuilder != null
                      ? widget.menuBuilder(_controller.curSelectedIndex)
                      : Column(
                          children: widget.itemBuilder != null && widget.itemLength != null
                              ? List.generate(
                                  widget.itemLength,
                                  (index) => GestureDetector(
                                    onTap: () {
                                      _controller.curSelectedIndex = index;
                                      if (widget.onItemSelected != null) {
                                        widget.onItemSelected(index);
                                      }
                                      _controller.hideMenu();
                                    },
                                    child: Material(
                                      child: widget.itemBuilder(index, index == _controller.curSelectedIndex),
                                      color: Colors.transparent,
                                    ),
                                  ),
                                )
                              : widget.itemTextList.map((item) {
                                  int index = widget.itemTextList.indexOf(item);
                                  return GestureDetector(
                                    onTap: () {
                                      _controller.curSelectedIndex = index;
                                      if (widget.onItemSelected != null) {
                                        widget.onItemSelected(index);
                                      }
                                      _controller.hideMenu();
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 20),
                                      height: itemHeight,
                                      decoration: BoxDecoration(
                                        border: Border(
                                          top: BorderSide(
                                            width: 1,
                                            color: const Color(0xFFEEF0F2),
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: Material(
                                              child: Text(
                                                item,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: index == _controller.curSelectedIndex
                                                      ? Colors.black
                                                      : Colors.grey,
                                                ),
                                              ),
                                              color: Colors.transparent,
                                            ),
                                          ),
                                          if (index == _controller.curSelectedIndex)
                                            Icon(
                                              Icons.check,
                                              size: 20,
                                            ),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                        ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: _controller.hideMenu,
                  child: Container(
                    color: widget.barrierColor,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    _controller = widget.controller;
    if (_controller == null) _controller = DropdownMenuController();
    _controller.curSelectedIndex = widget.initSelectedIndex;
    _controller.addListener(_updateView);
    super.initState();
  }

  @override
  void dispose() {
    _hideMenu();
    _controller.removeListener(_updateView);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _controller.toggleMenu,
      child: widget.headerBuilder == null
          ? Container(
              key: _headerKey,
              width: widget.headerWidth,
              height: widget.headerHeight,
              alignment: Alignment.center,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    child: Text(
                      widget.itemTextList[_controller.curSelectedIndex],
                      style: TextStyle(
                        fontSize: 16,
                        color: _controller.menuIsShowing ? Colors.black : Colors.grey,
                      ),
                    ),
                  ),
                  Icon(
                    _controller.menuIsShowing ? Icons.expand_less : Icons.expand_more,
                    color: _controller.menuIsShowing ? Colors.black : Colors.grey,
                    size: 20,
                  ),
                ],
              ),
            )
          : Container(
              key: _headerKey,
              child: widget.headerBuilder(_controller.menuIsShowing),
            ),
    );
  }
}
