import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:politic/data/models/voter_roll.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/lib.dart';
import '../util/lib.dart';

class NotFoundScreen extends StatelessWidget {
  final NotFound voterStatus;

  NotFoundScreen(this.voterStatus);

  @override
  Widget build(BuildContext context) {
    var status = voterStatus.phone;
    return WillPopScope(
        onWillPop: () {
          return Future<bool>.value(true);
        },
        child: Scaffold(
            backgroundColor: Theme.of(context).colorScheme.surface,
            appBar: AppBar(
              brightness: Brightness.light,
              backgroundColor: Theme.of(context).colorScheme.surface,
              elevation: 0,
            ),
            body: Stack(
              children: <Widget>[
                ListView(
                  children: <Widget>[
                    Headline("We could not verify your registration.",
                        "You can manually check your registration status using the options below. "),
                    ListButtonCell("Phone", voterStatus.phone, "Call", () => { launch(voterStatus.phone) }),
                    ListButtonCell("Website", voterStatus.web, "Visit", () => { launch(voterStatus.web)})
                  ],
                ),
                ButtonGroup("Continue", () => {}, secondaryCtaText: "Exit App", secodaryListener: () => {})
              ],
            )));
  }
}
