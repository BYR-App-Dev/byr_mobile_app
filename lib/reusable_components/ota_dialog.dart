import 'package:byr_mobile_app/customizations/theme_controller.dart';
import 'package:byr_mobile_app/local_objects/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:ota_update/ota_update.dart';
import 'package:get/get.dart';

class OTADialog extends StatefulWidget {
  final String version;
  final String link;
  final String updateContent;
  OTADialog(this.version, this.link, {this.updateContent = " "});
  @override
  _OTADialogState createState() => _OTADialogState();
}

class _OTADialogState extends State<OTADialog> {
  double _percentage = 0;
  bool _started = false;
  String _statusString = '';
  ScrollController controller;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    controller = ScrollController(initialScrollOffset: 0.5);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: E().dialogBackgroundColor,
      title: Text("newVersion".tr + ": " + widget.version, style: TextStyle(color: E().dialogTitleColor)),
      content: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 200,
              child: Scrollbar(
                controller: controller,
                isAlwaysShown: true,
                child: SingleChildScrollView(
                  controller: controller,
                  child: Container(
                    child: Text(
                      widget.updateContent,
                      style: TextStyle(color: E().dialogContentColor),
                    ),
                    padding: EdgeInsets.all(10),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: _started,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    child: Text(
                      _statusString,
                      style: TextStyle(color: E().dialogContentColor),
                    ),
                    padding: EdgeInsets.all(10),
                  ),
                  LinearProgressIndicator(
                    value: _percentage + 1 / 100,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text("update".tr),
          onPressed: () {
            if (_started) {
              return;
            }
            try {
              OtaUpdate().execute(widget.link, destinationFilename: 'byr_mobile_app.apk').listen(
                (OtaEvent event) {
                  if (event.status == OtaStatus.DOWNLOADING) {
                    _percentage = (int.tryParse(event.value) ?? _percentage) / 100;
                    if (mounted) {
                      setState(() {});
                    }
                  } else if (event.status == OtaStatus.INSTALLING) {
                    Navigator.of(context).pop();
                  }
                },
              );
              _statusString = "downloadImageTrans".tr;
              _started = true;
              if (mounted) {
                setState(() {});
              }
            } catch (e) {
              _statusString = "fail".tr;
              if (mounted) {
                setState(() {});
              }
            }
          },
        ),
        FlatButton(
          child: Text("ignoreVersion".tr),
          onPressed: () {
            LocalStorage.setIgnoreVersion(widget.version);
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text("cancelTrans".tr),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
