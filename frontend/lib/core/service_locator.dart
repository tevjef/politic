import 'package:flutter_simple_dependency_injection/injector.dart';
import 'dart:io' show Platform;

import '../data/lib.dart';

class Locator {
  static void init() {
    final injector = Injector.getInjector();

    if (Platform.isAndroid) {
      injector.map<String>((i) => "http://10.0.2.2:5000",key: "apiUrl");
    } else {
      injector.map<String>((i) => "http://localhost:5000",key: "apiUrl");
    }
    
    injector.map<AnalyticsLogger>((i) => new AnalyticsLogger(),
        isSingleton: true);

    injector.map<AdInitializer>((i) => new AdInitializer(), isSingleton: true);
    injector.map<ApiClient>((i) => new ApiClient(injector.get<String>(key: "apiUrl")), isSingleton: true);
    injector.map<Repo>((i) => new Repo(injector.get()), isSingleton: true);
  }
}
