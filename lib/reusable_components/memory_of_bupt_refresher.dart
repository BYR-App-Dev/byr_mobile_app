import 'dart:math';

import 'package:flutter/material.dart' hide RefreshIndicator, RefreshIndicatorState;
import 'package:flutter/widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MemoryOfBUPTHeader extends RefreshIndicator {
  MemoryOfBUPTHeader()
      : super(height: recommendedHeight, refreshStyle: RefreshStyle.Behind, completeDuration: Duration(seconds: 1));

  static double recommendedHeight = 90;

  @override
  State<StatefulWidget> createState() {
    return MemoryOfBUPTHeaderState();
  }
}

class MemoryOfBUPTHeaderState extends RefreshIndicatorState<MemoryOfBUPTHeader> with SingleTickerProviderStateMixin {
  var backgroundPath = './resources/refresher/memory_of_bupt/bupt-background.png';
  var byrlogoPath = './resources/refresher/memory_of_bupt/byr.png';
  var buptbuildingsPath = './resources/refresher/memory_of_bupt/bupt-buildings.png';

  AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5),
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  void onModeChange(RefreshStatus mode) {
    if (mode == RefreshStatus.refreshing && animationController.isAnimating == false) {
      animationController.repeat();
    }
    super.onModeChange(mode);
  }

  @override
  Future<void> endRefresh() {
    return super.endRefresh();
  }

  Future<void> readyToRefresh() {
    animationController.repeat();
    return super.readyToRefresh();
  }

  @override
  void resetValue() {
    animationController.reset();
    super.resetValue();
  }

  @override
  Widget buildContent(BuildContext context, RefreshStatus mode) {
    return Container(
      alignment: Alignment.center,
      height: 120,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          AnimatedBuilder(
            animation: animationController,
            builder: (BuildContext context, Widget _widget) {
              return Transform.rotate(
                angle: animationController.value * 2 * pi,
                child: _widget,
              );
            },
            child: Image.asset(
              buptbuildingsPath,
              alignment: Alignment.center,
              height: 95,
            ),
          ),
          Image.asset(
            backgroundPath,
            alignment: Alignment.center,
            height: 60,
          ),
          Image.asset(
            byrlogoPath,
            alignment: Alignment.center,
            height: 160,
          ),
        ],
      ),
    );
  }
}

class MemoryOfBUPTFooter extends LoadIndicator {
  MemoryOfBUPTFooter() : super(loadStyle: LoadStyle.ShowWhenLoading, height: recommendedHeight);

  static double recommendedHeight = 120;

  @override
  State<StatefulWidget> createState() {
    return _MemoryOfBUPTFooterState();
  }
}

class _MemoryOfBUPTFooterState extends LoadIndicatorState<MemoryOfBUPTFooter> with SingleTickerProviderStateMixin {
  var buildingPath = './resources/refresher/memory_of_bupt/building.png';
  var fishPath = './resources/refresher/memory_of_bupt/fish.png';
  var sunPath = './resources/refresher/memory_of_bupt/sun.png';
  var wavePath = './resources/refresher/memory_of_bupt/waves.png';

  AnimationController animationController;

  bool started = false;
  bool stopNextLoop = false;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 10),
    );
    animationController.addStatusListener(listener);
  }

  void listener(AnimationStatus status) {
    if (status == AnimationStatus.completed || status == AnimationStatus.dismissed) {
      animationController.reset();
      if (stopNextLoop) {
      } else {
        animationController.forward();
      }
    }
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  void onModeChange(LoadStatus mode) {
    if (mode == LoadStatus.idle && started) {
      stopNextLoop = true;
      started = false;
    } else if (mode == LoadStatus.loading && !started) {
      stopNextLoop = false;
      started = true;
    } else if (mode == LoadStatus.canLoading) {
      stopNextLoop = false;
      started = true;
      animationController.forward();
    }
    super.onModeChange(mode);
  }

  @override
  Future<void> endLoading() {
    if (animationController.isAnimating) {
      started = false;
      animationController.reset();
    }
    return super.endLoading();
  }

  @override
  Future<void> readyToLoad() {
    return super.readyToLoad();
  }

  @override
  void resetValue() {
    animationController.reset();
    super.resetValue();
  }

  @override
  Widget buildContent(BuildContext context, LoadStatus mode) {
    return !started
        ? Container()
        : Container(
            alignment: Alignment.center,
            height: 120,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Image.asset(
                  buildingPath,
                  alignment: Alignment.center,
                  height: 68,
                ),
                AnimatedBuilder(
                  animation: animationController,
                  builder: (BuildContext context, Widget _widget) {
                    var vv = animationController.value * 10 / 8 * pi;
                    vv = vv - 1 / 10 * pi;
                    return Container(
                      height: 160,
                      width: 160,
                      child: Align(
                        widthFactor: 1,
                        heightFactor: 1,
                        alignment: Alignment(
                          cos(vv),
                          -sin(vv),
                        ),
                        child: Transform.rotate(
                          angle: animationController.value * 10,
                          child: Container(
                            alignment: Alignment.center,
                            height: 40,
                            width: 40,
                            child: _widget,
                          ),
                        ),
                      ),
                    );
                  },
                  child: Image.asset(
                    sunPath,
                    alignment: Alignment.center,
                    height: 105,
                  ),
                ),
                Positioned(
                  top: 32,
                  left: 61,
                  child: AnimatedBuilder(
                    animation: animationController,
                    builder: (BuildContext context, Widget _widget) {
                      return Transform.rotate(
                        angle: animationController.value * 2 * 2 * pi - 5 / 4 * pi,
                        child: Container(
                          height: 40,
                          width: 40,
                          alignment: FractionalOffset.centerLeft,
                          child: _widget,
                        ),
                      );
                    },
                    child: Row(
                      children: <Widget>[
                        Container(
                          height: 2,
                          width: 12,
                        ),
                        Container(
                          height: 2,
                          width: 8,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 32,
                  left: 61,
                  child: AnimatedBuilder(
                    animation: animationController,
                    builder: (BuildContext context, Widget _widget) {
                      return Transform.rotate(
                        angle: animationController.value * 2 * 2 * pi * 12 + 1 / 2 * pi,
                        child: Container(
                          height: 40,
                          width: 40,
                          alignment: FractionalOffset.centerLeft,
                          child: _widget,
                        ),
                      );
                    },
                    child: Row(
                      children: <Widget>[
                        Container(
                          height: 2,
                          width: 10,
                        ),
                        Container(
                          height: 2,
                          width: 10,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
