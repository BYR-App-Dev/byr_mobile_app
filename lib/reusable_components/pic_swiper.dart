import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:byr_mobile_app/nforum/nforum_service.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:flutter/rendering.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';

import 'adaptive_components.dart';

double initScale({Size imageSize, Size size, double initialScale}) {
  var n1 = imageSize.height / imageSize.width;
  var n2 = size.height / size.width;
  if (n1 > n2) {
    final FittedSizes fittedSizes = applyBoxFit(BoxFit.contain, imageSize, size);
    Size destinationSize = fittedSizes.destination;
    return destinationSize.height / size.height;
  } else if (n1 / n2 < 1 / 4) {
    final FittedSizes fittedSizes = applyBoxFit(BoxFit.contain, imageSize, size);
    Size destinationSize = fittedSizes.destination;
    return destinationSize.width / size.width;
  }
  return initialScale;
}

Future<bool> saveNetworkImageToPhoto(String url, {bool useCache: true}) async {
  var img = await NForumService.getImage(url);
  return await GallerySaver.saveImage(img.path, albumName: 'BYRDownload');
}

class PicSwiperItem {
  final String picUrl;
  final String des;
  PicSwiperItem({
    @required this.picUrl,
    this.des = "",
  });
}

class PicSwiper extends StatefulWidget {
  final int index;
  final List<PicSwiperItem> pics;
  PicSwiper({this.index, this.pics});
  @override
  _PicSwiperState createState() => _PicSwiperState();
}

class _PicSwiperState extends State<PicSwiper> with SingleTickerProviderStateMixin {
  var rebuildIndex = StreamController<int>.broadcast();
  var rebuildSwiper = StreamController<bool>.broadcast();
  AnimationController _animationController;
  Animation<double> _animation;
  Function animationListener;
  List<double> doubleTapScales = <double>[1.0, 2.0];
  GlobalKey<ExtendedImageSlidePageState> slidePagekey = GlobalKey<ExtendedImageSlidePageState>();
  int currentIndex;
  bool _showSwiper = true;

  @override
  void initState() {
    currentIndex = widget.index;
    _animationController = AnimationController(duration: const Duration(milliseconds: 150), vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    rebuildIndex.close();
    rebuildSwiper.close();
    _animationController?.dispose();
    clearGestureDetailsCache();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    Widget result = Material(
        color: Colors.black,
        shadowColor: Colors.transparent,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            ExtendedImageGesturePageView.builder(
              itemBuilder: (BuildContext context, int index) {
                var item = widget.pics[index].picUrl;
                Widget image = ExtendedImage.network(
                  item,
                  fit: BoxFit.contain,
                  enableSlideOutPage: true,
                  mode: ExtendedImageMode.gesture,
                  heroBuilderForSlidingPage: (Widget result) {
                    if (index < min(9, widget.pics.length)) {
                      return Hero(
                        tag: item,
                        child: result,
                        flightShuttleBuilder: (BuildContext flightContext, Animation<double> animation, HeroFlightDirection flightDirection,
                            BuildContext fromHeroContext, BuildContext toHeroContext) {
                          final Hero hero = flightDirection == HeroFlightDirection.pop ? fromHeroContext.widget : toHeroContext.widget;
                          return hero.child;
                        },
                      );
                    } else {
                      return result;
                    }
                  },
                  initGestureConfigHandler: (state) {
                    double initialScale = 1.0;
                    if (state.extendedImageInfo != null && state.extendedImageInfo.image != null) {
                      initialScale = initScale(
                          size: size,
                          initialScale: initialScale,
                          imageSize: Size(state.extendedImageInfo.image.width.toDouble(), state.extendedImageInfo.image.height.toDouble()));
                    }
                    return GestureConfig(
                        inPageView: true,
                        initialScale: initialScale,
                        minScale: min(initialScale, 0.8),
                        maxScale: max(initialScale, 5.0),
                        animationMaxScale: max(initialScale, 5.0),
                        initialAlignment: InitialAlignment.center,
                        cacheGesture: false);
                  },
                  onDoubleTap: (ExtendedImageGestureState state) {
                    var pointerDownPosition = state.pointerDownPosition;
                    double begin = state.gestureDetails.totalScale;
                    double end;
                    _animation?.removeListener(animationListener);
                    _animationController.stop();
                    _animationController.reset();
                    if (begin == doubleTapScales[0]) {
                      end = doubleTapScales[1];
                    } else {
                      end = doubleTapScales[0];
                    }
                    animationListener = () {
                      state.handleDoubleTap(scale: _animation.value, doubleTapPosition: pointerDownPosition);
                    };
                    _animation = _animationController.drive(Tween<double>(begin: begin, end: end));
                    _animation.addListener(animationListener);
                    _animationController.forward();
                  },
                );
                image = GestureDetector(
                  child: image,
                  onTap: () {
                    slidePagekey.currentState.popPage();
                    Navigator.pop(context);
                  },
                );
                return image;
              },
              itemCount: widget.pics.length,
              onPageChanged: (int index) {
                currentIndex = index;
                rebuildIndex.add(index);
              },
              controller: PageController(
                initialPage: currentIndex,
              ),
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
            ),
            StreamBuilder<bool>(
              builder: (c, d) {
                if (d.data == null || !d.data) return Container();
                return Positioned(
                  bottom: 0.0,
                  top: 0.0,
                  left: 0.0,
                  right: 0.0,
                  child: MySwiperPlugin(widget.pics, currentIndex, rebuildIndex),
                );
              },
              initialData: true,
              stream: rebuildSwiper.stream,
            )
          ],
        ));
    result = ExtendedImageSlidePage(
      key: slidePagekey,
      child: result,
      slideAxis: SlideAxis.both,
      slideType: SlideType.onlyImage,
      onSlidingPage: (state) {
        var showSwiper = !state.isSliding;
        if (showSwiper != _showSwiper) {
          _showSwiper = showSwiper;
          rebuildSwiper.add(_showSwiper);
        }
      },
    );
    return result;
  }
}

class MySwiperPlugin extends StatelessWidget {
  final List<PicSwiperItem> pics;
  final int index;
  final StreamController<int> reBuild;
  MySwiperPlugin(this.pics, this.index, this.reBuild);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      builder: (BuildContext context, data) {
        return Stack(
          children: <Widget>[
            Positioned(
              top: 25,
              left: 0.0,
              right: 0.0,
              child: SafeArea(
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    "${data.data + 1}/${pics.length}",
                    style: TextStyle(color: Colors.white, fontSize: 18.0),
                  ),
                ),
              ),
            ),
            if (!kIsWeb)
              Positioned(
                bottom: 25,
                left: 0.0,
                right: 10.0,
                child: SafeArea(
                  child: GestureDetector(
                    onTap: () async {
                      var toDownload = index;
                      if (data.hasData) {
                        toDownload = data.data;
                      }
                      bool success = await saveNetworkImageToPhoto(pics[toDownload].picUrl);
                      String result = success ? "succeed".tr : "fail".tr;
                      AdaptiveComponents.showToast(context, "saveTrans".tr + result);
                    },
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: Container(
                        width: 40,
                        height: 40,
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Icon(
                          Icons.save_alt,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
      initialData: index,
      stream: reBuild.stream,
    );
  }
}
