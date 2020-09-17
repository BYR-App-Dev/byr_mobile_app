import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

const double _kHandleSize = 22.0;

// Minimal padding from all edges of the selection toolbar to all edges of the
// viewport.
const double _kToolbarScreenPadding = 8.0;
const double _kToolbarHeight = 44.0;
// Padding when positioning toolbar below selection.
const double _kToolbarContentDistanceBelow = 16.0;
const double _kToolbarContentDistance = 8.0;

/// Manages a copy/paste text selection toolbar.
class ExtendedMaterialTextSelectionToolbar extends StatelessWidget {
  const ExtendedMaterialTextSelectionToolbar({
    Key key,
    this.handleCut,
    this.handleCopy,
    this.handlePaste,
    this.handleSelectAll,
    this.cancelTarget,
  }) : super(key: key);

  final VoidCallback handleCut;
  final VoidCallback handleCopy;
  final VoidCallback handlePaste;
  final VoidCallback handleSelectAll;
  final VoidCallback cancelTarget;

  @override
  Widget build(BuildContext context) {
    final MaterialLocalizations localizations = MaterialLocalizations.of(context);
    final List<Widget> items = <Widget>[];

    if (handleCut != null)
      items.add(
        FlatButton(
          child: Text(localizations.cutButtonLabel),
          onPressed: handleCut,
        ),
      );
    if (handleCopy != null)
      items.add(
        FlatButton(
          child: Text(localizations.copyButtonLabel),
          onPressed: handleCopy,
        ),
      );
    if (handlePaste != null)
      items.add(
        FlatButton(
          child: Text(localizations.pasteButtonLabel),
          onPressed: handlePaste,
        ),
      );
    if (handleSelectAll != null)
      items.add(
        FlatButton(
          child: Text(localizations.selectAllButtonLabel),
          onPressed: handleSelectAll,
        ),
      );
    if (cancelTarget != null)
      items.add(
        FlatButton(child: Text("dismissReplyPointerTrans".tr), onPressed: cancelTarget),
      );

    // If there is no option available, build an empty widget.
    if (items.isEmpty) {
      return Container(width: 0.0, height: 0.0);
    }

    return Material(
      elevation: 1.0,
      child: Container(
        height: _kToolbarHeight,
        child: Row(mainAxisSize: MainAxisSize.min, children: items),
      ),
    );
  }
}

/// Centers the toolbar around the given position, ensuring that it remains on
/// screen.
class ExtendedMaterialTextSelectionToolbarLayout extends SingleChildLayoutDelegate {
  ExtendedMaterialTextSelectionToolbarLayout(this.screenSize, this.globalEditableRegion, this.position);

  /// The size of the screen at the time that the toolbar was last laid out.
  final Size screenSize;

  /// Size and position of the editing region at the time the toolbar was last
  /// laid out, in global coordinates.
  final Rect globalEditableRegion;

  /// Anchor position of the toolbar, relative to the top left of the
  /// [globalEditableRegion].
  final Offset position;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return constraints.loosen();
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    final Offset globalPosition = globalEditableRegion.topLeft + position;

    double x = globalPosition.dx - childSize.width / 2.0;
    double y = globalPosition.dy - childSize.height;

    if (x < _kToolbarScreenPadding)
      x = _kToolbarScreenPadding;
    else if (x + childSize.width > screenSize.width - _kToolbarScreenPadding)
      x = screenSize.width - childSize.width - _kToolbarScreenPadding;

    if (y < _kToolbarScreenPadding)
      y = _kToolbarScreenPadding;
    else if (y + childSize.height > screenSize.height - _kToolbarScreenPadding)
      y = screenSize.height - childSize.height - _kToolbarScreenPadding;

    return Offset(x, y);
  }

  @override
  bool shouldRelayout(ExtendedMaterialTextSelectionToolbarLayout oldDelegate) {
    return position != oldDelegate.position;
  }
}

/// Draws a single text selection handle which points up and to the left.
class ExtendedMaterialTextSelectionHandlePainter extends CustomPainter {
  ExtendedMaterialTextSelectionHandlePainter({this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..color = color;
    final double radius = size.width / 2.0;
    canvas.drawCircle(Offset(radius, radius), radius, paint);
    canvas.drawRect(Rect.fromLTWH(0.0, 0.0, radius, radius), paint);
  }

  @override
  bool shouldRepaint(ExtendedMaterialTextSelectionHandlePainter oldPainter) {
    return color != oldPainter.color;
  }
}

typedef BoolCallback = bool Function();

class CustomTextSelectionControls extends TextSelectionControls {
  final BoolCallback canCancelTarget;
  final VoidCallback cancelTarget;
  CustomTextSelectionControls({@required this.canCancelTarget, @required this.cancelTarget});

  /// Returns the size of the Material handle.
  @override
  Size getHandleSize(double textLineHeight) => const Size(_kHandleSize, _kHandleSize);

  /// Builder for material-style copy/paste text selection toolbar.
  @override
  Widget buildToolbar(
    BuildContext context,
    Rect globalEditableRegion,
    double textLineHeight,
    Offset position,
    List<TextSelectionPoint> endpoints,
    TextSelectionDelegate delegate,
    // ClipboardStatusNotifier clipboardStatus,
  ) {
    assert(debugCheckHasMediaQuery(context));
    assert(debugCheckHasMaterialLocalizations(context));

    // The toolbar should appear below the TextField
    // when there is not enough space above the TextField to show it.
    final TextSelectionPoint startTextSelectionPoint = endpoints[0];
    final double toolbarHeightNeeded =
        MediaQuery.of(context).padding.top + _kToolbarScreenPadding + _kToolbarHeight + _kToolbarContentDistance;
    final double availableHeight = globalEditableRegion.top + endpoints.first.point.dy - textLineHeight;
    final bool fitsAbove = toolbarHeightNeeded <= availableHeight;
    final double y = fitsAbove
        ? startTextSelectionPoint.point.dy - _kToolbarContentDistance - textLineHeight
        : startTextSelectionPoint.point.dy + _kToolbarHeight + _kToolbarContentDistanceBelow;
    final Offset preciseMidpoint = Offset(position.dx, y);

    return ConstrainedBox(
      constraints: BoxConstraints.tight(globalEditableRegion.size),
      child: CustomSingleChildLayout(
        delegate: ExtendedMaterialTextSelectionToolbarLayout(
          MediaQuery.of(context).size,
          globalEditableRegion,
          preciseMidpoint,
        ),
        child: ExtendedMaterialTextSelectionToolbar(
          handleCut: canCut(delegate) ? () => handleCut(delegate) : null,
          handleCopy: canCopy(delegate) ? () => handleCopy(delegate /*, clipboardStatus*/) : null,
          handlePaste: canPaste(delegate) ? () => handlePaste(delegate) : null,
          handleSelectAll: canSelectAll(delegate) ? () => handleSelectAll(delegate) : null,
          cancelTarget: canCancelTarget()
              ? () {
                  if (cancelTarget != null) cancelTarget();
                  delegate.hideToolbar();
                }
              : null,
        ),
      ),
    );
  }

  /// Builder for material-style text selection handles.
  @override
  Widget buildHandle(BuildContext context, TextSelectionHandleType type, double textHeight) {
    final Widget handle = SizedBox(
      width: _kHandleSize,
      height: _kHandleSize,
      child: CustomPaint(
        painter: ExtendedMaterialTextSelectionHandlePainter(color: Theme.of(context).textSelectionHandleColor),
      ),
    );

    // [handle] is a circle, with a rectangle in the top left quadrant of that
    // circle (an onion pointing to 10:30). We rotate [handle] to point
    // straight up or up-right depending on the handle type.
    switch (type) {
      case TextSelectionHandleType.left: // points up-right
        return Transform.rotate(
          angle: math.pi / 2.0,
          child: handle,
        );
      case TextSelectionHandleType.right: // points up-left
        return handle;
      case TextSelectionHandleType.collapsed: // points up
        return Transform.rotate(
          angle: math.pi / 4.0,
          child: handle,
        );
    }
    assert(type != null);
    return null;
  }

  /// Gets anchor for material-style text selection handles.
  ///
  /// See [TextSelectionControls.getHandleAnchor].
  @override
  Offset getHandleAnchor(TextSelectionHandleType type, double textLineHeight) {
    switch (type) {
      case TextSelectionHandleType.left:
        return const Offset(_kHandleSize, 0);
      case TextSelectionHandleType.right:
        return Offset.zero;
      default:
        return const Offset(_kHandleSize / 2, -4);
    }
  }

  @override
  bool canSelectAll(TextSelectionDelegate delegate) {
    // Android allows SelectAll when selection is not collapsed, unless
    // everything has already been selected.
    final TextEditingValue value = delegate.textEditingValue;
    return delegate.selectAllEnabled &&
        value.text.isNotEmpty &&
        !(value.selection.start == 0 && value.selection.end == value.text.length);
  }
}
