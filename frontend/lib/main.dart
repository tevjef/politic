import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:logging/logging.dart';

import 'core/lib.dart';
import 'ui/screens.dart';
import 'ui/util/lib.dart';

void main() async {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((LogRecord rec) {
    print('${rec.level.name}: ${rec.time}: ${rec.message}');
  });

  Crashlytics.instance.enableInDevMode = true;

  FlutterError.onError = (FlutterErrorDetails details) {
    Crashlytics.instance.recordFlutterError(details);
  };

  Locator.init();
  FirebaseAnalytics analytics = new FirebaseAnalytics();

  var app = MaterialApp(
    title: 'App Name',
    theme: new ThemeData(
      buttonTheme: new ButtonThemeData(
        buttonColor: ThemeData.light().primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(99))),
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        height: 50,
      ),
    ),
    debugShowCheckedModeBanner: false,
    navigatorObservers: [
      new FirebaseAnalyticsObserver(analytics: analytics),
    ],
    localizationsDelegates: [
      // S.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
    ],
    // localeResolutionCallback:
    // S.delegate.resolution(fallback: new Locale("en", "")),
    // supportedLocales: S.delegate.supportedLocales,
    routes: <String, WidgetBuilder>{
      Routes.home: (BuildContext context) => HomePage(),
    },
    home: HomePage(),
  );

  var error = new Logger('error');

  runZonedGuarded(() {
    runApp(app);
  }, (e, s) => {
    error.info("crash", e, s), 
    error.info(e.toString()), 
    error.info(s.toString()), 
    Crashlytics.instance.recordError(e, s)});
}
