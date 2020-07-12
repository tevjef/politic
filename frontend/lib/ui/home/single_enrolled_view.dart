import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:politic/data/models/voter_roll.dart';

import '../../core/lib.dart';
import '../util/lib.dart';

class SingleEnrolledScreen extends StatelessWidget {
  final SingleEnrolled voterStatus;

  SingleEnrolledScreen(this.voterStatus);

  @override
  Widget build(BuildContext context) {
    List<Widget> cells = voterStatus.voterData.map((e) => ListCell(e.title, e.message)).toList();
    
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
                    ImageHeadline("You’re are registered to vote!", AssetImage('res/images/enrolled.png')),
                    ...cells
                  ],
                ),
                ButtonGroup("Continue", () => {}, secondaryCtaText: "Exit App", secodaryListener: () => {})
              ],
            )));
  }
}
