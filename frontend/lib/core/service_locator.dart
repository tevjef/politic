import 'package:flutter/foundation.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:politic/data/auth.dart';
import 'package:politic/data/notifications.dart';
import 'dart:io' show Platform;

import '../data/lib.dart';

class Locator {
  static void init() {
    final injector = Injector.getInjector();

    if (kReleaseMode) {
      injector.map<String>((i) => "https://byteflip-politic.web.app", key: "apiUrl");
    } else {
      if (Platform.isAndroid) {
        injector.map<String>((i) => "http://10.0.2.2:5000", key: "apiUrl");
      } else {
        // injector.map<String>((i) => "https://byteflip-politic.web.app", key: "apiUrl");

        injector.map<String>((i) => "http://localhost:5000", key: "apiUrl");
      }
    }

    if (Platform.isAndroid) {
    } else {
      injector.map<String>((i) => "", key: "placesApiKey");
    }

    injector.map<AnalyticsLogger>((i) => new AnalyticsLogger(), isSingleton: true);

    injector.map<AdInitializer>((i) => new AdInitializer(), isSingleton: true);
    injector.map<NotificationRepo>((i) => new NotificationRepo(), isSingleton: true);
    injector.map<Auth>((i) => new Auth(), isSingleton: true);
    injector.map<ApiClient>((i) => new ApiClient(injector.get<String>(key: "apiUrl"), injector.get()),
        isSingleton: true);
    injector.map<Repo>((i) => new Repo(injector.get(), injector.get(), injector.get()), isSingleton: true);
  }
}
