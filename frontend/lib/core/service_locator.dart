import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:liebeslied/data/client.dart';

import '../data/lib.dart';

class Locator {
  static void init() {
    final injector = Injector.getInjector();

    injector.map<String>((i) => "https://api.coursetrakr.io/v2",key: "apiUrl");
    injector.map<AnalyticsLogger>((i) => new AnalyticsLogger(),
        isSingleton: true);

    injector.map<AdInitializer>((i) => new AdInitializer(), isSingleton: true);
    injector.map<ApiClient>((i) => new ApiClient(injector.get<String>(key: "apiUrl")), isSingleton: true);
    injector.map<Repo>((i) => new Repo(injector.get()), isSingleton: true);
  }
}
