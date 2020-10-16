import 'dart:convert';

import 'package:byr_mobile_app/helper/helper.dart';
import 'package:byr_mobile_app/nforum/nforum_structures.dart';
import 'package:byr_mobile_app/shared_objects/shared_objects.dart';
import 'package:flutter/material.dart';
import 'package:flutter_liquidcore/liquidcore.dart';

class MicroPluginPage extends StatefulWidget {
  final String pluginName;
  final String pluginURI;

  const MicroPluginPage({Key key, this.pluginName, this.pluginURI}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return MicroPluginPageState();
  }
}

class MicroPluginPageState extends State<MicroPluginPage> {
  static const double coreVersion = 1;
  MicroService _microService;

  @override
  void initState() {
    super.initState();
    initMicroService();
  }

  bool started = false;
  Map layoutMap;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pluginName),
      ),
      body: Center(
        child: layout(this.layoutMap) ??
            (started
                ? RaisedButton(
                    child: Text('启动小程序'),
                    onPressed: startPlugin,
                  )
                : Text("loading")),
      ),
    );
  }

  void initMicroService() async {
    if (_microService == null) {
      try {
        String uri;
        uri = widget.pluginURI;
        _microService = new MicroService(
          uri,
          (MicroService service) {},
          (MicroService service, error) {},
          (MicroService service, int exitCode) {},
        );
        await _microService.addEventListener('ready', (service, event, eventPayload) {
          if (!mounted) {
            return;
          }
          _emit('getLayout', content: "").catchError((e) {});
        });

        await _microService.addEventListener('coreVersion', (service, event, eventPayload) {
          if (!mounted) {
            return;
          }
          _emit('getCoreVersion', content: coreVersion).catchError((e) {});
        });

        await _microService.addEventListener('getUserId', (service, event, eventPayload) async {
          UserModel me;
          if (SharedObjects.me != null) {
            me = await SharedObjects.me;
          }
          if (me != null) {
            _emit("callbackUserId", content: {
              "id": me.id,
            }).catchError((e) {});
          }
        });

        await _microService.addEventListener('layout', (service, event, eventPayload) {
          if (!mounted) {
            return;
          }

          _setMicroServiceLayoutResponse(eventPayload['message'] as Map);
        });

        await _microService.addEventListener('dialog', (service, event, eventPayload) {
          if (!mounted) {
            return;
          }

          _setMicroServiceDialogResponse(eventPayload['message'] as Map);
        });

        await _microService.addEventListener('controllerModification', (service, event, eventPayload) {
          if (!mounted) {
            return;
          }

          _setMicroServiceControllerModificationResponse(eventPayload['message'] as Map);
        });

        await _microService.start();
        started = true;
      } catch (e) {
        started = false;
      }
    }
    if (mounted) {
      setState(() {});
    }
  }

  void startPlugin() {
    if (_microService.isStarted) {
      _emit('getLayout', content: "").catchError((e) {});
    }
  }

  Future<void> _emit(String head, {dynamic content}) async {
    await _microService.emit(head, content).catchError((e) {});
  }

  void _setMicroServiceLayoutResponse(Map layoutMap) {
    if (!mounted) {
      return;
    }
    this.layoutMap = layoutMap;
    setState(() {});
  }

  void _setMicroServiceControllerModificationResponse(Map controllerMap) {
    if (!mounted) {
      return;
    }

    if (controllerMap != null && controllerMap.entries.length > 0) {
      controllerMap.entries.forEach((element) {
        if (controllers[element.key] != null && controllers[element.key]["valueModifier"] != null) {
          controllers[element.key]["valueModifier"](element.value);
        }
      });
      setState(() {});
    }
  }

  // TODO dialog
  void _setMicroServiceDialogResponse(Map dialogMap) {
    if (!mounted) {
      return;
    }
  }

  Map<String, Map<String, dynamic>> controllers = {};

  Widget retrieveWidget(Map m) {
    if (m == null) {
      return null;
    }
    switch (m["type"]) {
      case "TextFormField":
        TextEditingController c;
        if (m["controllerId"] != null) {
          if (controllers[m["controllerId"]] == null) {
            controllers[m["controllerId"]] = {
              "controller": TextEditingController(),
              "valueFetcher": () {
                return (controllers[m["controllerId"]]["controller"] as TextEditingController).text;
              },
              "valueModifier": (dynamic v) {
                return ((controllers[m["controllerId"]]["controller"] as TextEditingController).text = v);
              },
              "disposer": () {
                (controllers[m["controllerId"]]["controller"] as TextEditingController).dispose();
              },
            };
          }
          c = controllers[m["controllerId"]]["controller"];
        }
        return TextFormField(
          autocorrect: false,
          controller: c ?? null,
          decoration: InputDecoration(hintText: m["hint"] ?? ""),
        );
      case "SingleChildScrollView":
        return SingleChildScrollView(
          child: retrieveWidget(m["child"]),
        );
      case "Column":
        return Column(
          mainAxisAlignment: Helper.mainAxisAlignmentFromString(m["mainAxisAlignment"]),
          crossAxisAlignment: Helper.crossAxisAlignmentFromString(m["crossAxisAlignment"]),
          mainAxisSize: Helper.mainAxisSizeFromString(m["mainAxisSize"]),
          children: (m["children"] as List).map<Widget>((e) {
            return retrieveWidget(e);
          }).toList(),
        );
      case "Row":
        return Row(
          mainAxisAlignment: Helper.mainAxisAlignmentFromString(m["mainAxisAlignment"]),
          crossAxisAlignment: Helper.crossAxisAlignmentFromString(m["crossAxisAlignment"]),
          mainAxisSize: Helper.mainAxisSizeFromString(m["mainAxisSize"]),
          children: (m["children"] as List).map<Widget>((e) {
            return retrieveWidget(e);
          }).toList(),
        );
      case "Container":
        return Container(
          alignment: Helper.alignmentGeometryFromString(m["alignment"]),
          padding: EdgeInsets.fromLTRB(
            double.tryParse(m["paddingLeft"] ?? '') ?? 0,
            double.tryParse(m["paddingTop"] ?? '') ?? 0,
            double.tryParse(m["paddingRight"] ?? '') ?? 0,
            double.tryParse(m["paddingBottom"] ?? '') ?? 0,
          ),
          margin: EdgeInsets.fromLTRB(
            double.tryParse(m["paddingLeft"] ?? '') ?? 0,
            double.tryParse(m["paddingTop"] ?? '') ?? 0,
            double.tryParse(m["paddingRight"] ?? '') ?? 0,
            double.tryParse(m["paddingBottom"] ?? '') ?? 0,
          ),
          width: double.tryParse(m["width"] ?? "") ?? null,
          height: double.tryParse(m["height"] ?? "") ?? null,
          color: Helper.colorFromString(m["color"]),
          child: retrieveWidget(m["child"]),
        );
      case "Button":
        return RaisedButton(
          child: Text(m["text"] ?? ""),
          onPressed: () async {
            if (m["onPressed"] != null) {
              Map fetchedValues = {};
              if (m["onPressed"]["fetchValues"] != null) {
                (m["onPressed"]["fetchValues"] as List).forEach((element) {
                  if (controllers[element] != null) {
                    fetchedValues[element] = controllers[element]["valueFetcher"]();
                  }
                });
              }
              _emit("message", content: {
                "triggerer": "onPressed",
                "id": m["onPressed"]["id"],
                "fetchedValues": fetchedValues,
              }).catchError((e) {});
            }
          },
        );
      case "Text":
        return Text(
          m["text"] ?? "",
          textAlign: Helper.textAlignFromString(m["textAlign"]),
        );
      case "ImageFromNetwork":
        return Image.network(m["url"] ?? "");
      case "ImageFromBase64":
        return Image.memory(base64.decode(m["base64"]));
      case "Expanded":
        return Expanded(
          child: retrieveWidget(m["child"]),
          flex: int.tryParse(m["flex"] ?? "") ?? 1,
        );
      case "Icon":
        if (m["codePoint"] != null && int.tryParse(m["codePoint"] ?? "") != null) {
          return Icon(IconData(int.tryParse(m["codePoint"] ?? "") ?? 0, fontFamily: 'MaterialIcons'));
        }
        return null;
      case "ListView":
        return ListView.builder(
            itemCount: m["children"]?.length ?? 0,
            itemBuilder: (BuildContext context, int index) {
              return retrieveWidget(m["children"][index]);
            });
      case "GestureDetector":
        return GestureDetector(
          child: retrieveWidget(m["child"]),
          onTap: () {
            if (m["onTap"] != null) {
              Map fetchedValues = {};
              if (m["onTap"]["fetchValues"] != null) {
                (m["onTap"]["fetchValues"] as List).forEach((element) {
                  if (controllers[element] != null) {
                    fetchedValues[element] = controllers[element]["valueFetcher"]();
                  }
                });
              }
              _emit("message", content: {
                "triggerer": "onTap",
                "id": m["onTap"]["id"],
                "fetchedValues": fetchedValues,
              }).catchError((e) {});
            }
          },
          onDoubleTap: () {
            if (m["onDoubleTap"] != null) {
              Map fetchedValues = {};
              if (m["onDoubleTap"]["fetchValues"] != null) {
                (m["onDoubleTap"]["fetchValues"] as List).forEach((element) {
                  if (controllers[element] != null) {
                    fetchedValues[element] = controllers[element]["valueFetcher"]();
                  }
                });
              }
              _emit("message", content: {
                "triggerer": "onDoubleTap",
                "id": m["onDoubleTap"]["id"],
                "fetchedValues": fetchedValues,
              }).catchError((e) {});
            }
          },
          onLongPress: () {
            if (m["onLongPress"] != null) {
              Map fetchedValues = {};
              if (m["onLongPress"]["fetchValues"] != null) {
                (m["onLongPress"]["fetchValues"] as List).forEach((element) {
                  if (controllers[element] != null) {
                    fetchedValues[element] = controllers[element]["valueFetcher"]();
                  }
                });
              }
              _emit("message", content: {
                "triggerer": "onLongPress",
                "id": m["onLongPress"]["id"],
                "fetchedValues": fetchedValues,
              }).catchError((e) {});
            }
          },
          // TODO
          // onVerticalDragDown: (DragDownDetails d) {},
          // onHorizontalDragDown: (DragDownDetails d) {},
          // onForcePressStart: (ForcePressDetails d) {},
          // onForcePressPeak: (ForcePressDetails d) {},
          // onPanDown: (DragDownDetails d) {},
          // onScaleStart: (ScaleStartDetails d) {},
          // onScaleUpdate: (ScaleUpdateDetails d) {},
          // onScaleEnd: (ScaleEndDetails d) {},
        );
      default:
        return null;
    }
  }

  Widget layout(layoutMap) {
    if (layoutMap == null) {
      return null;
    }
    return retrieveWidget(layoutMap["widget"]);
  }

  @override
  void dispose() {
    if (_microService != null) {
      _microService.emit('exit');
      // _microService.exitProcess(0);
    }
    controllers.forEach((key, value) {
      if (value != null) {
        value["disposer"]();
      }
    });
    super.dispose();
  }
}
