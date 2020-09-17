import 'package:flutter/material.dart' hide RefreshIndicator, RefreshIndicatorState;
import 'package:flutter/widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class BUPTHeartBeatHeader extends RefreshIndicator {
  BUPTHeartBeatHeader()
      : super(height: recommendedHeight, refreshStyle: RefreshStyle.Follow, completeDuration: Duration(seconds: 2));

  static double recommendedHeight = 80;

  @override
  State<StatefulWidget> createState() {
    return BUPTHeartBeatHeaderState();
  }
}

class BUPTHeartBeatHeaderState extends RefreshIndicatorState with SingleTickerProviderStateMixin {
  AnimationController animationController;
  List<Color> colors = [Colors.blue, Colors.yellow, Colors.red];
  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
      lowerBound: 0,
      upperBound: 3,
    );
  }

  @override
  void onModeChange(RefreshStatus mode) {
    if (mode == RefreshStatus.refreshing) {
      animationController.repeat();
    }
    super.onModeChange(mode);
  }

  @override
  Future<void> endRefresh() {
    return super.endRefresh();
  }

  @override
  void resetValue() {
    animationController.reset();
    super.resetValue();
  }

  @override
  Widget buildContent(BuildContext context, RefreshStatus mode) {
    var imagePath = './resources/refresher/bupt_heart_beat/bupt-line.png';
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget _widget) {
        var current = animationController.value.floor() % 3;
        var doing = (current + 1) % 3;
        return Center(
          child: Stack(
            children: [
              ClipRect(
                clipper: CustomRect(animationController.value % 1, true),
                child: ColorFiltered(
                  colorFilter: ColorFilter.mode(colors[current], BlendMode.srcIn),
                  child: _widget,
                ),
              ),
              ClipRect(
                clipper: CustomRect(animationController.value % 1, false),
                child: ColorFiltered(
                  colorFilter: ColorFilter.mode(colors[doing], BlendMode.srcIn),
                  child: _widget,
                ),
              ),
            ],
          ),
        );
      },
      child: Image.asset(
        imagePath,
        height: 80,
      ),
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}

class CustomRect extends CustomClipper<Rect> {
  final double width;
  final bool isRight;
  CustomRect(this.width, this.isRight) : super();

  @override
  Rect getClip(Size size) {
    if (!isRight) {
      Rect rect = Rect.fromLTRB(0.0, 0.0, size.width * this.width, size.height);
      return rect;
    } else {
      Rect rect = Rect.fromLTRB(size.width * this.width, 0.0, size.width, size.height);
      return rect;
    }
  }

  @override
  bool shouldReclip(CustomRect oldClipper) {
    return true;
  }
}

class BUPTHeartBeatFooter extends LoadIndicator {
  final VoidCallback onClick;
  BUPTHeartBeatFooter({this.onClick})
      : super(onClick: onClick, loadStyle: LoadStyle.ShowWhenLoading, height: recommendedHeight);

  static double recommendedHeight = 80;

  @override
  State<StatefulWidget> createState() {
    return _BUPTHeartBeatFooterState();
  }
}

class _BUPTHeartBeatFooterState extends LoadIndicatorState<BUPTHeartBeatFooter> with SingleTickerProviderStateMixin {
  var imagePath = './resources/refresher/bupt_heart_beat/bupt-line.png';
  AnimationController animationController;
  List<Color> colors = [Colors.blue, Colors.yellow, Colors.red];
  bool started = false;
  bool stopNextLoop = false;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 12),
      lowerBound: 0,
      upperBound: 6,
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
        : AnimatedBuilder(
            animation: animationController,
            builder: (BuildContext context, Widget _widget) {
              var current = animationController.value.floor() % 3;
              var doing = animationController.value.floor() % 2;
              return Center(
                child: Stack(
                  children: [
                    ClipRect(
                      clipper: CustomRect2(
                          doing == 0 ? animationController.value % 1 * .7 : (1 - animationController.value % 1) * .7,
                          doing == 0
                              ? animationController.value % 1 * .7 + 0.3
                              : (1 - animationController.value % 1) * .7 + 0.3),
                      child: ColorFiltered(
                        colorFilter: ColorFilter.mode(colors[current], BlendMode.srcIn),
                        child: _widget,
                      ),
                    ),
                  ],
                ),
              );
            },
            child: Image.asset(
              imagePath,
              height: 80,
            ),
          );
  }
}

class CustomRect2 extends CustomClipper<Rect> {
  final double startWitdh;
  final double width;
  CustomRect2(this.startWitdh, this.width) : super();

  @override
  Rect getClip(Size size) {
    Rect rect = Rect.fromLTRB(size.width * this.startWitdh, 0.0, size.width * this.width, size.height);
    return rect;
  }

  @override
  bool shouldReclip(CustomRect2 oldClipper) {
    return true;
  }
}
