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