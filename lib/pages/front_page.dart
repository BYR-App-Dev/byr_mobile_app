import 'package:byr_mobile_app/customizations/theme_controller.dart';
import 'package:byr_mobile_app/local_objects/local_models.dart';
import 'package:byr_mobile_app/nforum/board_att_info.dart';
import 'package:byr_mobile_app/nforum/nforum_service.dart';
import 'package:byr_mobile_app/nforum/nforum_structures.dart';
import 'package:byr_mobile_app/pages/pages.dart';
import 'package:byr_mobile_app/reusable_components/byr_app_bar.dart';
import 'package:byr_mobile_app/reusable_components/custom_tab_controller.dart';
import 'package:byr_mobile_app/reusable_components/custom_tabs.dart';
import 'package:byr_mobile_app/reusable_components/custom_underline_indicator.dart';
import 'package:byr_mobile_app/reusable_components/event_bus.dart';
import 'package:byr_mobile_app/reusable_components/fullscreen_back_page_route.dart';
import 'package:byr_mobile_app/shared_objects/shared_objects.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:tuple/tuple.dart';

const initialBoards = ['Talking', 'Feeling', 'Picture'];

class FrontPage extends StatefulWidget {
  @override
  FrontPageState createState() => FrontPageState();
}

class FrontPageState extends State<FrontPage> with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;

  List<TabModel> tabModelList = <TabModel>[];

  CustomTabController _tabController;

  @override
  void initState() {
    _initTabSetting();
    eventBus.on(UPDATE_MAIN_TAB_SETTING, (event) {
      _updateTabSetting();
    });
    super.initState();
  }

  @override
  void dispose() {
    eventBus.off(UPDATE_MAIN_TAB_SETTING);
    _tabController.dispose();
    super.dispose();
  }

  void _initFavTabs() {
    int addCount = 0;

    initialBoards.forEach((b) {
      tabModelList.add(TabModel(BoardAttInfo.desc(b), b));
      addCount++;
    });

    if (addCount != 0) {
      _initContent();
    }
    if (mounted) {
      setState(() {});
    }
    TabModel.saveFrontPageTabs(tabModelList);
  }

  void _initContent({int initialIndex = 1}) {
    if (_tabController == null) {
      _tabController = CustomTabController(initialIndex: initialIndex, length: tabModelList.length, vsync: this);
    } else {
      _tabController.index = initialIndex;
      _tabController.setLength(tabModelList.length);
    }
    if (mounted) {
      setState(() {});
    }
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _tabController.animateTo(initialIndex);
    });
  }

  void _updateTabSetting() {
    var result = TabModel.getFrontPageTabs();
    int newIndex = 0;
    if (result != null && result.length > 0) {
      String currentTab = tabModelList[_tabController.index].key;
      int index = result.indexWhere((tab) => tab.key == currentTab);
      if (index != -1) {
        newIndex = index;
      } else {
        newIndex = _tabController.index - 1 < 0 ? 0 : _tabController.index - 1;
      }
    }
    _initTabSetting(initialIndex: newIndex);
  }

  void _initTabSetting({int initialIndex = 1}) {
    tabModelList = TabModel.getFrontPageTabs();
    bool _firstOpen = false;
    if (tabModelList == null || tabModelList.length <= 0) {
      _firstOpen = true;
      tabModelList = <TabModel>[];
      tabModelList.add(TabModel('Timeline', 'timeline', editable: false));
      tabModelList.add(TabModel('Top10', 'topten', editable: false));
      tabModelList.add(TabModel('Boardmarks', 'boardmarks', editable: false));
    }
    _initContent(initialIndex: initialIndex);
    if (_firstOpen) {
      _initFavTabs();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Obx(
      () => Scaffold(
        appBar: BYRAppBar(
          elevation: 0,
          flexibleSpace: SafeArea(
            child: Container(
              padding: EdgeInsets.only(left: 15.0, right: 15.0),
              child: Row(
                children: <Widget>[
                  Expanded(
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
                          ).createShader(Rect.fromLTRB(0, 0, rect.width - 10, rect.height));
                        },
                        blendMode: BlendMode.dstIn,
                        child: Container(
                          padding: EdgeInsets.only(right: 10.0),
                          child: CustomTabBar(
                            isScrollable: tabModelList.length > 3 ? true : false,
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
                            tabs: tabModelList.map<Widget>((tab) {
                              return CustomTab(
                                unselectedFontSize: 12,
                                text: tab.key == 'timeline'
                                    ? "timelineTrans".tr
                                    : tab.key == 'topten'
                                        ? "toptenTrans".tr
                                        : tab.key == 'boardmarks'
                                            ? "boardmarksTrans".tr
                                            : tab.title,
                              );
                            }).toList(),
                            indicatorColor: E().tabPageTopBarSliderColor,
                            controller: _tabController,
                          ),
                        ),
                      ),
                    ),
                  ),
                  FutureBuilder<Tuple2<UserModel, String>>(
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data.item1.id == snapshot.data.item2) {
                        return GestureDetector(
                          onTap: () => Navigator.of(context)
                              .push(FullscreenBackPageRoute(builder: (_) => FrontTabSettingPage())),
                          child: Icon(
                            FontAwesomeIcons.slidersH,
                            color: E().tabPageTopBarButtonColor,
                          ),
                        );
                      } else {
                        return GestureDetector(
                          onTap: null,
                          child: Icon(
                            FontAwesomeIcons.slidersH,
                            color: Colors.transparent,
                          ),
                        );
                      }
                    },
                    future: SharedObjects.me?.then((v) {
                      var id = NForumService.getIdByToken(NForumService.currentToken);
                      return Tuple2(v, id);
                    }),
                  )
                ],
              ),
            ),
          ),
        ),
        body: CustomTabBarView(
          children: tabModelList.map<Widget>((tab) {
            if (tab.key == 'timeline') {
              return TimelinePage();
            } else if (tab.key == 'topten') {
              return ToptenPage();
            } else if (tab.key == 'boardmarks') {
              return BoardmarksPage();
            } else {
              return BoardPage(
                BoardPageRouteArg(tab.key, keepTop: false),
              );
            }
          }).toList(),
          controller: _tabController,
        ),
      ),
    );
  }
}
