import 'dart:async';
import 'dart:io' as io;

import 'package:audioplayers/audioplayers.dart';
import 'package:byr_mobile_app/customizations/theme_controller.dart';
import 'package:file/local.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

class RecorderDialog extends StatefulWidget {
  final LocalFileSystem localFileSystem;

  RecorderDialog({localFileSystem}) : this.localFileSystem = localFileSystem ?? LocalFileSystem();

  @override
  State<StatefulWidget> createState() => RecorderDialogState();
}

class RecorderDialogState extends State<RecorderDialog> {
  FlutterAudioRecorder _recorder;
  Recording _current;
  RecordingStatus _currentStatus = RecordingStatus.Unset;

  AudioPlayer audioPlayer;

  bool permitted;

  String recordingPath;

  Timer ticker;

  @override
  void initState() {
    super.initState();
    permitted = true;
    recordingPath = null;
  }

  removeEverythingAndPop() async {
    await removeEverything();
    Navigator.of(context).pop();
  }

  Future removeEverything() async {
    if (_recorder != null) {
      var status = (await _recorder.current()).status;
      if (status != RecordingStatus.Unset && status != RecordingStatus.Stopped) {
        await _recorder.stop();
      }
    }
    if (audioPlayer != null) {
      await audioPlayer.stop();
      audioPlayer.dispose();
      audioPlayer = null;
    }
    if (ticker != null) {
      ticker.cancel();
    }
  }

  @override
  void dispose() {
    removeEverything().then((value) {
      super.dispose();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: E().dialogBackgroundColor,
      actions: <Widget>[
        FlatButton(
          child: Text("confirmTrans".tr),
          onPressed: () {
            Navigator.of(context).pop(recordingPath);
          },
        ),
        FlatButton(
          child: Text("cancelTrans".tr),
          onPressed: () {
            removeEverythingAndPop();
          },
        ),
      ],
      content: Container(
        padding: EdgeInsets.all(8.0),
        child: permitted
            ? Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                    Text(
                        (_current != null && _current.duration != null)
                            ? (_current.duration.inMinutes.toString().padLeft(2, '0') +
                                ":" +
                                _current.duration.inSeconds.toString().padLeft(2, '0'))
                            : "00:00",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: E().dialogTitleColor)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FlatButton(
                            onPressed: () {
                              switch (_currentStatus) {
                                case RecordingStatus.Unset:
                                  {
                                    _initAndStart();
                                    break;
                                  }
                                case RecordingStatus.Initialized:
                                  {
                                    _start();
                                    break;
                                  }
                                case RecordingStatus.Recording:
                                  {
                                    _stop();
                                    break;
                                  }
                                case RecordingStatus.Paused:
                                  {
                                    _stop();
                                    break;
                                  }
                                case RecordingStatus.Stopped:
                                  {
                                    _initAndStart();
                                    break;
                                  }

                                default:
                                  break;
                              }
                            },
                            child: _buildRecodingButton(_currentStatus),
                          ),
                        ),
                        Visibility(
                          visible:
                              _currentStatus == RecordingStatus.Recording || _currentStatus == RecordingStatus.Paused,
                          child: FlatButton(
                            onPressed:
                                _currentStatus == RecordingStatus.Recording || _currentStatus == RecordingStatus.Paused
                                    ? (_currentStatus == RecordingStatus.Paused ? _resume : _pause)
                                    : null,
                            child: _currentStatus == RecordingStatus.Paused
                                ? Icon(
                                    Icons.play_arrow,
                                    color: E().dialogTitleColor,
                                  )
                                : Icon(
                                    Icons.pause,
                                    color: E().dialogTitleColor,
                                  ),
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Visibility(
                          visible: _currentStatus == RecordingStatus.Stopped,
                          child: FlatButton(
                            onPressed: onPlayAudio,
                            child: Icon(
                              Icons.headset,
                              color: E().dialogTitleColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ])
            : Text("need permission to record"),
      ),
    );
  }

  _init() async {
    try {
      if (await FlutterAudioRecorder.hasPermissions) {
        permitted = true;
        String customPath = '/audio_recording_';
        io.Directory tempDir = await getTemporaryDirectory();
        String tempPath = tempDir.path;
        customPath = tempPath + customPath + DateTime.now().millisecondsSinceEpoch.toString() + ".aac";

        _recorder = FlutterAudioRecorder(customPath, audioFormat: AudioFormat.AAC);
        recordingPath = customPath;

        await _recorder.initialized;
        var current = await _recorder.current(channel: 0);
        _current = current;
        _currentStatus = current.status;
        if (mounted) {
          setState(() {});
        }
      } else {
        permitted = false;
      }
    } catch (e) {
      permitted = false;
    }
  }

  _initAndStart() async {
    await _init();
    _start();
  }

  _start() async {
    try {
      if (audioPlayer != null) {
        await audioPlayer.stop();
      }
      await _recorder.start();
      var recording = await _recorder.current(channel: 0);
      _current = recording;
      if (mounted) {
        setState(() {});
      }

      const tick = const Duration(milliseconds: 50);
      ticker = Timer.periodic(tick, (Timer t) async {
        if (_currentStatus == RecordingStatus.Stopped) {
          t.cancel();
        }

        var current = await _recorder.current(channel: 0);
        _current = current;
        _currentStatus = _current.status;
        if (mounted) {
          setState(() {});
        }
      });
    } catch (e) {}
  }

  _resume() async {
    await _recorder.resume();
    if (mounted) {
      setState(() {});
    }
  }

  _pause() async {
    await _recorder.pause();
    if (mounted) {
      setState(() {});
    }
  }

  _stop() async {
    var result = await _recorder.stop();
    // File file = widget.localFileSystem.file(result.path);
    _current = result;
    _currentStatus = _current.status;
    if (mounted) {
      setState(() {});
    }
  }

  Widget _buildRecodingButton(RecordingStatus status) {
    IconData icon;
    switch (_currentStatus) {
      case RecordingStatus.Unset:
        {
          icon = Icons.mic;
          break;
        }
      case RecordingStatus.Initialized:
        {
          icon = Icons.mic;
          break;
        }
      case RecordingStatus.Recording:
        {
          icon = Icons.stop;
          break;
        }
      case RecordingStatus.Paused:
        {
          icon = Icons.stop;
          break;
        }
      case RecordingStatus.Stopped:
        {
          icon = Icons.mic;
          break;
        }
      default:
        break;
    }
    return Icon(
      icon,
      color: E().dialogTitleColor,
    );
  }

  void onPlayAudio() async {
    if (audioPlayer == null) {
      audioPlayer = AudioPlayer();
    }
    await audioPlayer.stop();
    await audioPlayer.play(recordingPath, isLocal: true);
  }
}
