import 'package:byr_mobile_app/customizations/shimmer_theme.dart';
import 'package:byr_mobile_app/customizations/theme_controller.dart';
import 'package:byr_mobile_app/helper/helper.dart';
import 'package:byr_mobile_app/local_objects/local_storage.dart';
import 'package:byr_mobile_app/networking/http_request.dart';
import 'package:byr_mobile_app/nforum/nforum_service.dart';
import 'package:byr_mobile_app/nforum/nforum_structures.dart';
import 'package:byr_mobile_app/pages/page_components.dart';
import 'package:byr_mobile_app/pages/pages.dart';
import 'package:byr_mobile_app/reusable_components/adaptive_components.dart';
import 'package:byr_mobile_app/reusable_components/page_initialization.dart';
import 'package:byr_mobile_app/reusable_components/refreshers.dart';
import 'package:byr_mobile_app/shared_objects/shared_objects.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:byr_mobile_app/pages/pages.dart';
import 'package:universal_platform/universal_platform.dart';

class MicroPluginListBaseData<X extends MicroPluginListModel> extends PageableListBaseData<X> {
  X articleList;
  PageableListDataRequestHandler<X> dataRequestHandler;
}

class MicroPluginListPage extends PageableListBasePage {
  @override
  State<StatefulWidget> createState() {
    return MicroPluginListPageState();
  }
}

class MicroPluginListPageState extends PageableListBasePageState<MicroPluginListModel, MicroPluginListPage>
    with InitializationFailureViewMixin {
  @override
  bool get wantKeepAlive => true;

  InitializationStatus initializationStatus;

  String failureInfo = "";

  int factor = RefresherFactory.getFactor();

  RefreshController refreshController = RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    initializationStatus = InitializationStatus.Initializing;
    initialization();
  }

  void initialization() {
    data = MicroPluginListBaseData()
      ..dataRequestHandler = (int page) {
        return NForumService.getMicroPlugins();
      };
    // NForumService.getMicroPlugins().then((value) {
    //   microPlugins = value;
    //   initializationStatus = InitializationStatus.Initialized;
    //   if (mounted) {
    //     setState(() {});
    //   }
    // }).catchError(initializationErrorHandling);
    super.initialization();
  }

  // Future<void> onTopRefresh() {
  //   return NForumService.getMicroPlugins().then((value) {
  //     data.articleList = value;
  //     refreshController.refreshCompleted();
  //     if (mounted) {
  //       setState(() {});
  //     }
  //   }).catchError(refreshErrorHandling);
  // }

  void initializationErrorHandling(e) {
    setFailureInfo(e);
    initializationStatus = InitializationStatus.Failed;
    if (mounted) {
      setState(() {});
    }
  }

  void refreshErrorHandling(e) {
    setFailureInfo(e);
    refreshController.refreshFailed();
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
        failureInfo = "Unknown Exception";
        break;
    }
  }

  Widget _buildLoadingView() {
    return ShimmerTheme(
      child: ListView.separated(
        itemCount: 20,
        padding: const EdgeInsets.all(0),
        separatorBuilder: (context, i) {
          return Container(
            height: 0.0,
            margin: EdgeInsetsDirectional.only(start: 0),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: E().threadListDividerColor, width: 4),
              ),
            ),
          );
        },
        itemBuilder: (context, i) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: 5, bottom: 10, top: 8),
                  height: 20,
                  width: (85 / 100) * MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                ),
                Container(
                  margin: EdgeInsets.only(left: 5),
                  height: 15,
                  width: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Widget _buildPluginList() {
  //   return ListView.builder(
  //       itemCount: microPlugins?.length ?? 0,
  //       itemBuilder: (buildContext, index) {
  //         return ListTile(
  //           title: Text(
  //             microPlugins[index]["name"],
  //             style: TextStyle(color: E().otherPagePrimaryTextColor),
  //           ),
  //           onTap: () {
  //             navigator.push(CupertinoPageRoute(
  //                 builder: (_) => MicroPluginPage(
  //                       pluginName: microPlugins[index]["name"],
  //                       pluginURI: UniversalPlatform.isAndroid
  //                           ? (microPlugins[index]["uri_android"] ?? microPlugins[index]["uri"])
  //                           : (microPlugins[index]["uri_ios"] ?? microPlugins[index]["uri"]),
  //                     )));
  //           },
  //         );
  //       });
  // }

  @override
  Widget buildCell(BuildContext context, int index) {
    return ListTile(
      title: Text(
        data.articleList.article[index].name,
        style: TextStyle(color: E().otherPagePrimaryTextColor),
      ),
      onTap: () {
        navigator.push(CupertinoPageRoute(
            builder: (_) => MicroPluginPage(
                  pluginName: data.articleList.article[index].name,
                  pluginURI: LocalStorage.getIsOverseaEnabled()
                      ? (UniversalPlatform.isAndroid
                          ? (data.articleList.article[index].uriAndroidOversea ??
                              data.articleList.article[index].uriOversea)
                          : (data.articleList.article[index].uriiOSOversea ??
                              data.articleList.article[index].uriOversea))
                      : (UniversalPlatform.isAndroid
                          ? (data.articleList.article[index].uriAndroid ?? data.articleList.article[index].uri)
                          : (data.articleList.article[index].uriiOS ?? data.articleList.article[index].uri)),
                )));
      },
    );
  }

  @override
  Widget buildSeparator(BuildContext context, int index, {bool isLast = false}) {
    if (index == 0) {
      return Container(
        height: 4.0,
        margin: EdgeInsetsDirectional.zero,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
                color: data.articleList.showWebLink ? E().threadListDividerColor : Colors.transparent, width: 4),
          ),
        ),
      );
    }
    return Container(
      height: 4.0,
      margin: EdgeInsetsDirectional.zero,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: E().threadListDividerColor, width: 4),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Obx(
      () => Scaffold(
        backgroundColor: E().threadListBackgroundColor,
        body: Column(
          children: [
            if (initializationStatus == InitializationStatus.Initialized &&
                data.articleList != null &&
                data.articleList.showWebLink)
              Container(
                child: Center(
                  child: Text(
                    "网页版: " + data.articleList.webLink,
                    style: TextStyle(color: E().otherPagePrimaryTextColor),
                  ),
                ),
              ),
            if (initializationStatus == InitializationStatus.Initialized &&
                data.articleList != null &&
                data.articleList.showWebLink)
              ListTile(
                title: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Icon(Icons.devices_sharp, color: E().otherPagePrimaryTextColor),
                      ),
                      Text(
                        "网页版小程序扫码登录",
                        style: TextStyle(color: E().otherPagePrimaryTextColor),
                      ),
                    ],
                  ),
                ),
                onTap: () async {
                  UserModel me;
                  if (SharedObjects.me != null) {
                    me = await SharedObjects.me;
                  }
                  if (me != null && me.id != null && me.id != "") {
                    navigator.push(CupertinoPageRoute(builder: (_) => FullScreenScannerPage(me.id)));
                  } else {
                    AdaptiveComponents.showToast(context, "请等待【我】页面用户资料加载完成再扫码");
                  }
                },
              ),
            Expanded(
              child: RefreshConfiguration(
                child: Center(
                  child: widgetCase(
                    initializationStatus,
                    {
                      InitializationStatus.Initializing: _buildLoadingView(),
                      InitializationStatus.Initialized: data.articleList == null
                          ? _buildLoadingView()
                          : RefresherFactory(
                              factor,
                              refreshController,
                              true,
                              false,
                              onTopRefresh,
                              null,
                              buildList(),
                            ),
                      InitializationStatus.Failed: InitializationFailureView(
                        failureInfo: failureInfo,
                        textColor: E().threadListOtherTextColor,
                        buttonColor: E().threadListOtherTextColor,
                        refresh: initialization,
                      ),
                    },
                    _buildLoadingView(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
