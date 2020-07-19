import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:politic/ui/home/home_view.dart';
import 'package:politic/ui/util/lib.dart';

class NotificationRepo {
  GlobalKey<ScaffoldState> scaffoldKey;

  final FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  final String groupKey = "com.byteflip.politic";

  BuildContext _buildContext;

  bool didInitializeLocalNotifications = false;

  NotificationRepo() {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        var title = message['notification']['title'];
        var body = message['notification']['body'];

        createNotification(title, body).then((a) {});

        scaffoldKey?.currentState?.showSnackBar(Widgets.makeSnackBar(body));
      },
      onLaunch: (Map<String, dynamic> message) async {
        Navigator.of(_buildContext).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => PoliticHomePage(),
            ),
            (Route<dynamic> route) => false);
      },
      onResume: (Map<String, dynamic> message) async {
        Navigator.of(_buildContext).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => PoliticHomePage(),
            ),
            (Route<dynamic> route) => false);
      },
    );
  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      Navigator.of(_buildContext).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => PoliticHomePage(),
          ),
          (Route<dynamic> route) => false);
    }
  }

  Future<String> getToken() {
    return _firebaseMessaging.getToken();
  }

  void register(GlobalKey<ScaffoldState> key) {
    scaffoldKey = key;
  }

  void registerContext(BuildContext context) {
    _buildContext = context;
  }

  void initializeLocalNotifications() {
    if (didInitializeLocalNotifications) {
      return;
    }

    var initializationSettingsAndroid = new AndroidInitializationSettings('ic_notification');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: onSelectNotification);

    didInitializeLocalNotifications = true;
  }

  AndroidNotificationDetails createGenericChannel() {
    return new AndroidNotificationDetails('channel_general', "General", "Notifications from Politic",
        groupKey: groupKey,
        enableVibration: false,
        color: Color(0x607D8B),
        importance: Importance.Default,
        priority: Priority.High);
  }

  Future createNotification(String title, String body) async {
    var androidPlatformChannelSpecifics = createGenericChannel();

    var iOSPlatformChannelSpecifics = IOSNotificationDetails(presentAlert: true);

    var platformChannelSpecifics =
        new NotificationDetails(androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(body.hashCode, title, body, platformChannelSpecifics);
  }
}
