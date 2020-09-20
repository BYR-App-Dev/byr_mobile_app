import 'package:byr_mobile_app/reusable_components/byr_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebPage extends StatefulWidget {
  final WebPageRouteArg arg;

  WebPage(this.arg);

  @override
  WebPageState createState() {
    return WebPageState();
  }
}

class WebPageState extends State<WebPage> {
  WebViewController controller;

  @override
  void dispose() {
    super.dispose();
  }

  void getWebViewController(WebViewController _controller) {
    this.controller = _controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BYRAppBar(
        title: Text(
          "browseWebPageTrans".tr,
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              controller.goBack();
            },
          ),
          IconButton(
            icon: Icon(Icons.arrow_forward),
            onPressed: () {
              controller.goForward();
            },
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              controller.reload();
            },
          ),
        ],
      ),
      body: WebView(
        onWebViewCreated: getWebViewController,
        initialUrl: this.widget.arg.iniURL,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}

class WebPageRouteArg {
  final String iniURL;

  WebPageRouteArg(this.iniURL);
}
