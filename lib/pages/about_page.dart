import 'package:byr_mobile_app/configurations/configurations.dart';
import 'package:byr_mobile_app/customizations/theme_controller.dart';
import 'package:byr_mobile_app/reusable_components/about_page_user_widget.dart';
import 'package:byr_mobile_app/reusable_components/byr_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  _buildUserList(List<String> ids) {
    return GridView.count(
      padding: EdgeInsets.all(0),
      scrollDirection: Axis.vertical,
      crossAxisCount: 4,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: ids
          .map(
            (id) => AboutPageUserWidget(
              id: id,
            ),
          )
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BYRAppBar(
        title: Text("aboutButtonTrans".tr),
      ),
      backgroundColor: E().otherPagePrimaryColor,
      body: LayoutBuilder(
        builder: (context, constraint) {
          return SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraint.maxHeight),
              child: Container(
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      height: 90,
                      child: Image.asset('resources/logo.png'),
                    ),
                    Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(bottom: 5),
                      child: Text(
                        'BYR BBS',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: E().otherPagePrimaryTextColor,
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(bottom: 10),
                      child: Text(
                        'Version ${AppConfigs.version}',
                        style: TextStyle(
                          fontSize: 16,
                          color: E().otherPageSecondaryTextColor,
                        ),
                      ),
                    ),
                    Text(
                      '    此应用为北京邮电大学北邮人论坛的官方客户端，于2019~2020年使用Flutter重新开发。',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: E().otherPagePrimaryTextColor,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 10, top: 20),
                      child: Text(
                        'APP贡献人员:',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: E().otherPagePrimaryTextColor,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          _buildUserList(['wdjwxh']),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              '设计:',
                              style: TextStyle(
                                fontSize: 16,
                                color: E().otherPageSecondaryTextColor,
                              ),
                            ),
                          ),
                          _buildUserList(['huanwoyeye', 'Moby22']),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              'Android开发:',
                              style: TextStyle(
                                fontSize: 16,
                                color: E().otherPageSecondaryTextColor,
                              ),
                            ),
                          ),
                          _buildUserList(['dss886', 'icyfox']),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              'iOS开发:',
                              style: TextStyle(
                                fontSize: 16,
                                color: E().otherPageSecondaryTextColor,
                              ),
                            ),
                          ),
                          _buildUserList(['friparia', 'darkfrost', 'nmslwsnd']),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 10, top: 20),
                      child: Text(
                        '刷新动画致谢:',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: E().otherPagePrimaryTextColor,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(bottom: 10),
                            child: Text(
                              '#北邮心跳',
                              style: TextStyle(
                                fontSize: 16,
                                color: E().otherPageSecondaryTextColor,
                              ),
                            ),
                          ),
                          _buildUserList(['zifeiyu4024']),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              '#有空调酱的北邮夏',
                              style: TextStyle(
                                fontSize: 16,
                                color: E().otherPageSecondaryTextColor,
                              ),
                            ),
                          ),
                          _buildUserList(['buddleia']),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              '#Memory of BUPT',
                              style: TextStyle(
                                fontSize: 16,
                                color: E().otherPageSecondaryTextColor,
                              ),
                            ),
                          ),
                          _buildUserList(['cdddemy']),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 10, top: 20),
                      alignment: Alignment.center,
                      child: Text(
                        'Powered by BYR-Team © 2009-2020. All Rights Reserved',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: E().otherPageSecondaryTextColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
