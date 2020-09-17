import 'package:byr_mobile_app/configurations/configurations.dart';
import 'package:byr_mobile_app/nforum/nforum_service.dart';
import 'package:byr_mobile_app/nforum/nforum_structures.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  final LoginPageRouteArg arg;
  LoginPage(this.arg);

  @override
  State<StatefulWidget> createState() {
    return LoginPageState();
  }
}

class LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  RxBool _isIPv6Used = AppConfigs.isIPv6Used.obs;

  bool get isIPv6Used {
    return _isIPv6Used.value;
  }

  set isIPv6Used(bool v) {
    AppConfigs.useIPv6(v);
    _isIPv6Used.value = AppConfigs.isIPv6Used;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  dispose() {
    usernameController.dispose();
    passwordController.dispose();
    return super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (BuildContext context) {
          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('resources/login_page/loginbg.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                overflow: Overflow.visible,
                children: <Widget>[
                  Container(
                    width: 320,
                    height: 420,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 5.0),
                              width: 250.0,
                              child: TextFormField(
                                controller: usernameController,
                                autocorrect: false,
                                decoration: InputDecoration(labelText: "loginUsernameTrans".tr),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'user id cannot be empty';
                                  }
                                  if (!GetUtils.isUsername(value)) {
                                    return "invalid user id format";
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 5.0),
                              width: 250.0,
                              child: TextFormField(
                                controller: passwordController,
                                autocorrect: false,
                                obscureText: true,
                                decoration: InputDecoration(labelText: "loginPasswordTrans".tr),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'password cannot be empty';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 20.0),
                              child: CupertinoButton.filled(
                                pressedOpacity: 0.6,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(6),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 110.0),
                                onPressed: () async {
                                  FocusScope.of(context).requestFocus(
                                    FocusNode(),
                                  );
                                  if (formKey.currentState.validate()) {
                                    Scaffold.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text("loginSubmitTrans".tr + '...'),
                                      ),
                                    );
                                    OAuthInfo oauthInfo = await NForumService.postLoginInfo(
                                        usernameController.text, passwordController.text);
                                    if (oauthInfo is OAuthErrorInfo) {
                                      Scaffold.of(context).removeCurrentSnackBar();
                                      Scaffold.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(oauthInfo.msg),
                                        ),
                                      );
                                    } else {
                                      await NForumService.loginUser((oauthInfo as OAuthAccessInfo).accessToken);
                                      if (widget.arg.isAddingMoreAccount) {
                                        navigator.pop(true);
                                      } else {
                                        navigator.pushReplacementNamed("home_page");
                                      }
                                    }
                                  }
                                },
                                child: Text("loginSubmitTrans".tr),
                              ),
                            ),
                            Visibility(
                                visible: widget.arg.isAddingMoreAccount,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 0.0),
                                  child: CupertinoButton.filled(
                                    pressedOpacity: 0.6,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(6),
                                    ),
                                    padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 110.0),
                                    onPressed: widget.arg.isAddingMoreAccount
                                        ? () {
                                            navigator.pop(false);
                                          }
                                        : null,
                                    child: Text("cancelTrans".tr),
                                  ),
                                )),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 0.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  CupertinoButton(
                                    pressedOpacity: 0.5,
                                    padding: EdgeInsets.symmetric(vertical: 0, horizontal: 16.0),
                                    onPressed: () {
                                      FocusScope.of(context).requestFocus(
                                        FocusNode(),
                                      );
                                      Scaffold.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('手机客户端暂时无法重置密码'),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      "loginForgetPasswordTrans".tr,
                                      style: TextStyle(color: Colors.black54),
                                    ),
                                  ),
                                  CupertinoButton(
                                    pressedOpacity: 0.5,
                                    padding: EdgeInsets.symmetric(vertical: 0, horizontal: 16.0),
                                    onPressed: () {
                                      FocusScope.of(context).requestFocus(
                                        FocusNode(),
                                      );
                                      Scaffold.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('手机客户端暂时无法注册'),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      "loginSignUpTrans".tr,
                                      style: TextStyle(color: Colors.blueAccent),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.symmetric(vertical: 0.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Checkbox(
                                        value: isIPv6Used,
                                        onChanged: (b) {
                                          isIPv6Used = b;
                                        }),
                                    Text("useIPv6".tr)
                                  ],
                                )),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: -40,
                    child: CircleAvatar(
                        radius: 40,
                        backgroundImage: AssetImage(
                          "resources/user/face_default_m.jpg",
                        ),
                        backgroundColor: Colors.transparent),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class LoginPageRouteArg {
  final isAddingMoreAccount;

  LoginPageRouteArg({this.isAddingMoreAccount = false});
}
