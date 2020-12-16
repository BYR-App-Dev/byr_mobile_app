import 'package:byr_mobile_app/customizations/theme_controller.dart';
import 'package:byr_mobile_app/nforum/board_att_info.dart';
import 'package:byr_mobile_app/nforum/nforum_service.dart';
import 'package:byr_mobile_app/pages/pages.dart';
import 'package:byr_mobile_app/reusable_components/byr_app_bar.dart';
import 'package:byr_mobile_app/reusable_components/custom_tab_controller.dart';
import 'package:byr_mobile_app/reusable_components/custom_tabs.dart';
import 'package:byr_mobile_app/reusable_components/custom_underline_indicator.dart';
import 'package:flutter/material.dart';

const int additionalTabs = 3;

class DiscoverPage extends StatefulWidget {
  @override
  DiscoverPageState createState() => DiscoverPageState();
}

class DiscoverPageState extends State<DiscoverPage> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  List<String> boardsToLoad = [];

  Map<String, bool> boardsAvailable;
  CustomTabController controller;

  @override
  void initState() {
    super.initState();

    boardsAvailable = Map<String, bool>();

    controller = CustomTabController(initialIndex: 0, length: additionalTabs + boardsAvailable.length, vsync: this);

    NForumService.getRecommendedBoards().then((List<String> recommendedBoards) {
      recommendedBoards.forEach((b) {
        if (b != null && b.length > 0) {
          boardsToLoad.add(b);
        }
      });
      boardsToLoad.forEach((element) {
        if (element != null && element != '') {
          NForumService.getBoard(element, page: 1, count: 1).then((value) {
            if (value.article != null) {
              boardsAvailable[element] = true;
            } else {
              boardsAvailable[element] = false;
            }
            int count = 0;
            boardsToLoad.forEach((element) {
              if (boardsAvailable[element] == true) {
                count += 1;
              }
            });
            controller.setLength(additionalTabs + count);
            if (mounted) {
              setState(() {});
            }
          });
        }
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  bool isFollowingPost = false;

  void tabTappedBefore(int tabId) {}

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
                    isScrollable: true,
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
                    tabs: boardsToLoad
                        .fold<List<Widget>>(
                          List<Widget>(),
                          (previousValue, element) => boardsAvailable[element] == true
                              ? (previousValue
                                ..add(
                                  CustomTab(
                                    unselectedFontSize: 12,
                                    text: BoardAttInfo.desc(element),
                                  ),
                                ))
                              : previousValue,
                        )
                        .toList()
                          ..insert(
                            0,
                            CustomTab(
                              unselectedFontSize: 12,
                              text: "竞猜",
                            ),
                          )
                          ..insert(
                            0,
                            CustomTab(
                              unselectedFontSize: 12,
                              text: "投票",
                            ),
                          )
                          ..insert(
                            0,
                            CustomTab(
                              unselectedFontSize: 12,
                              text: "小程序",
                            ),
                          ),
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
        children: boardsToLoad
            .fold<List<Widget>>(
              List<Widget>(),
              (previousValue, element) => boardsAvailable[element] == true
                  ? (previousValue
                    ..add(
                      BoardPage(
                        BoardPageRouteArg(
                          element,
                          keepTop: false,
                          // isPicWaterfall: element == "Picture",
                        ),
                      ),
                    ))
                  : previousValue,
            )
            .toList()
              ..insert(
                0,
                BetListPage(),
              )
              ..insert(
                0,
                VoteListPage(),
              )
              ..insert(
                0,
                MicroPluginListPage(),
              ),
        controller: controller,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
