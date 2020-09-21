import 'package:byr_mobile_app/customizations/theme_controller.dart';
import 'package:byr_mobile_app/customizations/theme_manager.dart';
import 'package:byr_mobile_app/local_objects/local_storage.dart';
import 'package:byr_mobile_app/nforum/nforum_service.dart';
import 'package:byr_mobile_app/nforum/nforum_structures.dart';
import 'package:byr_mobile_app/pages/about_page.dart';
import 'package:byr_mobile_app/pages/pages.dart';
import 'package:byr_mobile_app/reusable_components/adaptive_components.dart';
import 'package:byr_mobile_app/reusable_components/clickable_avatar.dart';
import 'package:byr_mobile_app/reusable_components/setting_item_cell.dart';
import 'package:byr_mobile_app/shared_objects/shared_objects.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class MePage extends StatefulWidget {
  @override
  MePageState createState() => MePageState();
}

class MePageState extends State<MePage> with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  bool showUserDetail = false;

  AnimationController _controller;
  Animation<double> _drawerContentsOpacity;
  bool _showDrawerContents = true;
  UserModel user;
  List users;
  final userIdController = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    userIdController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    users = NForumService.getAllUser();
    SharedObjects.me.then((userInfo) {
      user = userInfo;
    });
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _drawerContentsOpacity = CurvedAnimation(
      parent: ReverseAnimation(_controller),
      curve: Curves.fastOutSlowIn,
    );
  }

  Widget _buildUserDetailList(BuildContext context) {
    users.sort((a, b) {
      return a['id'].toLowerCase().compareTo(b['id'].toLowerCase());
    });
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: users.length + 1,
      itemBuilder: (context, int index) {
        if (index >= users.length) {
          return ListTile(
            title: Row(
                mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[Text('+ ' + "addAccount".tr, style: TextStyle(color: E().mePageTextColor))]),
            onTap: () async {
              var t = await Navigator.of(context).pushNamed('login_page', arguments: LoginPageRouteArg(isAddingMoreAccount: true));
              if (t != null) {
                user = await SharedObjects.me;
                users = NForumService.getAllUser();
                if (mounted) {
                  setState(() {});
                }
              }
            },
          );
        }
        return Card(
            color: E().mePageBackgroundColor,
            child: ListTile(
              onTap: () async {
                if (users[index]['token'] != NForumService.currentToken) {
                  await NForumService.loginUser(users[index]['token']);
                  user = await SharedObjects.me;
                  if (mounted) {
                    setState(() {});
                  }
                }
              },
              leading: Icon(Icons.stars, color: users[index]['token'] == NForumService.currentToken ? E().mePageSelectedColor : E().mePageTextColor),
              title: Text(users[index]['id'],
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 16, color: users[index]['token'] == NForumService.currentToken ? E().mePageSelectedColor : E().mePageTextColor)),
              trailing: ButtonTheme(
                padding: EdgeInsets.all(0),
                minWidth: 40,
                height: 25,
                child: FlatButton(
                  shape: RoundedRectangleBorder(side: BorderSide(color: E().mePageTextColor)),
                  onPressed: () async {
                    NForumService.logoutUser(users[index]['token']);
                    if (users[index]['token'] != NForumService.currentToken) {
                      users = NForumService.getAllUser();
                      if (mounted) {
                        setState(() {});
                      }
                      return;
                    }
                    List _users = NForumService.getAllUser();
                    if (_users.length > 0) {
                      await NForumService.loginUser(_users[0]['token']);
                      user = await SharedObjects.me;
                      users = NForumService.getAllUser();
                      if (mounted) {
                        setState(() {});
                      }
                    } else {
                      Navigator.of(context).pushReplacementNamed('login_page', arguments: LoginPageRouteArg());
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
            ));
      },
    );
  }

  Widget _buildMenu(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint) {
      return SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraint.maxHeight),
          child: Column(
            children: <Widget>[
              SettingItemCell(
                leading: Icon(MaterialIcons.wb_sunny, color: E().settingItemCellMainColor),
                title: "themeStyleTrans".tr,
                value: LocalStorage.getIsAutoTheme() ? "themeAuto".tr : BYRThemeManager.instance().themeMap[E().themeName].themeDisplayName,
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
                leading: Icon(Icons.collections_bookmark, color: E().settingItemCellMainColor),
                title: "collectionTrans".tr,
                onTap: () {
                  Navigator.pushNamed(context, "collection_page");
                },
              ),
              SettingItemCell(
                leading: Icon(Icons.view_list, color: E().settingItemCellMainColor),
                title: "sectionButtonTrans".tr,
                onTap: () {
                  Navigator.pushNamed(context, "section_page");
                },
              ),
              Divider(),
              SettingItemCell(
                leading: Icon(Icons.settings, color: E().settingItemCellMainColor),
                title: "settings".tr,
                newFeatureKey: 'setting',
                onTap: () {
                  Navigator.pushNamed(context, "settings_page");
                },
              ),
              SettingItemCell(
                leading: Icon(Icons.local_post_office, color: E().settingItemCellMainColor),
                title: "feedbackTrans".tr,
                onTap: () {
                  navigator.pushNamed(
                    'post_page',
                    arguments: PostPageRouteArg(
                      board: BoardModel(
                        name: 'advice',
                        description: '意见与建议',
                        allowAnonymous: false,
                        allowPost: true,
                        allowAttachment: true,
                      ),
                    ),
                  );
                },
              ),
              SettingItemCell(
                leading: Icon(FontAwesomeIcons.exclamationCircle, color: E().settingItemCellMainColor),
                title: "aboutButtonTrans".tr,
                onTap: () {
                  navigator.push(CupertinoPageRoute(builder: (_) => AboutPage()));
                },
              ),
            ],
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Obx(
      () => Container(
        color: E().mePageBackgroundColor,
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                UserAccountsDrawerHeader(
                  margin: EdgeInsets.zero,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    image: DecorationImage(
                        image: SharedObjects.welImage,
                        colorFilter: ColorFilter.mode(
                            (E().mePageBackgroundColor.red + E().mePageBackgroundColor.green + E().mePageBackgroundColor.blue) / 3 > 128
                                ? Colors.black.withOpacity(0.25)
                                : Colors.black.withOpacity(0.6),
                            BlendMode.darken),
                        alignment: FractionalOffset.topLeft,
                        fit: BoxFit.cover),
                  ),
                  currentAccountPicture: FutureBuilder(
                    builder: (context, snapshot) => snapshot.hasData
                        ? ClickableAvatar(
                            radius: 20,
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
                          )
                        : ClickableAvatar(
                            radius: 20,
                            emptyUser: true,
                            imageLink: null,
                            onTap: null,
                          ),
                    future: SharedObjects.me,
                  ),
                  accountName: FutureBuilder(
                    builder: (context, snapshot) => snapshot.hasData ? Text(snapshot.data?.id, style: HStyle.titleNav()) : Text("", style: HStyle.titleNav()),
                    future: SharedObjects.me,
                  ),
                  accountEmail: FutureBuilder(
                    builder: (context, snapshot) =>
                        snapshot.hasData ? Text(snapshot.data?.userName, style: HStyle.bodyWhite()) : Text("", style: HStyle.bodyWhite()),
                    future: SharedObjects.me,
                  ),
                  onDetailsPressed: () {
                    _showDrawerContents = !_showDrawerContents;
                    if (mounted) {
                      setState(() {});
                    }
                    if (_showDrawerContents)
                      _controller.reverse();
                    else
                      _controller.forward();
                  },
                ),
                SafeArea(
                  bottom: false,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: Icon(Icons.search),
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
                                  navigator.pushNamed("profile_page", arguments: value);
                                }).catchError((e) {
                                  AdaptiveComponents.showToast(context, e.toString());
                                });
                              }
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Expanded(
              child: Stack(
                children: <Widget>[
                  IgnorePointer(
                    ignoring: !_showDrawerContents,
                    child: FadeTransition(opacity: _drawerContentsOpacity, child: _buildMenu(context)),
                  ),
                  Positioned(
                      child: IgnorePointer(
                          ignoring: _showDrawerContents,
                          child: FadeTransition(
                            opacity: ReverseAnimation(_drawerContentsOpacity),
                            child: Column(
                              children: <Widget>[Expanded(child: _buildUserDetailList(context))],
                            ),
                          ))),
                ],
              ),
            ),
          ],
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
