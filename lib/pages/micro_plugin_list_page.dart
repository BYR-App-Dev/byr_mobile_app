import 'package:byr_mobile_app/nforum/nforum_service.dart';
import 'package:byr_mobile_app/pages/pages.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MicroPluginListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MicroPluginListPageState();
  }
}

class MicroPluginListPageState extends State<MicroPluginListPage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  List<Map> microPlugins;
  @override
  void initState() {
    super.initState();
    NForumService.getMicroPlugins().then((value) {
      microPlugins = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListView.builder(
        itemCount: microPlugins?.length ?? 0,
        itemBuilder: (buildContext, index) {
          return ListTile(
            title: Text(microPlugins[index]["name"]),
            onTap: () {
              navigator.push(CupertinoPageRoute(
                  builder: (_) => MicroPluginPage(
                        pluginName: microPlugins[index]["name"],
                        pluginURI: microPlugins[index]["uri"],
                      )));
            },
          );
        });
  }
}
