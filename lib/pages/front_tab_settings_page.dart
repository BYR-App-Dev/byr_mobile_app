import 'package:byr_mobile_app/customizations/theme_controller.dart';
import 'package:byr_mobile_app/helper/helper.dart';
import 'package:byr_mobile_app/local_objects/local_models.dart';
import 'package:byr_mobile_app/networking/http_request.dart';
import 'package:byr_mobile_app/nforum/nforum_service.dart';
import 'package:byr_mobile_app/pages/page_components.dart';
import 'package:byr_mobile_app/reusable_components/byr_app_bar.dart';
import 'package:byr_mobile_app/reusable_components/event_bus.dart';
import 'package:byr_mobile_app/reusable_components/page_initialization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:get/get.dart';

class FrontTabSettingPage extends StatefulWidget {
  @override
  _FrontTabSettingPageState createState() => _FrontTabSettingPageState();
}

class _FrontTabSettingPageState extends State<FrontTabSettingPage> with InitializationFailureViewMixin {
  List<TabModel> _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabModel.getFrontPageTabs();
    initialization();
  }

  @override
  void initialization() {
    initializationStatus = InitializationStatus.Initializing;
    NForumService.getFavBoards().then((f) {
      f.board.forEach((b) {
        if (b.name != null && b.name.length > 0 && _tabs.indexWhere((tab) => tab.key == b.name) == -1) {
          _tabs.add(
            TabModel(
              b.description,
              b.name,
              checked: false,
            ),
          );
        }
      });
      initializationStatus = InitializationStatus.Initialized;
      setState(() {});
    }).catchError(initializationErrorHandling);
  }

  void initializationErrorHandling(e) {
    setFailureInfo(e);
    initializationStatus = InitializationStatus.Failed;
    if (mounted) {
      setState(() {});
    }
  }

  void refreshErrorHandling(e) {
    setFailureInfo(e);
    if (mounted) {
      setState(() {});
    }
  }

  void loadErrorHandling(e) {
    setFailureInfo(e);
    if (mounted) {
      setState(() {});
    }
  }

  void setFailureInfo(e) {
    switch (e.runtimeType) {
      case NetworkException:
        failureInfo = "networkExceptionTrans".tr;
        break;
      case APIException:
        failureInfo = e.toString();
        break;
      case DataException:
        failureInfo = "dataExceptionTrans".tr;
        break;
      default:
        failureInfo = e.toString();
        break;
    }
  }

  void _onReorder(int oldIndex, int newIndex) {
    if (oldIndex < 3 || newIndex < 3) return;
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final TabModel item = _tabs.removeAt(oldIndex);
    _tabs.insert(newIndex, item);
    _saveSetting();
    if (mounted) {
      setState(() {});
    }
  }

  void _saveSetting() {
    TabModel.saveFrontPageTabs(_tabs);
    eventBus.emit(UPDATE_MAIN_TAB_SETTING);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: BYRAppBar(
          title: Text(
            "frontTabSettingsTrans".tr,
          ),
        ),
        backgroundColor: E().otherPagePrimaryColor,
        body: widgetCase(
          initializationStatus,
          {
            InitializationStatus.Initializing: buildLoadingView(),
            InitializationStatus.Failed: Center(
              child: buildLoadingFailedView(),
            ),
            InitializationStatus.Initialized: initializationStatus != InitializationStatus.Initialized
                ? Container(
                    color: E().otherPagePrimaryColor,
                    child: buildLoadingView(),
                  )
                : Container(
                    color: E().otherPagePrimaryColor,
                    child: ReorderableListView(
                      onReorder: _onReorder,
                      children: _tabs
                          .map(
                            (item) => Container(
                              key: Key(item.key),
                              color: E().otherPagePrimaryColor,
                              child: Theme(
                                data: ThemeData(
                                  unselectedWidgetColor: E().otherPagePrimaryTextColor,
                                  disabledColor: E().otherPagePrimaryTextColor,
                                ),
                                child: CheckboxListTile(
                                  value: item.checked ?? false,
                                  onChanged: item.editable
                                      ? (bool newValue) {
                                          setState(() {
                                            item.checked = newValue;
                                            _saveSetting();
                                          });
                                        }
                                      : null,
                                  title: Text(
                                    item.key == 'timeline'
                                        ? "timelineTrans".tr
                                        : item.key == 'topten'
                                            ? "toptenTrans".tr
                                            : item.key == 'boardmarks' ? "boardmarksTrans".tr : item.title,
                                    style: TextStyle(
                                      color: E().otherPagePrimaryTextColor,
                                    ),
                                  ),
                                  secondary: Icon(
                                    Icons.drag_handle,
                                    color: E().otherPagePrimaryTextColor,
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
          },
          buildLoadingView(),
        ),
      ),
    );
  }

  Widget buildLoadingView() {
    var getCell = () {
      return Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: EdgeInsets.only(left: 5, right: 5, top: 10),
              height: 10,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
            ),
            Container(
              margin: EdgeInsets.only(left: 5, right: 5, top: 10),
              height: 30,
              width: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
            ),
            Expanded(child: Container()),
            Container(
              margin: EdgeInsets.only(left: 5, right: 20, top: 10),
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
            ),
          ],
        ),
      );
    };
    return Shimmer.fromColors(
        baseColor: !E().isThemeDarkStyle ? Colors.grey[300] : Colors.grey,
        highlightColor: !E().isThemeDarkStyle ? Colors.grey[100] : Colors.white,
        enabled: true,
        child: ListView.builder(
            itemCount: 20,
            padding: const EdgeInsets.all(0),
            itemBuilder: (context, i) {
              return getCell();
            }));
  }
}
