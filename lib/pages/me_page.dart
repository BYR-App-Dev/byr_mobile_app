import 'package:byr_mobile_app/customizations/theme_controller.dart';
import 'package:byr_mobile_app/customizations/theme_manager.dart';
import 'package:byr_mobile_app/local_objects/local_storage.dart';
import 'package:byr_mobile_app/nforum/nforum_service.dart';
import 'package:byr_mobile_app/nforum/nforum_structures.dart';
import 'package:byr_mobile_app/pages/pages.dart';
import 'package:byr_mobile_app/reusable_components/adaptive_components.dart';
import 'package:byr_mobile_app/reusable_components/audio_player_view.dart';
import 'package:byr_mobile_app/reusable_components/clickable_avatar.dart';
import 'package:byr_mobile_app/reusable_components/setting_item_cell.dart';
import 'package:byr_mobile_app/shared_objects/shared_objects.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_notification/pull_to_refresh_notification.dart'
    hide AlwaysScrollableClampingScrollPhysics;
import 'package:tuple/tuple.dart';

typedef UserListRefreshCallback = Future<Tuple2<UserModel, List>> Function(int refreshType);

class UserDetailList extends StatefulWidget {
  final List users;
  final UserModel user;
  final UserListRefreshCallback refresh;

  const UserDetailList({Key key, this.users, this.user, this.refresh}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return UserDetailListState();
  }
}

class UserDetailListState extends State<UserDetailList> {
  List users;
  UserModel user;
  UserListRefreshCallback refresh;

  @override
  initState() {
    users = widget.users;
    user = widget.user;
    refresh = widget.refresh;
    super.initState();
  }

  @override
  void didUpdateWidget(UserDetailList oldWidget) {
    users = widget.users;
    user = widget.user;
    refresh = widget.refresh;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    users.sort((a, b) {
      return a['id'].toLowerCase().compareTo(b['id'].toLowerCase());
    });
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: users.length + 1,
      shrinkWrap: true,
      itemBuilder: (context, int index) {
        if (index >= users.length) {
          return ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  '+ ' + "addAccount".tr,
                  style: TextStyle(color: E().mePageTextColor),
                ),
              ],
            ),
            onTap: () async {
              var t = await Navigator.of(context).pushNamed(
                'login_page',
                arguments: LoginPageRouteArg(isAddingMoreAccount: true),
              );
              if (t != null) {
                Tuple2 tp = await refresh(0);
                user = tp.item1;
                users = tp.item2;
                if (mounted) {
                  setState(() {});
                }
              }
            },
          );
        }
        return ListTile(
          onTap: () async {
            if (users[index]['token'] != NForumService.currentToken) {
              await NForumService.loginUser(users[index]['token']);
              Tuple2 tp = await refresh(1);
              user = tp.item1;
              users = tp.item2;
              if (mounted) {
                setState(() {});
              }
            }
          },
          leading: Icon(
            Icons.stars,
            color: users[index]['token'] == NForumService.currentToken ? E().mePageSelectedColor : E().mePageTextColor,
          ),
          title: Text(
            users[index]['id'],
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 16,
              color:
                  users[index]['token'] == NForumService.currentToken ? E().mePageSelectedColor : E().mePageTextColor,
            ),
          ),
          trailing: ButtonTheme(
            padding: EdgeInsets.all(0),
            minWidth: 40,
            height: 25,
            child: FlatButton(
              shape: RoundedRectangleBorder(side: BorderSide(color: E().mePageTextColor)),
              onPressed: () async {
                await NForumService.logoutUser(users[index]['token']);
                if (users[index]['token'] != NForumService.currentToken) {
                  Tuple2 tp = await refresh(2);
                  user = tp.item1;
                  users = tp.item2;
                  if (mounted) {
                    setState(() {});
                  }
                  return;
                }
                List _users = NForumService.getAllUser();
                if (_users.length > 0) {
                  await NForumService.loginUser(_users[0]['token']);
                  Tuple2 tp = await refresh(0);
                  user = tp.item1;
                  users = tp.item2;
                  if (mounted) {
                    setState(() {});
                  }
                } else {
                  Navigator.of(context).pushNamedAndRemoveUntil('login_page', (Route<dynamic> route) => false,
                      arguments: LoginPageRouteArg());
                }
              },
              child: Text(
                "logoutTrans".tr,
                style: TextStyle(
                  color: E().mePageTextColor,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class MePage extends StatefulWidget {
  @override
  MePageState createState() => MePageState();
}

class MePageState extends State<MePage> with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  UserModel user;
  List users;
  final userIdController = TextEditingController();

  ScrollController _scrollController = ScrollController();
  double _imageHeight = 200.0;
  bool _showAppBar = false;

  @override
  void dispose() {
    userIdController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    users = NForumService.getAllUser();
    if (SharedObjects.me == null) {
      SharedObjects.me = NForumService.getSelfUserInfo();
    }
    SharedObjects.me.then((userInfo) {
      user = userInfo;
    });
    _scrollController.addListener(() {
      if (_scrollController.offset < _imageHeight - kToolbarHeight) {
        if (_showAppBar) {
          setState(() {
            _showAppBar = !_showAppBar;
          });
        }
      } else {
        if (!_showAppBar) {
          setState(() {
            _showAppBar = !_showAppBar;
          });
        }
      }
    });
  }

  Widget _buildMenu(BuildContext context) {
    return Column(
      children: <Widget>[
        SettingItemCell(
          height: 50,
          leading: Icon(MaterialIcons.wb_sunny, color: E().settingItemCellMainColor),
          title: "themeStyleTrans".tr,
          value: LocalStorage.getIsAutoTheme()
              ? "themeAuto".tr
              : BYRThemeManager.instance().themeMap[E().themeName].themeDisplayName,
          showArrow: false,
          onTap: () {
            List<String> themeKeys = BYRThemeManager.instance().themeMap.keys.toList();
            List<BYRTheme> themeValues = BYRThemeManager.instance().themeMap.values.toList();
            AdaptiveComponents.showBottomSheet(
              context,
              themeValues.map((value) => value.themeDisplayName).toList()..add("themeAuto".tr),
              textStyle: TextStyle(
                color: E().settingItemCellMainColor,
                fontSize: 16,
              ),
              onItemTap: (int index) {
                if (index < themeKeys.length) {
                  BYRThemeManager.instance().setAutoSwitchDarkModeOff();
                  BYRThemeManager.instance().turnTheme(themeKeys[index]);
                }
                if (index == themeKeys.length) {
                  BYRThemeManager.instance().setAutoSwitchDarkModeOn();
                  final Brightness brightness = MediaQuery.platformBrightnessOf(context);
                  BYRThemeManager.instance().autoSwitchDarkMode(brightness);
                }
                if (mounted) {
                  setState(() {});
                }
              },
            );
          },
        ),
        SettingItemCell(
          height: 50,
          leading: Icon(Icons.collections_bookmark, color: E().settingItemCellMainColor),
          title: "collectionTrans".tr,
          onTap: () {
            Navigator.pushNamed(context, "collection_page");
          },
        ),
        Divider(),
        SettingItemCell(
          height: 50,
          leading: Icon(Icons.settings, color: E().settingItemCellMainColor),
          title: "settings".tr,
          newFeatureKey: 'fullscreen_back_gesture',
          onTap: () {
            Navigator.pushNamed(context, "settings_page");
          },
        ),
      ],
    );
  }

  Widget _getAvatar(double size) {
    return FutureBuilder(
      builder: (context, snapshot) => snapshot.hasData
          ? Draggable(
              child: ClickableAvatar(
                radius: size,
                emptyUser: snapshot.data?.faceUrl == null,
                isWhisper: (snapshot.data?.id ?? "").startsWith("IWhisper"),
                imageLink: NForumService.makeGetURL(snapshot.data?.faceUrl ?? ""),
                onTap: () {
                  if (snapshot.data?.faceUrl == null) {
                    return;
                  }
                  navigator.pushNamed(
                    "profile_page",
                    arguments: snapshot.data,
                  );
                },
              ),
              childWhenDragging: Container(),
              feedback: ClickableAvatar(
                radius: size,
                emptyUser: snapshot.data?.faceUrl == null,
                isWhisper: (snapshot.data?.id ?? "").startsWith("IWhisper"),
                imageLink: NForumService.makeGetURL(snapshot.data?.faceUrl ?? ""),
                onTap: () {},
              ),
            )
          : ClickableAvatar(
              radius: size,
              emptyUser: true,
              imageLink: null,
              onTap: null,
            ),
      future: SharedObjects.me,
    );
  }

  Widget _buildAppbar(PullToRefreshScrollNotificationInfo info) {
    var offset = info?.dragOffset ?? 0.0;
    return SliverAppBar(
      brightness: !E().isThemeDarkStyle ? Brightness.light : Brightness.dark,
      backgroundColor: E().mePageBackgroundColor,
      pinned: true,
      title: _showAppBar
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                FutureBuilder(
                  builder: (context, snapshot) => snapshot.hasData ? _getAvatar(15) : Container(),
                  future: SharedObjects.me,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: FutureBuilder(
                    builder: (context, snapshot) => snapshot.hasData
                        ? Text(snapshot.data?.id,
                            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0, color: E().mePageTextColor))
                        : Container(),
                    future: SharedObjects.me,
                  ),
                ),
              ],
            )
          : Container(),
      centerTitle: true,
      elevation: 0.0,
      expandedHeight: _imageHeight + offset,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        background: Stack(
          children: <Widget>[
            Container(
              width: double.infinity,
              child: Image(
                image: SharedObjects.welImage,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              width: double.infinity,
              color: Colors.black26,
            ),
            Positioned(
              left: 20,
              bottom: 20,
              right: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  _getAvatar(40),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            AdaptiveComponents.showBottomWidget(
                                context,
                                UserDetailList(
                                  users: users,
                                  user: user,
                                  refresh: (int type) async {
                                    if (type == 1) {
                                      user = await SharedObjects.me;
                                    } else if (type == 2) {
                                      users = NForumService.getAllUser();
                                    } else {
                                      user = await SharedObjects.me;
                                      users = NForumService.getAllUser();
                                    }
                                    if (mounted) {
                                      setState(() {});
                                    }
                                    return Tuple2(user, users);
                                  },
                                ));
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: FutureBuilder(
                                      builder: (context, snapshot) => snapshot.hasData
                                          ? Text(snapshot.data?.id, style: HStyle.titleNav())
                                          : Text("", style: HStyle.titleNav()),
                                      future: SharedObjects.me,
                                    ),
                                  ),
                                  FutureBuilder(
                                    builder: (context, snapshot) => snapshot.hasData
                                        ? Text(snapshot.data?.userName, style: HStyle.bodyWhite())
                                        : Text("", style: HStyle.bodyWhite()),
                                    future: SharedObjects.me,
                                  ),
                                ],
                              ),
                              IconButton(
                                  icon: Icon(
                                    Icons.arrow_drop_down,
                                    color: E().mePageUserIdColor,
                                  ),
                                  onPressed: null),
                            ],
                          ),
                        ),
                      ),
                      if (LocalStorage.getIsSimpleHomeEnabled())
                        IconButton(
                          icon: Stack(
                            clipBehavior: Clip.hardEdge,
                            children: <Widget>[
                              Icon(
                                Icons.mail_outline,
                                color: !_showAppBar ? E().mePageUserIdColor : E().mePageIconColor,
                              ),
                              Get.find<MessageController>().allCount > 0
                                  ? Positioned(
                                      top: 0,
                                      right: 0,
                                      child: Container(
                                        padding: EdgeInsets.all(3),
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle,
                                        ),
                                        constraints: BoxConstraints(
                                          minWidth: 8,
                                          minHeight: 8,
                                        ),
                                      ),
                                    )
                                  : SizedBox.shrink()
                            ],
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, "message_page");
                          },
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.save_alt,
            color: !_showAppBar ? E().mePageUserIdColor : E().mePageIconColor,
          ),
          onPressed: () {
            AdaptiveComponents.showAlertDialog(
              context,
              title: "保存背景图片",
              onDismiss: (value) {
                if (value == AlertResult.confirm) {
                  GallerySaver.saveImage(SharedObjects.welImageInfo.path, albumName: 'BYRDownload').then((value) {
                    AdaptiveComponents.showToast(context, '保存${value ? '成功' : '失败'}');
                  });
                }
              },
            );
          },
        ),
        IconButton(
          icon: Icon(
            Icons.person_search,
            color: !_showAppBar ? E().mePageUserIdColor : E().mePageIconColor,
          ),
          onPressed: () {
            AdaptiveComponents.showAlertDialog(
              context,
              title: "search".tr + "loginUsernameTrans".tr,
              contentWidget: Material(
                child: TextField(
                  autofocus: true,
                  controller: userIdController,
                  decoration: InputDecoration(labelText: 'id'),
                  style: TextStyle(color: E().dialogContentColor),
                  maxLines: 1,
                ),
                color: Colors.transparent,
              ),
              onDismiss: (result) {
                if (result == AlertResult.confirm) {
                  NForumService.getUserInfo(userIdController.text).then((value) {
                    userIdController.clear();
                    navigator.pushNamed("profile_page", arguments: value);
                  }).catchError((e) {
                    userIdController.clear();
                    AdaptiveComponents.showToast(context, e.toString());
                  });
                } else {
                  userIdController.clear();
                }
              },
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Obx(
      () => Scaffold(
        backgroundColor: E().mePageBackgroundColor,
        body: PullToRefreshNotification(
          pullBackOnRefresh: false,
          maxDragOffset: 200,
          onRefresh: () => Future.value(true),
          pullBackDuration: const Duration(milliseconds: 300),
          pullBackCurve: Curves.easeInOut,
          child: CustomScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableClampingScrollPhysics(),
            slivers: <Widget>[
              PullToRefreshContainer(_buildAppbar),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return _buildMenu(context);
                  },
                  childCount: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class HStyle {
  static titleNav() {
    return TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0, color: E().mePageUserIdColor);
  }

  static bodyWhite() {
    return TextStyle(fontWeight: FontWeight.w500, fontSize: 14.0, color: E().mePageUsernameColor);
  }
}

class AlwaysScrollableClampingScrollPhysics extends ClampingScrollPhysics {
  const AlwaysScrollableClampingScrollPhysics({ScrollPhysics parent}) : super(parent: parent);

  @override
  AlwaysScrollableClampingScrollPhysics applyTo(ScrollPhysics ancestor) {
    return AlwaysScrollableClampingScrollPhysics(parent: buildParent(ancestor));
  }

  static bool _quickSwipe = false;

  @override
  double applyBoundaryConditions(ScrollMetrics position, double value) {
    double tmpValue = super.applyBoundaryConditions(position, value);
    if (_quickSwipe) return tmpValue;
    if (tmpValue > 0.0) return 0.0;
    return tmpValue;
  }

  @override
  Simulation createBallisticSimulation(ScrollMetrics position, double velocity) {
    Simulation simulation = super.createBallisticSimulation(position, velocity);
    _quickSwipe = simulation is ClampingScrollSimulation;
    return simulation;
  }

  @override
  bool shouldAcceptUserOffset(ScrollMetrics position) {
    return true;
  }
}
