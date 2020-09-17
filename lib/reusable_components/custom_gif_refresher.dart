import 'dart:convert';

import 'package:flutter/material.dart' hide RefreshIndicator, RefreshIndicatorState;
import 'package:flutter/widgets.dart';
import 'package:flutter_gifimage/flutter_gifimage.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CustomGifHeader extends RefreshIndicator {
  CustomGifHeader(this.headerBase64, this.topFrameCount)
      : super(height: recommendedHeight, refreshStyle: RefreshStyle.Follow);

  final String headerBase64;

  final int topFrameCount;

  static double recommendedHeight = 80;

  @override
  State<StatefulWidget> createState() {
    return CustomGifHeaderState();
  }
}

class CustomGifHeaderState extends RefreshIndicatorState<CustomGifHeader> with SingleTickerProviderStateMixin {
  GifController _gifController;
  @override
  void initState() {
    _gifController = GifController(
      vsync: this,
      value: 0,
    );
    super.initState();
  }

  @override
  void onModeChange(RefreshStatus mode) {
    if (mode == RefreshStatus.canRefresh) {
      _gifController.repeat(
        min: 0,
        max: widget.topFrameCount * 1.0,
        period: Duration(milliseconds: (widget.topFrameCount / 24 * 1000).floor()),
      );
    }
    super.onModeChange(mode);
  }

  @override
  Future<void> endRefresh() {
    return super.endRefresh();
  }

  @override
  void resetValue() {
    _gifController.reset();
    super.resetValue();
  }

  @override
  Widget buildContent(BuildContext context, RefreshStatus mode) {
    return GifImage(
      image: MemoryImage(
        base64.decode(widget.headerBase64),
      ),
      controller: _gifController,
      height: 80.0,
    );
  }

  @override
  void dispose() {
    _gifController.dispose();
    super.dispose();
  }
}

class CustomGifFooter extends LoadIndicator {
  final VoidCallback onClick;
  final int bottomFrameCount;
  CustomGifFooter(this.footerBase64, this.bottomFrameCount, {this.onClick})
      : super(onClick: onClick, loadStyle: LoadStyle.ShowWhenLoading, height: recommendedHeight);

  final String footerBase64;

  static double recommendedHeight = 80;

  @override
  State<StatefulWidget> createState() {
    return _CustomGifFooterState();
  }
}

class _CustomGifFooterState extends LoadIndicatorState<CustomGifFooter> with SingleTickerProviderStateMixin {
  GifController _gifController;

  bool started;

  @override
  void initState() {
    started = false;
    _gifController = GifController(
      vsync: this,
      value: 0,
    );
    super.initState();
  }

  @override
  void dispose() {
    _gifController.dispose();
    super.dispose();
  }

  @override
  void onModeChange(LoadStatus mode) {
    if (mode == LoadStatus.idle && started) {
      started = false;
      _gifController.value = 0;
    } else if (mode == LoadStatus.loading && !started) {
      started = true;
      if (!_gifController.isAnimating) {
        _gifController.repeat(
            min: 0,
            max: widget.bottomFrameCount * 1.0,
            period: Duration(milliseconds: (widget.bottomFrameCount / 24 * 1000).floor()));
      }
    } else if (mode == LoadStatus.canLoading) {
      started = true;
      if (!_gifController.isAnimating) {
        _gifController.repeat(
            min: 0,
            max: widget.bottomFrameCount * 1.0,
            period: Duration(milliseconds: (widget.bottomFrameCount / 24 * 1000).floor()));
      }
    }
    super.onModeChange(mode);
  }

  @override
  Future endLoading() {
    if (_gifController.isAnimating) {
      started = false;
      _gifController.reset();
    }
    return super.endLoading();
  }

  @override
  Widget buildContent(BuildContext context, LoadStatus mode) {
    return !started
        ? Container()
        : GifImage(
            image: MemoryImage(base64.decode(widget.footerBase64)),
            controller: _gifController,
            height: 80.0,
          );
  }
}
