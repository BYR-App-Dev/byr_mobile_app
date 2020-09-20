import 'package:byr_mobile_app/networking/http_request.dart';
import 'package:byr_mobile_app/nforum/nforum_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum InitializationStatus { Initializing, Initialized, Failed }

@optionalTypeArgs
mixin InitializableMixin<T extends StatefulWidget> on State<T> {
  InitializationStatus initializationStatus = InitializationStatus.Initializing;

  String failureInfo = "";

  void initializationErrorHandling(e) {
    setFailureInfo(e);
    initializationStatus = InitializationStatus.Failed;
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
}

class InitializationFailureView extends StatelessWidget {
  final String failureInfo;
  final Function refresh;
  final Color textColor;
  final Color buttonColor;

  const InitializationFailureView({Key key, this.failureInfo, this.refresh, this.textColor, this.buttonColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Text(
            failureInfo,
            style: TextStyle(color: textColor),
          ),
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: buttonColor,
            ),
            onPressed: refresh,
          ),
        ],
      ),
    );
  }
}
