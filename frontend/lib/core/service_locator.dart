import 'package:flutter/foundation.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';
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
        injector.map<String>((i) => "https://byteflip-politic.web.app", key: "apiUrl");

        // injector.map<String>((i) => "http://localhost:5000", key: "apiUrl");
      }
    }

    if (Platform.isAndroid) {
    } else {
      injector.map<String>((i) => "AIzaSyA0aTNzw5Zr1I4MiLuT3_LyewDqAHl9q2k", key: "placesApiKey");
    }

    injector.map<AnalyticsLogger>((i) => new AnalyticsLogger(), isSingleton: true);

    injector.map<AdInitializer>((i) => new AdInitializer(), isSingleton: true);
    injector.map<ApiClient>((i) => new ApiClient(injector.get<String>(key: "apiUrl")), isSingleton: true);
    injector.map<Repo>((i) => new Repo(injector.get()), isSingleton: true);
  }
}
