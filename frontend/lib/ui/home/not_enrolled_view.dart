import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:politic/data/models/voter_roll.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:politic/ui/home/save_information.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/lib.dart';
import '../util/lib.dart';

class NotEnrolledScreen extends StatelessWidget {
  final NotEnrolled voterStatus;
  final VoterInformation voterInformation;

  NotEnrolledScreen(this.voterStatus, this.voterInformation);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          return Future<bool>.value(false);
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
                    Markdown(
                      data: voterStatus.requirements,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 32),
                    ),
                    ListButtonCell("Phone", voterStatus.phone.label, "Call", () => {launch(voterStatus.phone.uri)}),
                    ListButtonCell("Website", voterStatus.registrationUrl.label, "Visit",
                        () => {launch(voterStatus.registrationUrl.uri)})
                  ],
                ),
                ButtonGroup(
                  "Register to vote",
                  () => {launch(voterStatus.registrationUrl.uri)},
                  secondaryCtaText: "Continue",
                  secodaryListener: () => {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SaveInformationPage(voterInformation: voterInformation),
                      ),
                    )
                  },
                ),
              ],
            )));
  }
}
