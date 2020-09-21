import 'package:byr_mobile_app/customizations/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class VideoPage extends StatefulWidget {
  final String resourceUrl;
  VideoPage(this.resourceUrl);
  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  VideoPlayerController _controller;

  bool showMenu;

  @override
  void initState() {
    super.initState();
    showMenu = true;
    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    _controller = VideoPlayerController.network(widget.resourceUrl, formatHint: VideoFormat.hls)
      ..initialize().then((_) {
        if (mounted) {
          setState(() {});
        }
      })
      ..addListener(() {
        if (mounted) {
          setState(() {});
        }
      });
  }

  void toggleMenu() {
    if (showMenu == true) {
      closeMenu();
    } else {
      openMenu();
    }
  }

  void openMenu() {
    showMenu = true;
    // SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    // BYRThemeManager.instance().updateNonWidgetParts();
    if (mounted) {
      setState(() {});
    }
  }

  void closeMenu() {
    showMenu = false;
    // SystemChrome.setEnabledSystemUIOverlays([]);
    // BYRThemeManager.instance().updateNonWidgetParts();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void didUpdateWidget(VideoPage oldWidget) {
    if (oldWidget.resourceUrl != widget.resourceUrl) {
      _controller.dispose();
      _controller = VideoPlayerController.network(widget.resourceUrl, formatHint: VideoFormat.hls)
        ..initialize().then((_) {
          if (mounted) {
            setState(() {});
          }
        })
        ..addListener(() {
          if (mounted) {
            setState(() {});
          }
        });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            _controller.value.initialized
                ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  )
                : Container(),
            GestureDetector(
              child: SizedBox.expand(
                child: Container(
                  color: E().otherPagePrimaryColor.withOpacity(0.1),
                ),
              ),
              onTap: () {
                toggleMenu();
              },
            ),
            if (showMenu)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: E().otherPagePrimaryColor,
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.close,
                        color: E().otherPageButtonColor,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: E().otherPagePrimaryColor,
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        if (_controller.value.buffered.indexWhere((element) {
                              return element.start < (_controller.value.position + Duration(seconds: 1)) &&
                                  element.end > (_controller.value.position + Duration(seconds: 1));
                            }) ==
                            -1)
                          CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              E().otherPageButtonColor,
                            ),
                          ),
                        IconButton(
                          icon: Icon(
                            _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                            color: E().otherPageButtonColor,
                          ),
                          onPressed: () {
                            if (_controller.value.isPlaying) {
                              _controller.pause();
                              openMenu();
                            } else {
                              _controller.play();
                              closeMenu();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            if (showMenu)
              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      color: E().otherPagePrimaryColor,
                      child: Text(
                        (_controller?.value?.position == null
                                ? "-"
                                : _controller.value.position.toString().split(".")[0]) +
                            " / " +
                            (_controller?.value?.duration == null
                                ? "-"
                                : _controller.value.duration.toString().split(".")[0]),
                        style: TextStyle(color: E().otherPagePrimaryTextColor),
                      ),
                    ),
                    VideoProgressIndicator(
                      _controller,
                      colors: VideoProgressColors(
                        backgroundColor: E().otherPagePrimaryColor,
                        bufferedColor: E().otherPageSecondaryColor,
                        playedColor: E().otherPageButtonColor,
                      ),
                      allowScrubbing: true,
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.dispose();
    _controller.dispose();
  }
}
