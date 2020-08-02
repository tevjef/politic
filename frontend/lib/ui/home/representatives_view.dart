import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:politic/data/models/feed.dart';
import 'package:politic/data/models/voter_roll.dart';
import 'package:politic/ui/util/constants.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/lib.dart';
import '../../data/lib.dart';
import '../util/lib.dart';
import 'location_services.dart';

class RepresentativesPage extends StatefulWidget {
  const RepresentativesPage({Key key}) : super(key: key);

  @override
  RepresentativesState createState() => new RepresentativesState();
}

class RepresentativesState extends State<RepresentativesPage> with LDEViewMixin implements RepresentativesView {
  RepresentativesState();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future<bool>.value(true);
      },
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => RepresentativesPresenter(this)),
        ],
        child: Consumer<RepresentativesPresenter>(builder: (context, presenter, child) {
          return Scaffold(
            key: scaffoldKey,
            backgroundColor: Theme.of(context).colorScheme.surface,
            body: Stack(
              children: <Widget>[
                presenter.isLoading ? Center(child: CircularProgressIndicator()) : SizedBox.shrink(),
                ListView(
                  children: <Widget>[
                    SenatorsWidget(presenter),
                    RepresentativeWidget(presenter),
                    LocalRepresentativeWidget(presenter),
                  ],
                ),
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

class SenatorsWidget extends StatelessWidget {
  final RepresentativesPresenter presenter;

  const SenatorsWidget(
    this.presenter, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<RepresentativesPresenter>(builder: (context, presenter, child) {
      if (presenter.representatives == null) {
        return Container();
      }

      Iterable<Widget> senators = presenter.representatives.senators.map((senator) {
        return Padding(
          padding: const EdgeInsets.only(
            top: 16.0,
            bottom: 16.0,
            left: 32.0,
            right: 32.0,
          ),
          child: Row(
            children: <Widget>[
              CircularImage(
                  senator.image ?? Constants.placeholderImageUrl, Constants.colorForParty(senator.party), 2, 64),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          senator.displayName,
                          style: Styles.headline6(Theme.of(context)),
                        ),
                        Text(
                          senator.description,
                          style: Styles.body2(Theme.of(context)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      });

      return Column(
        children: <Widget>[
          Headline("Senators",
              "Each state elects two senators to the United States Senate for staggered 6-year terms. Senators represent the entire state. "),
          ...senators
        ],
      );
    });
  }
}

class RepresentativeWidget extends StatelessWidget {
  final RepresentativesPresenter presenter;

  const RepresentativeWidget(
    this.presenter, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<RepresentativesPresenter>(builder: (context, presenter, child) {
      if (presenter.representatives == null) {
        return Container();
      }

      if (presenter.representatives.representative.localRepresentative == null) {
        return Column(
          children: <Widget>[
            Headline("Representatives",
                "The United States is divided into 435 congressional districts, each with a population of about 710,000 individuals. Each district elects a representative to the U.S. House of Representatives for a two-year term."),
            ListButtonCell("We could not find your representative", "Please manually update your address", "Update",
                () {
              presenter.onUpdateAddressClick();
            }),
          ],
        );
      }

      var rep = presenter.representatives.representative.localRepresentative;
      var widget = Padding(
        padding: const EdgeInsets.only(
          top: 16.0,
          bottom: 16.0,
          left: 32.0,
          right: 32.0,
        ),
        child: Row(
          children: <Widget>[
            CircularImage(rep.image ?? Constants.placeholderImageUrl, Constants.colorForParty(rep.party), 2, 64),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        rep.displayName,
                        style: Styles.headline6(Theme.of(context)),
                      ),
                      Text(
                        rep.description,
                        style: Styles.body2(Theme.of(context)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );

      return Column(
        children: <Widget>[
          Headline("Representatives",
              "The United States is divided into 435 congressional districts, each with a population of about 710,000 individuals. Each district elects a representative to the U.S. House of Representatives for a two-year term."),
          widget
        ],
      );
    });
  }
}

class LocalRepresentativeWidget extends StatelessWidget {
  final RepresentativesPresenter presenter;

  const LocalRepresentativeWidget(
    this.presenter, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<RepresentativesPresenter>(
      builder: (context, presenter, child) {
        if (presenter.representatives == null) {
          return Container();
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemCount: presenter.representatives.local.length ?? 0,
          itemBuilder: (BuildContext context, int index) {
            var value = presenter.representatives.local[index];
            return Padding(
              padding: const EdgeInsets.only(
                top: 20.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8.0),
                    child: Text(
                      value.officeTitle,
                      style: Styles.headline6(Theme.of(context)),
                    ),
                  ),
                  ...value.officials.map(
                    (rep) {
                      return ListCellSmall(
                          "${rep.displayName} (${rep.party})",
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: CircularImage(
                                rep.image ?? Constants.placeholderImageUrl, Constants.colorForParty(rep.party), 1, 24),
                          ), () async {
                        var url = Uri.encodeFull("https://google.com/search?q=${rep.displayName}");
                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      });
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

abstract class RepresentativesView implements BaseView, ListOps {
  // void navigateToSomewhere();
}

class RepresentativesPresenter extends BasePresenter<RepresentativesView> with ChangeNotifier, DiagnosticableTreeMixin {
  Repo repo;

  bool isLoading = false;

  RepresentativesResponse representatives;

  RepresentativesPresenter(RepresentativesView view) : super(view) {
    final injector = Injector.getInjector();
    repo = injector.get();
    loadData();
  }

  void updateLoading(bool isLoading) {
    this.isLoading = isLoading;
    notifyListeners();
  }

  void loadData() async {
    updateLoading(true);
    representatives = await repo.getRepresentatives().catchError((error) => {view.showErrorMessage(error, null)});
    updateLoading(false);
    notifyListeners();
  }

  void onUpdateAddressClick() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LocationServicesPage(),
      ),
    );
  }
}
