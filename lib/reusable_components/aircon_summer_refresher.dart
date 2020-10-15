import 'package:flutter/material.dart' hide RefreshIndicator, RefreshIndicatorState;
import 'package:flutter/widgets.dart';
import 'package:flutter_gifimage/flutter_gifimage.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class AirconSummerHeader extends RefreshIndicator {
  AirconSummerHeader() : super(height: recommendedHeight, refreshStyle: RefreshStyle.Follow);

  static double recommendedHeight = 80;

  @override
  State<StatefulWidget> createState() {
    return AirconSummerHeaderState();
  }
}

class AirconSummerHeaderState extends RefreshIndicatorState with SingleTickerProviderStateMixin {
  var imagePath = './resources/refresher/aircon_summer/loading-fan.gif';
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
    if (mode == RefreshStatus.canRefresh || (mode == RefreshStatus.refreshing && _gifController.isAnimating == false)) {
      _gifController.repeat(
        min: 0,
        max: 3.0,
        period: Duration(milliseconds: (1000).floor()),
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
      image: AssetImage(
        imagePath,
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

class AirconSummerFooter extends LoadIndicator {
  final VoidCallback onClick;
  AirconSummerFooter({this.onClick})
      : super(onClick: onClick, loadStyle: LoadStyle.ShowWhenLoading, height: recommendedHeight);

  static double recommendedHeight = 80;

  @override
  State<StatefulWidget> createState() {
    return _AirconSummerFooterState();
  }
}

class _AirconSummerFooterState extends LoadIndicatorState<AirconSummerFooter> with SingleTickerProviderStateMixin {
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
        _gifController.repeat(min: 0, max: 4, period: Duration(milliseconds: (1000).floor()));
      }
    } else if (mode == LoadStatus.canLoading) {
      started = true;
      if (!_gifController.isAnimating) {
        _gifController.repeat(min: 0, max: 4, period: Duration(milliseconds: (1000).floor()));
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
    var imagePath = './resources/refresher/aircon_summer/fan-footer.gif';
    return !started
        ? Container()
        : GifImage(
            image: AssetImage(imagePath),
            controller: _gifController,
            height: 80.0,
          );
  }
}
