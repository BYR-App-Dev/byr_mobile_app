import 'package:byr_mobile_app/customizations/theme_controller.dart';
import 'package:byr_mobile_app/local_objects/local_models.dart';
import 'package:byr_mobile_app/pages/cloud_blocklist_page.dart';
import 'package:byr_mobile_app/pages/local_blocklist_page.dart';
import 'package:byr_mobile_app/pages/pages.dart';
import 'package:byr_mobile_app/reusable_components/about_page_user_widget.dart';
import 'package:byr_mobile_app/reusable_components/adaptive_components.dart';
import 'package:byr_mobile_app/reusable_components/byr_app_bar.dart';
import 'package:byr_mobile_app/reusable_components/custom_tab_controller.dart';
import 'package:byr_mobile_app/reusable_components/custom_tabs.dart';
import 'package:byr_mobile_app/reusable_components/custom_underline_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BlocklistPage extends StatefulWidget {
  @override
  BlocklistPageState createState() => BlocklistPageState();
}

class BlocklistPageState extends State<BlocklistPage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  CustomTabController controller;

  @override
  void initState() {
    super.initState();
    controller = CustomTabController(initialIndex: 0, length: 2, vsync: this);
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: BYRAppBar(
        elevation: 0,
        flexibleSpace: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(left: 15.0, right: 15),
            child: ShaderMask(
              shaderCallback: (Rect bounds) {
                return LinearGradient(
                  begin: Alignment.centerRight,
                  end: Alignment(100, 0.0),
                  colors: <Color>[
                    Colors.white,
                    Colors.yellow,
                  ],
                ).createShader(bounds);
              },
              child: ShaderMask(
                shaderCallback: (rect) {
                  return LinearGradient(
                    begin: Alignment(-0.9, 0.0),
                    end: Alignment(-1.0, 0.0),
                    colors: [Colors.black, Colors.transparent],
                  ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
                },
                blendMode: BlendMode.dstIn,
                child: ShaderMask(
                  shaderCallback: (rect) {
                    return LinearGradient(
                      begin: Alignment(0.9, 0.0),
                      end: Alignment(1.0, 0.0),
                      colors: [Colors.black, Colors.transparent],
                    ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
                  },
                  blendMode: BlendMode.dstIn,
                  child: CustomTabBar(
                    isScrollable: false,
                    indicator: FixedUnderlineTabIndicator(
                      borderSide: BorderSide(
                        width: 3,
                        color: E().tabPageTopBarSliderColor,
                      ),
                    ),
                    indicatorWeight: 3,
                    labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    labelColor: E().topBarTitleNormalColor,
                    unselectedLabelStyle: TextStyle(fontSize: 12),
                    unselectedLabelColor: E().topBarTitleUnSelectedColor,
                    tabs: [
                      CustomTab(
                        unselectedFontSize: 12,
                        text: "内容黑名单",
                      ),
                      CustomTab(
                        unselectedFontSize: 12,
                        text: "消息黑名单",
                      ),
                    ],
                    indicatorColor: E().tabPageTopBarSliderColor,
                    controller: controller,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: CustomTabBarView(
        children: [
          LocalBlocklistPage(),
          CloudBlocklistPage(),
        ],
        controller: controller,
      ),
    );
  }
}
