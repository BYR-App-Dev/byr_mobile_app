# 北邮人论坛手机客户端
[bbs.byr.cn](https://bbs.byr.cn)

中文|[EN](README-EN.md)

## 编译并运行
- 安装[Flutter](https://flutter.dev/docs/get-started/)，中国大陆地区用户可访问[官方中国大陆地区网站](https://flutter.cn/docs/get-started/)，版本1.17.5
- 配置Secrets
    - 在北邮人论坛[相关版面](https://bbs.byr.cn/#!board/BBSOpenAPI)申请*clientID*、*认证链接*、*identifier*等信息
    - 新建一个私有仓库命名为*Secrets*包含如下文件结构
        ```
        lib/secrets.dart
        pubspec.yaml
        ```
        在```lib/secrets.dart```保存如下内容，!起始的是需要向论坛管理员申请的内容
        ```
        class Secrets {
            static const String clientID = !CLIENT ID
            static const String appleID = APPLE ID
            static const String bundleID = BUNDLE ID
            static const String identifier = !IDENTIFIER
            static const String welcomeSalt = !WELCOME SALT
            static const String tokenDir = !OAUTH URL
            static const String androidDevUpdateLink = ANDROID APP DEV UPDATE LINK
            static const String androidStableUpdateLink = ANDROID APP STABLE UPDATE LINK
            static const String androidVersionsLink = ANDROID VERSIONS LINK
        }
        ```
    - 替换此项目```/pubspec.yaml```的如下内容为上步所建仓库的URL
        ```
        secrets:
        git:
            url: ssh://git@github.com/BYR-App-Dev/secrets.git
        ```
- 项目根目录执行```flutter pub get```以获取依赖
- 运行
    - Debug ```flutter run --debug```
    - Release ```flutter run --release```
    - Build iOS ```./ios_build_cmd.sh```
    - Build Android ```./android_build_cmd.sh```

## 项目文件结构
- [resources/](resources/)
    - 项目相关的资源文件
- [lib/](lib/)
    - [configurations/](lib/configurations/) 应用的配置
    - [customizations/](lib/customizations/) 应用的定制化 如配色、语言等
    - [data_structures/](lib/data_structures/) 应用内部用到的数据类
    - [helper/](lib/helper/) 辅助性函数
    - [local_objects/](lib/local_objects/) 本地数据存储
    - [networking/](lib/networking/) 网络请求函数
    - [nforum/](lib/nforum/) NForum接口相关的函数和数据类
    - [pages/](lib/pages/) 页面显示相关类
    - [reusable_components/](lib/reusable_components/) 在页面中使用的组件
    - [shared_objects/](lib/shared_objects/) 运行时应用内共享的数据
    - [tasks/](lib/tasks/) 应用启动时的任务
    - [main.dart](lib/main.dart) 应用入口

## 使用的开源库
- [hive](https://pub.dev/packages/hive)
- [get](https://pub.dev/packages/get)
- [flutter_cache_manager](https://pub.dev/packages/flutter_cache_manager)
- [universal_platform](https://pub.dev/packages/universal_platform)
- [transparent_image](https://pub.dev/packages/transparent_image)
- [cached_network_image](https://pub.dev/packages/cached_network_image)
- [font_awesome_flutter](https://pub.dev/packages/font_awesome_flutter)
- [pull_to_refresh](https://pub.dev/packages/pull_to_refresh)
- [flutter_gifimage](https://pub.dev/packages/flutter_gifimage)
- [shimmer](https://pub.dev/packages/shimmer)
- [qr_flutter](https://pub.dev/packages/qr_flutter)
- [fast_gbk](https://pub.dev/packages/fast_gbk)
- [image_picker](https://pub.dev/packages/image_picker)
- [extended_text_field](https://pub.dev/packages/extended_text_field)
- [extended_image](https://pub.dev/packages/extended_image)
- [audioplayers](https://pub.dev/packages/audioplayers)
- [file_picker](https://pub.dev/packages/file_picker)
- [permission_handler](https://pub.dev/packages/permission_handler)
- [flutter_audio_recorder](https://pub.dev/packages/flutter_audio_recorder)
- [flutter_staggered_grid_view](https://pub.dev/packages/flutter_staggered_grid_view)
- [flutter_icons](https://pub.dev/packages/flutter_icons)
- [ota_update](https://pub.dev/packages/ota_update)
- [uni_links](https://pub.dev/packages/uni_links)
- [modal_bottom_sheet](https://pub.dev/packages/modal_bottom_sheet)
- [toast](https://pub.dev/packages/toast)
- [speech_recognition](https://pub.dev/packages/speech_recognition)
- [like_button](https://pub.dev/packages/like_button)
- [gallery_saver](https://pub.dev/packages/gallery_saver)
- [scroll_to_index](https://pub.dev/packages/scroll_to_index)
- [tinycolor](https://pub.dev/packages/tinycolor)
- [filesize](https://pub.dev/packages/filesize)
- [screenshot](https://pub.dev/packages/screenshot)
- [overlay_widget](https://takeroro.github.io/2019/07/28/Flutter-Overlay/)
- [pull_to_refresh_notification](https://pub.dev/packages/pull_to_refresh_notification)