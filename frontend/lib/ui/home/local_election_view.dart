import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:geocoder/geocoder.dart';
import 'package:location/location.dart';
import 'package:politic/data/models/feed.dart';
import 'package:politic/data/models/user.dart';
import 'package:politic/ui/home/feed_state_view.dart';
import 'package:politic/ui/home/upcoming_elections_view.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/lib.dart';
import '../../data/lib.dart';
import '../util/lib.dart';

class LocalElectionPage extends StatefulWidget {
  const LocalElectionPage({Key key}) : super(key: key);

  @override
  LocalElectionState createState() => new LocalElectionState();
}

class LocalElectionState extends State<LocalElectionPage> with LDEViewMixin implements LocalElectionView {
  LocalElectionState() {}

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future<bool>.value(true);
      },
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => LocalElectionPresenter(this, context)),
        ],
        child: Consumer<LocalElectionPresenter>(builder: (context, presenter, child) {
          var election = presenter.election;
          Widget mainWidget = Container();
          if (election == null) {
            mainWidget = Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 0.0),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Image.asset('res/images/marker.png'),
                  ),
                  Text(
                    "There are no elections near you currently.",
                    textAlign: TextAlign.center,
                    style: Styles.headline5(Theme.of(context)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Text(
                      "This does not mean your civic duty ends here. Find and participate in grassroots movements you believe in.",
                      textAlign: TextAlign.center,
                      style: Styles.body1(Theme.of(context)),
                    ),
                  ),
                  ButtonGroup(
                    "See other elections",
                    () => {presenter.onSeeAllElectionsClick()},
                  )
                ],
              ),
            );
          } else {
            Widget electionInformation = Container();
            if (election.electionAdministrationBody.electionInfoUrl != null) {
              var info = election.electionAdministrationBody.electionInfoUrl;
              electionInformation = ListButtonCell("Election Information", info.label, "Visit", () {
                launch(info.uri);
              });
            }

            mainWidget = Column(
              children: <Widget>[
                Headline(
                    election.electionsName, "Check below for the contests on the ballot on ${election.electionDay}"),
                electionInformation,
                Column(children: <Widget>[
                  electionInformation,
                  ...election.contests.map((value) {
                    return ListCell(value.title, value.subtitle);
                  })
                ])
              ],
            );
          }

          return Scaffold(
            key: scaffoldKey,
            backgroundColor: Theme.of(context).colorScheme.surface,
            appBar: AppBar(
              brightness: Brightness.light,
              backgroundColor: Theme.of(context).colorScheme.surface,
              elevation: 0,
            ),
            body: Stack(
              children: <Widget>[
                presenter.isLoading ? Center(child: CircularProgressIndicator()) : SizedBox.shrink(),
                mainWidget,
              ],
            ),
          );
        }),
      ),
    );
  }

  @override
  void onRefreshData() {}
}

abstract class LocalElectionView implements BaseView, ListOps {
  // void navigateToSomewhere();
}

class LocalElectionPresenter extends BasePresenter<LocalElectionView> with ChangeNotifier, DiagnosticableTreeMixin {
  Repo repo;
  bool isLoading = false;
  BuildContext context;
  Election election;

  LocalElectionPresenter(LocalElectionView view, BuildContext context) : super(view) {
    final injector = Injector.getInjector();
    repo = injector.get();
    this.context = context;
    loadData();
  }

  void loadData() async {
    election = (await repo.getUserElection()).election;
    notifyListeners();
  }

  void updateLoading(bool isLoading) {
    this.isLoading = isLoading;
    notifyListeners();
  }

  onSeeAllElectionsClick() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpcomingElectionsPage(),
      ),
    );
  }
}
