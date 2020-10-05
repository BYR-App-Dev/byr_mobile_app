import 'package:audioplayers/audioplayers.dart';
import 'package:byr_mobile_app/customizations/theme_controller.dart';
import 'package:byr_mobile_app/local_objects/local_storage.dart';
import 'package:byr_mobile_app/pages/pages.dart';
import 'package:byr_mobile_app/reusable_components/overlay_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tinycolor/tinycolor.dart';
import 'package:tuple/tuple.dart';

class AudioPlayerView {
  static AudioPlayer audioPlayer;

  static int currentState = -1; // -1: closed, 0: nothing but shown, 1: playing, 2: paused

  static List<Map> musicList;

  static GlobalKey<MusicPlayerViewState> musicPlayerKey;

  static Set<String> musicUrls;

  static Duration currentProgress;
  static Duration currentFullDuration;

  static show(BuildContext context) {
    if (getCurrentState() == -1) {
      musicPlayerKey = GlobalKey<MusicPlayerViewState>();
      OverlayView.show(context: context, view: MusicPlayerView(musicPlayerKey));
      setCurrentState(0);
    }
  }

  static AudioPlayer getAudioPlayer() {
    if (audioPlayer == null) {
      audioPlayer = AudioPlayer();
      audioPlayer.onPlayerCompletion.listen((event) {
        currentProgress = null;
        currentFullDuration = null;
        onComplete();
      });
      audioPlayer.onDurationChanged.listen((Duration d) {
        currentFullDuration = d;
        reloadMusicView();
      });
      audioPlayer.onAudioPositionChanged.listen((Duration p) {
        currentProgress = p;
        reloadMusicView();
      });
      audioPlayer.onPlayerError.listen((msg) {
        setCurrentState(0);
      });
    }
    return audioPlayer;
  }

  static String getProgress() {
    String pr = currentProgress == null
        ? "-"
        : currentProgress.inMinutes.toString().padLeft(2, "0") +
            ":" +
            (currentProgress.inSeconds % 60).toString().padLeft(2, "0");
    String fl = currentFullDuration == null
        ? "-"
        : currentFullDuration.inMinutes.toString().padLeft(2, "0") +
            ":" +
            (currentFullDuration.inSeconds % 60).toString().padLeft(2, "0");
    return pr + "/" + fl;
  }

  static onComplete() {
    AudioPlayerView.getAudioPlayer().stop();
    currentProgress = null;
    currentFullDuration = null;
    if (getMusicList().length > 0) {
      var audio = getMusicList().removeAt(0);
      getMusicList().insert(getMusicList().length, audio);
      AudioPlayerView.getAudioPlayer()
          .play(getMusicList()[0]["url"], stayAwake: true, isLocal: getMusicList()[0]["isLocal"]);
    }
    reloadMusicView();
  }

  static Set<String> getMusicUrlSet() {
    if (musicUrls == null) {
      musicUrls = Set<String>();
      getMusicList().forEach((element) {
        musicUrls.add(element["url"]);
      });
    }
    return musicUrls;
  }

  static List<Map> getMusicList() {
    if (musicList == null) {
      musicList = LocalStorage.getMusicList();
    }
    return musicList;
  }

  static clearMusicList() {
    getMusicUrlSet().clear();
    musicUrls = null;
    getMusicList().clear();
    musicList = null;
  }

  static Map getCurrentPlaying() {
    return getMusicList().length > 0 ? getMusicList()[0] : null;
  }

  static reloadMusicView() {
    if (musicPlayerKey != null && musicPlayerKey.currentState != null) {
      musicPlayerKey.currentState.reload();
    }
  }

  static addMusic(Tuple3<String, String, bool> audio, BuildContext context) {
    show(context);
    if (getMusicUrlSet().contains(audio.item2)) {
      return;
    }
    getMusicUrlSet().add(audio.item2);
    getMusicList().insert(getMusicList().length, {
      "title": audio.item1,
      "url": audio.item2,
      "isLocal": audio.item3,
    });
    LocalStorage.setMusicList(musicList);
    reloadMusicView();
  }

  static setCurrentPlaying(Tuple3<String, String, bool> audio, BuildContext context) {
    show(context);
    if (getMusicUrlSet().contains(audio.item2)) {
      return;
    }
    AudioPlayerView.getAudioPlayer().stop();
    getMusicUrlSet().add(audio.item2);
    getMusicList().insert(0, {
      "title": audio.item1,
      "url": audio.item2,
      "isLocal": audio.item3,
    });
    AudioPlayerView.getAudioPlayer().play(audio.item2, stayAwake: true, isLocal: getMusicList()[0]["isLocal"]);
    setCurrentState(1);
    reloadMusicView();
  }

  static getCurrentState() {
    return currentState;
  }

  static pause() {
    AudioPlayerView.getAudioPlayer().pause();
    return true;
  }

  static resume() {
    if (getCurrentState() == 0) {
      if ((getMusicList()?.length ?? 0) > 0) {
        AudioPlayerView.getAudioPlayer()
            .play(getMusicList()[0]["url"], stayAwake: true, isLocal: getMusicList()[0]["isLocal"]);
        return true;
      } else {
        return false;
      }
    } else {
      AudioPlayerView.getAudioPlayer().resume();
      return true;
    }
  }

  static stop() {
    AudioPlayerView.getAudioPlayer().stop();
    return true;
  }

  static dismiss() async {
    await AudioPlayerView.getAudioPlayer().stop();
    AudioPlayerView.getAudioPlayer().dispose();
    audioPlayer = null;
    // clearMusicList();
    return true;
  }

  static setCurrentState(int astate) async {
    bool r = false;
    if (astate == 2) {
      r = pause();
    } else if (astate == 1) {
      r = resume();
    } else if (astate == 0) {
      r = stop();
    } else if (astate == -1) {
      r = await dismiss();
    }
    if (r) {
      currentState = astate;
    }
    reloadMusicView();
  }

  static moveUp(int pos) {
    if ((getMusicList()?.length ?? 0) > 0) {
      if (pos < getMusicList().length && pos > 0) {
        if (pos == 1) {
          onComplete();
        } else {
          var x = getMusicList()[pos];
          getMusicList()[pos] = getMusicList()[pos - 1];
          getMusicList()[pos - 1] = x;
        }
        reloadMusicView();
      }
    }
  }

  static kick(int pos) {
    if (pos < getMusicList().length && pos > 0) {
      getMusicUrlSet().remove(getMusicList().removeAt(pos)["url"]);
      LocalStorage.setMusicList(musicList);
      reloadMusicView();
    }
  }
}

class MusicPlayerView extends StatefulWidget {
  MusicPlayerView(Key key) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MusicPlayerViewState();
  }
}

class MusicPlayerViewState extends State<MusicPlayerView> {
  bool showPlaylist;
  String progress;

  @override
  initState() {
    super.initState();
    showPlaylist = false;
    progress = "-/-";
  }

  reload() {
    progress = AudioPlayerView.getProgress();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        decoration: BoxDecoration(
            color: E().isThemeDarkStyle ? E().otherPagePrimaryColor.lighten(5) : E().otherPagePrimaryColor.darken(5),
            borderRadius: BorderRadius.all(Radius.circular(20)),
            border: Border.all(
              color:
                  E().isThemeDarkStyle ? E().otherPagePrimaryColor.lighten(10) : E().otherPagePrimaryColor.darken(10),
              width: 3,
            )),
        padding: EdgeInsets.all(5),
        child: IntrinsicWidth(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  GestureDetector(
                    child: Icon(
                      Icons.close,
                      color: E().otherPageSecondaryTextColor,
                    ),
                    onTap: () {
                      AudioPlayerView.setCurrentState(-1);
                      OverlayView.remove();
                    },
                  ),
                  Container(),
                  Text(
                    progress,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16,
                      color: E().otherPageSecondaryTextColor,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 180,
                    child: Text(
                      AudioPlayerView.getCurrentPlaying() == null ? " " : AudioPlayerView.getCurrentPlaying()["title"],
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        color: E().otherPagePrimaryTextColor,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FlatButton(
                    shape: CircleBorder(side: BorderSide.none),
                    child: Icon(
                      AudioPlayerView.getCurrentState() == 1 ? Icons.pause : Icons.play_arrow,
                      color: E().otherPageSecondaryTextColor,
                    ),
                    onPressed: () {
                      var tstate = AudioPlayerView.getCurrentState();
                      if (tstate == 1) {
                        AudioPlayerView.setCurrentState(2);
                      } else {
                        AudioPlayerView.setCurrentState(1);
                      }
                      if (mounted) {
                        setState(() {});
                      }
                    },
                  ),
                  FlatButton(
                    shape: CircleBorder(side: BorderSide.none),
                    child: Icon(
                      showPlaylist ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                      color: E().otherPageSecondaryTextColor,
                    ),
                    onPressed: () {
                      showPlaylist = !showPlaylist;
                      if (mounted) {
                        setState(() {});
                      }
                    },
                  ),
                ],
              ),
              showPlaylist
                  ? ConstrainedBox(
                      constraints: BoxConstraints(minHeight: 20, maxHeight: 300),
                      child: SingleChildScrollView(
                        child: Container(
                          child: Column(
                            children: AudioPlayerView.getMusicList().length > 0
                                ? AudioPlayerView.getMusicList()
                                    .asMap()
                                    .entries
                                    .toList()
                                    .sublist(1)
                                    .map<Widget>((entry) {
                                    return Container(
                                      width: 220,
                                      padding: EdgeInsets.all(5),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          GestureDetector(
                                            child: Icon(
                                              Icons.arrow_upward,
                                              color: E().otherPageSecondaryTextColor,
                                            ),
                                            onTap: () {
                                              AudioPlayerView.moveUp(entry.key);
                                            },
                                          ),
                                          Expanded(
                                            child: Text(
                                              entry.value["title"],
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: E().otherPagePrimaryTextColor,
                                                decoration: TextDecoration.none,
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            child: Icon(
                                              Icons.remove_circle_outline,
                                              color: E().otherPageSecondaryTextColor,
                                            ),
                                            onTap: () {
                                              AudioPlayerView.kick(entry.key);
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList()
                                : [],
                          ),
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
