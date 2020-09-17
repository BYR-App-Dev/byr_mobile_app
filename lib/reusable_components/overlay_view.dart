import 'package:flutter/material.dart';

/// source: https://takeroro.github.io/2019/07/28/Flutter-Overlay/
class OverlayView {
  static OverlayEntry _holder;

  static Widget view;

  static void remove() {
    if (_holder != null) {
      _holder.remove();
      _holder = null;
    }
  }

  static void show({@required BuildContext context, @required Widget view}) {
    OverlayView.view = view;

    remove();
    OverlayEntry overlayEntry = new OverlayEntry(builder: (context) {
      return new Positioned(top: MediaQuery.of(context).size.height * 0.7, right: 0, child: _buildDraggable(context));
    });

    Overlay.of(context).insert(overlayEntry);

    _holder = overlayEntry;
  }

  static _buildDraggable(context) {
    return new Draggable(
      child: view,
      feedback: view,
      onDragStarted: () {},
      onDragEnd: (detail) {
        createDragTarget(offset: detail.offset, context: context);
      },
      childWhenDragging: Container(),
    );
  }

  static void refresh() {
    _holder.markNeedsBuild();
  }

  static void createDragTarget({Offset offset, BuildContext context}) {
    if (_holder != null) {
      _holder.remove();
    }

    _holder = new OverlayEntry(builder: (context) {
      bool isLeft = true;
      if (offset.dx + 100 > MediaQuery.of(context).size.width / 2) {
        isLeft = false;
      }

      double maxY = MediaQuery.of(context).size.height - 100;

      return new Positioned(
          top: offset.dy < 50 ? 50 : offset.dy < maxY ? offset.dy : maxY,
          left: isLeft ? 0 : null,
          right: isLeft ? null : 0,
          child: DragTarget(
            onWillAccept: (data) {
              return true;
            },
            onAccept: (data) {},
            onLeave: (data) {},
            builder: (BuildContext context, List incoming, List rejected) {
              return _buildDraggable(context);
            },
          ));
    });
    Overlay.of(context).insert(_holder);
  }
}
