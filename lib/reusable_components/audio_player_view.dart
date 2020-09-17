import 'package:audioplayers/audioplayers.dart';
import 'package:byr_mobile_app/customizations/theme_controller.dart';
import 'package:byr_mobile_app/reusable_components/overlay_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tinycolor/tinycolor.dart';
import 'package:tuple/tuple.dart';

class AudioPlayerView {
  static AudioPlayer audioPlayer;

  static int currentState = -1; // -1: closed, 0: nothing but shown, 1: playing, 2: paused

  static List<Tuple3<String, String, bool>> musicList;

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
      AudioPlayerView.getAudioPlayer().play(getMusicList()[0].item2, stayAwake: true, isLocal: getMusicList()[0].item3);
    }
    reloadMusicView();
  }

  static Set<String> getMusicUrlSet() {
    if (musicUrls == null) {
      musicUrls = Set<String>();
    }
    return musicUrls;
  }

  static List<Tuple3<String, String, bool>> getMusicList() {
    if (musicList == null) {
      musicList = List<Tuple3<String, String, bool>>();
    }
    return musicList;
  }

  static clearMusicList() {
    getMusicList().clear();
    getMusicUrlSet().clear();
  }

  static Tuple3<String, String, bool> getCurrentPlaying() {
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
    getMusicList().insert(getMusicList().length, audio);
    reloadMusicView();
  }

  static setCurrentPlaying(Tuple3<String, String, bool> audio, BuildContext context) {
    show(context);
    if (getMusicUrlSet().contains(audio.item2)) {
      return;
    }
    AudioPlayerView.getAudioPlayer().stop();
    getMusicUrlSet().add(audio.item2);
    getMusicList().insert(0, audio);
    AudioPlayerView.getAudioPlayer().play(audio.item2, stayAwake: true, isLocal: getMusicList()[0].item3);
    setCurrentState(1);
    reloadMusicView();
  }

  static getCurrentState() {
    return currentState;
  }

  static pause() {
    AudioPlayerView.getAudioPlayer().pause();
  }

  static resume() {
    if (getCurrentState() == 0) {
      AudioPlayerView.getAudioPlayer().play(getMusicList()[0].item2, stayAwake: true, isLocal: getMusicList()[0].item3);
    } else {
      AudioPlayerView.getAudioPlayer().resume();
    }
  }

  static stop() {
    AudioPlayerView.getAudioPlayer().stop();
  }

  static dismiss() async {
    await AudioPlayerView.getAudioPlayer().stop();
    AudioPlayerView.getAudioPlayer().dispose();
    audioPlayer = null;
    clearMusicList();
  }

  static setCurrentState(int astate) {
    if (astate == 2) {
      pause();
    } else if (astate == 1) {
      resume();
    } else if (astate == 0) {
      stop();
    } else if (astate == -1) {
      dismiss();
    }
    currentState = astate;
    reloadMusicView();
  }

  static moveUp(int pos) {
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

  static kick(int pos) {
    if (pos < getMusicList().length && pos > 0) {
      getMusicList().removeAt(pos);
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
    return Container(
      decoration: BoxDecoration(
          color: E().otherPagePrimaryColor.darken(5), borderRadius: BorderRadius.all(Radius.circular(20))),
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
                    color: E().otherPageButtonColor,
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
                    color: E().otherPageButtonColor,
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
                    AudioPlayerView.getCurrentPlaying() == null ? " " : AudioPlayerView.getCurrentPlaying().item1,
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
                RaisedButton(
                  shape: RoundedRectangleBorder(
                      side: BorderSide.none, borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Icon(
                    AudioPlayerView.getCurrentState() == 1 ? Icons.pause : Icons.play_arrow,
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
                RaisedButton(
                  shape: RoundedRectangleBorder(
                      side: BorderSide.none, borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Icon(
                    showPlaylist ? Icons.arrow_drop_up : Icons.arrow_drop_down,
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
                ? Container(
                    child: SingleChildScrollView(
                      child: Container(
                        child: Column(
                          children: AudioPlayerView.getMusicList().length > 0
                              ? AudioPlayerView.getMusicList().asMap().entries.toList().sublist(1).map<Widget>((entry) {
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
                                            color: E().otherPagePrimaryTextColor,
                                          ),
                                          onTap: () {
                                            AudioPlayerView.moveUp(entry.key);
                                          },
                                        ),
                                        Expanded(
                                          child: Text(
                                            entry.value.item1,
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
                                            color: E().otherPagePrimaryTextColor,
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
    );
  }
}
