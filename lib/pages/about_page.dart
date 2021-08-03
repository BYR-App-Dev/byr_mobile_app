import 'package:byr_mobile_app/configurations/configurations.dart';
import 'package:byr_mobile_app/customizations/theme_controller.dart';
import 'package:byr_mobile_app/pages/board_page.dart';
import 'package:byr_mobile_app/pages/web_page.dart';
import 'package:byr_mobile_app/reusable_components/about_page_user_widget.dart';
import 'package:byr_mobile_app/reusable_components/byr_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class _Contributor {
  String id;
  String description;
  _Contributor(this.id, this.description);
}

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  _buildCell(String title, List<_Contributor> contributors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 20),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: E().otherPagePrimaryTextColor,
            ),
          ),
        ),
        Divider(),
        Padding(
          padding: EdgeInsets.only(left: 20),
          child: ListView.separated(
            padding: EdgeInsets.all(0),
            itemBuilder: (_, index) {
              if (index < contributors.length) {
                return AboutPageUserWidget(
                  id: contributors[index].id,
                  description: contributors[index].description,
                );
              }
              return null;
            },
            separatorBuilder: (_, index) => Divider(),
            itemCount: contributors.length + 1,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
          ),
        ),
      ],
    );
  }

  _buildCommunityCell() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        navigator.push(
          CupertinoPageRoute(
            builder: (_) => WebPage(
              WebPageRouteArg("https://github.com/BYR-App-Dev/byr_mobile_app/contributors"),
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(top: 20, left: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "社区贡献者致谢",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: E().otherPagePrimaryTextColor,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: E().settingItemCellSubColor,
                  ),
                ),
              ],
            ),
            Divider(),
          ],
        ),
      ),
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
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    GestureDetector(
                      onDoubleTap: () {
                        navigator.push(CupertinoPageRoute(builder: (_) => BoardPage(BoardPageRouteArg("IWhisper"))));
                      },
                      child: Container(
                        width: double.infinity,
                        height: 90,
                        child: Image.asset('resources/logo.png'),
                      ),
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
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        '    此应用为北京邮电大学北邮人论坛的官方客户端，于2019~2021年使用Flutter重新开发。',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: E().otherPagePrimaryTextColor,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          _buildCell(
                            '开发人员',
                            [
                              _Contributor('wdjwxh', ''),
                              _Contributor('nmslwsnd', ''),
                            ],
                          ),
                          _buildCell(
                            '其他开发人员致谢',
                            [
                              _Contributor('paper777', '后台'),
                              _Contributor('dss886', 'Android'),
                              _Contributor('icyfox', 'Android'),
                              _Contributor('friparia', 'IOS'),
                              _Contributor('huanwoyeye', '设计'),
                              _Contributor('Moby22', '设计'),
                            ],
                          ),
                          _buildCell(
                            '刷新动画致谢',
                            [
                              _Contributor('zifeiyu4024', '#北邮心跳'),
                              _Contributor('buddleia', '#有空调酱的北邮夏'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    _buildCommunityCell(),
                    Container(
                      margin: EdgeInsets.only(
                        bottom: 10,
                        top: 20,
                        left: 15,
                        right: 15,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Powered by BYR-Team © 2009-2020. All Rights Reserved.',
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
