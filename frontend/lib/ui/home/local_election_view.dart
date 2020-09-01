import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:politic/data/models/feed.dart';
import 'package:politic/ui/home/upcoming_elections_view.dart';
import 'package:politic/ui/util/constants.dart';
import 'package:provider/provider.dart';
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
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
            mainWidget = ListView(
              children: <Widget>[
                Headline(
                    election.electionName, "Check below for the contests on the ballot on ${election.electionDay}"),
                Contests(election.contests),
                ElectionLocation(election.pollingLocations, "Polling Locations", null),
                ElectionLocation(election.earlyVoteSites, "Early Voting", null),
                ElectionLocation(election.dropOffLocations, "Drop-off Locations",
                    "You must have received and completed a ballot prior to arriving at the location. The location may not have ballots available on the premises."),
                ElectionAdministrationInfo(
                    "Election Infoformation", election.electionAdministrationBody.electionInfoUrl),
                ElectionAdministrationInfo(
                    "Election Registration", election.electionAdministrationBody.electionRegistrationUrl),
                ElectionAdministrationInfo(
                    "Absentee Voting", election.electionAdministrationBody.absenteeVotingInfoUrl),
                ElectionAdministrationInfo("Ballot Information", election.electionAdministrationBody.ballotInfoUrl),
                ButtonGroup(
                  "See other elections",
                  () => {presenter.onSeeAllElectionsClick()},
                )
              ],
            );
          }

          return Stack(
            children: <Widget>[
              presenter.isLoading ? Center(child: CircularProgressIndicator()) : SizedBox.shrink(),
              mainWidget,
            ],
          );
        }),
      ),
    );
  }

  @override
  void onRefreshData() {}
}

class ElectionAdministrationInfo extends StatelessWidget {
  final ElectionInfoUrl deeplink;
  final String title;

  const ElectionAdministrationInfo(
    this.title,
    this.deeplink, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (deeplink != null) {
      return ListButtonCell(title, deeplink.label, "Visit", () {
        launch(deeplink.uri);
      });
    }

    return SizedBox.shrink();
  }
}

class Contests extends StatelessWidget {
  final List<Contest> contests;

  const Contests(
    this.contests, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (contests == null) {
      return SizedBox.shrink();
    }

    return ListView(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      children: <Widget>[
        ...contests.map(
          (value) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: ListCell(value.title, value.subtitle),
                ),
                ...value.candidates.map((rep) {
                  return ListCellSmall(
                    "${rep.name} (${rep.party})",
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: CircularImage(Constants.placeholderImageUrl, Constants.colorForParty(rep.party), 1, 24),
                    ),
                    () async {
                      var url = Uri.encodeFull("https://google.com/search?q=${rep.name}&btnI");
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                  );
                })
              ],
            );
          },
        ),
      ],
    );
  }
}

class ElectionLocation extends StatelessWidget {
  final List<PollingLocation> locations;
  final String title;
  final String subtitle;

  const ElectionLocation(
    this.locations,
    this.title,
    this.subtitle, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (locations == null || locations.isEmpty) {
      return SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          subtitle != null
              ? Headline(title, subtitle)
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 0.0),
                  child: Text(
                    title,
                    style: Styles.headline5(Theme.of(context)),
                  ),
                ),
          ...locations.map((location) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0),
                  child: CachedNetworkImage(
                    imageUrl: location.imageUrl,
                    errorWidget: (context, url, error) {
                      return Container();
                    },
                    imageBuilder: (context, imageProvider) {
                      return ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        child: Image(
                          image: imageProvider,
                        ),
                      );
                    },
                  ),
                ),
                ListButtonCell(
                  location.locationName,
                  location.address,
                  "Directions",
                  () {
                    var address = Uri.encodeFull(location.address);
                    launch("https://www.google.com/maps/search/?api=1&query=${address}");
                  },
                )
              ],
            );
          })
        ],
      ),
    );
  }
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
