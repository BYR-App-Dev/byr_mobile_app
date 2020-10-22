// import 'package:byr_mobile_app/customizations/shimmer_theme.dart';
// import 'package:byr_mobile_app/customizations/theme_controller.dart';
// import 'package:byr_mobile_app/helper/helper.dart';
// import 'package:byr_mobile_app/networking/http_request.dart';
// import 'package:byr_mobile_app/nforum/nforum_service.dart';
// import 'package:byr_mobile_app/pages/pages.dart';
// import 'package:byr_mobile_app/reusable_components/page_initialization.dart';
// import 'package:byr_mobile_app/reusable_components/refreshers.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:universal_platform/universal_platform.dart';

// class MicroPluginListPage extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return MicroPluginListPageState();
//   }
// }

// class MicroPluginListPageState extends State<MicroPluginListPage> with AutomaticKeepAliveClientMixin {
//   @override
//   bool get wantKeepAlive => true;

//   InitializationStatus initializationStatus;

//   String failureInfo = "";

//   int factor = RefresherFactory.getFactor();

//   RefreshController refreshController = RefreshController(initialRefresh: false);

//   List<Map> microPlugins;
//   @override
//   void initState() {
//     super.initState();
//     initializationStatus = InitializationStatus.Initializing;
//     initialization();
//   }

//   void initialization() {
//     NForumService.getMicroPlugins().then((value) {
//       microPlugins = value;
//       initializationStatus = InitializationStatus.Initialized;
//       if (mounted) {
//         setState(() {});
//       }
//     }).catchError(initializationErrorHandling);
//   }

//   Future<void> onTopRefresh() {
//     return NForumService.getMicroPlugins().then((value) {
//       microPlugins = value;
//       refreshController.refreshCompleted();
//       if (mounted) {
//         setState(() {});
//       }
//     }).catchError(refreshErrorHandling);
//   }

//   void initializationErrorHandling(e) {
//     setFailureInfo(e);
//     initializationStatus = InitializationStatus.Failed;
//     if (mounted) {
//       setState(() {});
//     }
//   }

//   void refreshErrorHandling(e) {
//     setFailureInfo(e);
//     refreshController.refreshFailed();
//   }

//   void setFailureInfo(e) {
//     switch (e.runtimeType) {
//       case NetworkException:
//         failureInfo = "networkExceptionTrans".tr;
//         break;
//       case APIException:
//         failureInfo = e.toString();
//         break;
//       case DataException:
//         failureInfo = "dataExceptionTrans".tr;
//         break;
//       default:
//         failureInfo = "Unknown Exception";
//         break;
//     }
//   }

//   Widget _buildLoadingView() {
//     return ShimmerTheme(
//       child: ListView.separated(
//         itemCount: 20,
//         padding: const EdgeInsets.all(0),
//         separatorBuilder: (context, i) {
//           return Container(
//             height: 0.0,
//             margin: EdgeInsetsDirectional.only(start: 0),
//             decoration: BoxDecoration(
//               border: Border(
//                 bottom: BorderSide(color: E().threadListDividerColor, width: 4),
//               ),
//             ),
//           );
//         },
//         itemBuilder: (context, i) {
//           return Container(
//             margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 Container(
//                   margin: EdgeInsets.only(left: 5, bottom: 10, top: 8),
//                   height: 20,
//                   width: (85 / 100) * MediaQuery.of(context).size.width,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.all(Radius.circular(5)),
//                   ),
//                   padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
//                 ),
//                 Container(
//                   margin: EdgeInsets.only(left: 5),
//                   height: 15,
//                   width: 120,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.all(Radius.circular(5)),
//                   ),
//                   padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildPluginList() {
//     return ListView.builder(
//         itemCount: microPlugins?.length ?? 0,
//         itemBuilder: (buildContext, index) {
//           return ListTile(
//             title: Text(
//               microPlugins[index]["name"],
//               style: TextStyle(color: E().otherPagePrimaryTextColor),
//             ),
//             onTap: () {
//               navigator.push(CupertinoPageRoute(
//                   builder: (_) => MicroPluginPage(
//                         pluginName: microPlugins[index]["name"],
//                         pluginURI: UniversalPlatform.isAndroid
//                             ? (microPlugins[index]["uri_android"] ?? microPlugins[index]["uri"])
//                             : (microPlugins[index]["uri_ios"] ?? microPlugins[index]["uri"]),
//                       )));
//             },
//           );
//         });
//   }

//   @override
//   Widget build(BuildContext context) {
//     super.build(context);
//     return Obx(
//       () => Scaffold(
//         backgroundColor: E().threadListBackgroundColor,
//         body: RefreshConfiguration(
//           child: Center(
//             child: widgetCase(
//               initializationStatus,
//               {
//                 InitializationStatus.Initializing: _buildLoadingView(),
//                 InitializationStatus.Initialized: microPlugins == null
//                     ? _buildLoadingView()
//                     : RefresherFactory(
//                         factor,
//                         refreshController,
//                         true,
//                         false,
//                         onTopRefresh,
//                         null,
//                         _buildPluginList(),
//                       ),
//                 InitializationStatus.Failed: InitializationFailureView(
//                   failureInfo: failureInfo,
//                   textColor: E().threadListOtherTextColor,
//                   buttonColor: E().threadListOtherTextColor,
//                   refresh: initialization,
//                 ),
//               },
//               _buildPluginList(),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
