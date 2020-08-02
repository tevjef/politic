import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:politic/data/models/feed.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

import '../../core/lib.dart';
import '../../data/lib.dart';
import '../util/lib.dart';

class UpcomingElectionsPage extends StatefulWidget {
  const UpcomingElectionsPage({Key key}) : super(key: key);

  @override
  UpcomingElectionsState createState() => new UpcomingElectionsState();
}

class UpcomingElectionsState extends State<UpcomingElectionsPage> with LDEViewMixin implements UpcomingElectionsView {
  UpcomingElectionsState() {}

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future<bool>.value(true);
      },
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => UpcomingElectionsPresenter(this, context)),
        ],
        child: Consumer<UpcomingElectionsPresenter>(builder: (context, presenter, child) {
          return Scaffold(
            key: scaffoldKey,
            backgroundColor: Theme.of(context).colorScheme.surface,
            appBar: AppBar(
              leading: BackButton(
                color: Theme.of(context).colorScheme.onSurface,
              ),
              brightness: Brightness.light,
              backgroundColor: Theme.of(context).colorScheme.surface,
              elevation: 0,
            ),
            body: Stack(
              children: <Widget>[
                presenter.isLoading ? Center(child: CircularProgressIndicator()) : SizedBox.shrink(),
                SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Headline("Upcomming Elections",
                          "As a reminder, you can only vote in the state where you registered voter."),
                      ListView.builder(
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          itemCount: presenter.elections?.length ?? 0,
                          itemBuilder: (BuildContext context, int index) {
                            var election = presenter.elections[index];
                            return ListCell(election.electionName, election.electionDay);
                          }),
                    ],
                  ),
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

abstract class UpcomingElectionsView implements BaseView, ListOps {
  // void navigateToSomewhere();
}

class UpcomingElectionsPresenter extends BasePresenter<UpcomingElectionsView>
    with ChangeNotifier, DiagnosticableTreeMixin {
  Repo repo;
  bool isLoading = false;
  BuildContext context;
  List<Elections> elections = [];

  UpcomingElectionsPresenter(UpcomingElectionsView view, BuildContext context) : super(view) {
    final injector = Injector.getInjector();
    repo = injector.get();
    this.context = context;
    loadData();
  }

  void loadData() async {
    updateLoading(true);
    elections = (await repo.getElections()).elections;
    updateLoading(false);
    notifyListeners();
  }

  void updateLoading(bool isLoading) {
    this.isLoading = isLoading;
    notifyListeners();
  }
}
