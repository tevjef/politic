import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:politic/data/models/voter_roll.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/lib.dart';
import '../util/lib.dart';

class NotEnrolledScreen extends StatelessWidget {
  final NotEnrolled voterStatus;

  NotEnrolledScreen(this.voterStatus);

  final String _markdownData = """
**To register in New Jersey, you must be:**


* A United States citizen
* At least 17 years old, though you may not vote until you have reached the age of 18
* A resident of the county for 30 days before the election
* A person not serving a sentence of incarceration as  the result of a conviction of any indictable offense under the laws of this or another state or of the United States
""";

  @override
  Widget build(BuildContext context) {
    final controller = ScrollController();
    print(voterStatus.requirements.trim());
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
                    ImageHeadline("You’re not registered to vote.", AssetImage('res/images/notenrolled.png')),
                    Markdown(controller: controller, data: voterStatus.requirements, shrinkWrap: true, styleSheet: )
                  ],
                ),
                ButtonGroup("Register to vote", () => {launch(voterStatus.registrationUrl)})
              ],
            )));
  }
}
