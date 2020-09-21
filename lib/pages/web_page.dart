import 'package:byr_mobile_app/reusable_components/byr_app_bar.dart';
import 'package:byr_mobile_app/reusable_components/login_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tuple/tuple.dart';
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

  void finishedLoading(String url) async {
    print(url);
    if (this.controller != null) {
      if (url.startsWith("https://bbs.byr.cn/n/login")) {
        Tuple2 userIdAndPassword = await showDialog(context: context, child: LoginDialog());
        String userid = userIdAndPassword.item1;
        String password = userIdAndPassword.item2;
        print(userid);
        print(password);
        this.controller.evaluateJavascript("javascript:document.getElementsByName('username')[0].value = '" +
            userid +
            "';" +
            "var event = new Event('input');document.getElementsByName('username')[0].dispatchEvent(event);" +
            "document.getElementsByName('password')[0].value = '" +
            password +
            "';" +
            "var event = new Event('input');document.getElementsByName('password')[0].dispatchEvent(event);");
      }
    }
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
        onPageFinished: finishedLoading,
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
