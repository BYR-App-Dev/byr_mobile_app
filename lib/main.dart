import 'dart:ui' as ui;

import 'package:byr_mobile_app/customizations/translation.dart';
import 'package:byr_mobile_app/nforum/nforum_structures.dart';
import 'package:byr_mobile_app/pages/pages.dart';
import 'package:byr_mobile_app/pages/profile_page.dart';
import 'package:byr_mobile_app/reusable_components/fullscreen_back_page_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';

void main() {
  runApp(
    GetMaterialApp(
      localizationsDelegates: [
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      translations: Translation(),
      locale: ui.window.locale,
      fallbackLocale: Locale('zh', 'CN'),
      supportedLocales: <Locale>[
        Locale('zh', 'CN'),
        Locale('zh', 'TW'),
        Locale('zh', 'HK'),
        Locale('en', 'US'),
        Locale('en', 'UK'),
        Locale('en', 'AU'),
      ],
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case "welcome_page":
            return FullscreenBackPageRoute(builder: (context) => WelcomePage(), settings: settings, maintainState: false);
          case "login_page":
            if (settings.arguments is LoginPageRouteArg) {
              return FullscreenBackPageRoute(builder: (context) => LoginPage(settings.arguments), settings: settings, maintainState: true);
            }
            return null;
          case "home_page":
            return FullscreenBackPageRoute(builder: (context) => HomePage(), settings: settings, maintainState: true);
          case "front_page":
            return FullscreenBackPageRoute(builder: (context) => FrontPage(), settings: settings, maintainState: true);
          case "topten_page":
            return FullscreenBackPageRoute(builder: (context) => ToptenPage(), settings: settings, maintainState: true);
          case "history_page":
            return FullscreenBackPageRoute(builder: (context) => HistoryPage(), settings: settings, maintainState: true);
          case "section_page":
            if (settings.arguments is String || settings.arguments == null) {
              return FullscreenBackPageRoute(builder: (context) => SectionPage(settings.arguments), settings: settings, maintainState: true);
            }
            return null;
          case "board_page":
            if (settings.arguments is BoardPageRouteArg) {
              return FullscreenBackPageRoute(builder: (context) => BoardPage(settings.arguments), settings: settings, maintainState: true);
            }
            return null;
          case "thread_page":
            if (settings.arguments is ThreadPageRouteArg) {
              return FullscreenBackPageRoute(builder: (context) => ThreadPage(settings.arguments), settings: settings, maintainState: true);
            }
            return null;
          case "bet_page":
            if (settings.arguments is BetPageRouteArg) {
              return FullscreenBackPageRoute(builder: (context) => BetPage(settings.arguments), settings: settings, maintainState: true);
            }
            return null;
          case "vote_page":
            if (settings.arguments is VotePageRouteArg) {
              return FullscreenBackPageRoute(builder: (context) => VotePage(settings.arguments), settings: settings, maintainState: true);
            }
            return null;
          case "search_thread_page":
            if (settings.arguments is SearchThreadPageRouteArg) {
              return FullscreenBackPageRoute(builder: (context) => SearchThreadPage(settings.arguments), settings: settings, maintainState: true);
            }
            return null;
          case "profile_page":
            if (settings.arguments is UserModel) {
              return FullscreenBackPageRoute(builder: (context) => ProfilePage(user: settings.arguments), settings: settings, maintainState: true);
            }
            return null;
          case "settings_page":
            return FullscreenBackPageRoute(builder: (context) => SettingsPage(), settings: settings, maintainState: true);
          case "post_page":
            return CupertinoPageRoute(builder: (context) => PostPage(settings.arguments), settings: settings, maintainState: true);
          case "send_mail_page":
            if (settings.arguments is SendMailPageRouteArg) {
              return CupertinoPageRoute(builder: (context) => SendMailPage(settings.arguments), settings: settings, maintainState: true);
            }
            return null;
          case "mail_page":
            if (settings.arguments is MailPageRouteArg) {
              return FullscreenBackPageRoute(builder: (context) => MailPage(settings.arguments), settings: settings, maintainState: true);
            }
            return null;
          case "collection_page":
            return FullscreenBackPageRoute(builder: (context) => CollectionPage(), settings: settings, maintainState: true);
          default:
            return null;
        }
      },
      home: WelcomePage(),
    ),
  );
}
