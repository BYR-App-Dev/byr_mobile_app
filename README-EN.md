# Mobile App for BYR BBS
[bbs.byr.cn](https://bbs.byr.cn)

[中文](README.md)|EN

## Compile and Run
- Install [Flutter](https://flutter.dev/docs/get-started/)
- Configure Secrets
    - Apply for *clientID*、*OAuth URL*、*identifier*, etc under [open api board](https://bbs.byr.cn/#!board/BBSOpenAPI) of BYR BBS
    - Create a new repository of name *Secrets* with following project structure
        ```
        lib/secrets.dart
        pubspec.yaml
        ```
        Save the following content in ```lib/secrets.dart```, fields start with ! should be acquired from BBS Admin mentioned above
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
    - replace the following content in ```/pubspec.yaml``` of this repository with the URL of the repository from above step
        ```
        secrets:
        git:
            url: ssh://git@github.com/BYR-App-Dev/secrets.git
        ```
- Run ```flutter pub get``` under the root of project to fetch dependencies
- Run application
    - Debug ```flutter run --debug```
    - Release ```flutter run --release```
    - Build iOS ```flutter build ios```
    - Build Android ```flutter build apk```

## Project Structure
- [resources/](resources/)
    - resources files
- [lib/](lib/)
    - [configurations/](lib/configurations/) configurations of the app
    - [customizations/](lib/customizations/) customizations, e.g. themes, languages
    - [data_structures/](lib/data_structures/) internal data classes
    - [helper/](lib/helper/) helper functions
    - [local_objects/](lib/local_objects/) local data storage
    - [networking/](lib/networking/) network requests
    - [nforum/](lib/nforum/) NForum API related functions and data models
    - [pages/](lib/pages/) page classes
    - [reusable_components/](lib/reusable_components/) components used in pages
    - [shared_objects/](lib/shared_objects/) shared objects in runtime
    - [tasks/](lib/tasks/) tasks during startup
    - [main.dart](lib/main.dart) entry of the app

## Open Source Library Credits
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