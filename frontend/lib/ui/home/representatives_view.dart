import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:politic/data/models/feed.dart';
import 'package:politic/data/models/voter_roll.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

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
            body: ListView(
              children: <Widget>[
                SenatorsWidget(presenter),
                RepresentativeWidget(presenter),
                LocalRepresentativeWidget(presenter),
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
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                  border: Border.all(width: 2, color: Theme.of(context).colorScheme.primary, style: BorderStyle.solid),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                    border: Border.all(width: 2, color: Colors.white, style: BorderStyle.solid),
                  ),
                  child: Container(
                    width: 64.0,
                    height: 64.0,
                    decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        image: new DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(senator.image),
                        )),
                  ),
                ),
              ),
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
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(100)),
                border: Border.all(width: 2, color: Theme.of(context).colorScheme.primary, style: BorderStyle.solid),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                  border: Border.all(width: 2, color: Colors.white, style: BorderStyle.solid),
                ),
                child: Container(
                  width: 64.0,
                  height: 64.0,
                  decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      image: new DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(rep.image),
                      )),
                ),
              ),
            ),
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
                top: 32.0,
                bottom: 16.0,
                left: 32.0,
                right: 32.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    value.officeTitle,
                    style: Styles.headline6(Theme.of(context)),
                  ),
                  ...value.officials.map(
                    (rep) {
                      return ListCellSmall(rep.displayName);
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

  onSaveAndContinue(VoterInformation voterInformation) async {
    updateLoading(true);
    var userUid = await repo.signIn().catchError((error) => {view.showErrorMessage(error, null)});
    if (userUid == null) {
      return;
    }

    await repo.saveVoterInformation(voterInformation).catchError((error) => {view.showErrorMessage(error, null)});
    updateLoading(false);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LocationServicesPage(),
      ),
    );
  }

  onContinue(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LocationServicesPage(),
      ),
    );
  }
}
