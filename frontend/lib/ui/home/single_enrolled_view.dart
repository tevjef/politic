import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:politic/data/models/voter_roll.dart';
import 'package:politic/ui/home/save_information.dart';

import '../../core/lib.dart';
import '../util/lib.dart';

class SingleEnrolledScreen extends StatelessWidget {
  final SingleEnrolled voterStatus;
  final VoterInformation voterInformation;

  SingleEnrolledScreen(this.voterStatus, this.voterInformation);

  @override
  Widget build(BuildContext context) {
    List<Widget> cells = voterStatus.voterData.map((e) => ListCell(e.title, e.message)).toList();

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
                ImageHeadline("You’re are registered to vote!", AssetImage('res/images/enrolled.png')),
                ...cells
              ],
            ),
            ButtonGroup(
                "Continue",
                () => {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SaveInformationPage(voterInformation: voterInformation),
                        ),
                      )
                    })
          ],
        ),
      ),
    );
  }
}
