import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:politic/data/models/feed.dart';
import 'package:politic/ui/home/feed_state_view.dart';
import 'package:politic/ui/home/representatives_view.dart';
import 'package:politic/ui/home/settings_view.dart';
import 'package:politic/ui/home/state_selection_view.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

import '../../core/lib.dart';
import '../../data/lib.dart';
import '../util/lib.dart';
import 'local_election_view.dart';
import 'location_services.dart';
import 'save_information.dart';

class PoliticHomePage extends StatefulWidget {
  const PoliticHomePage({Key key}) : super(key: key);

  @override
  PoliticHomeState createState() => new PoliticHomeState();
}

class PoliticHomeState extends State<PoliticHomePage> with LDEViewMixin implements PoliticHomeView {
  PoliticHomeState() {}

  int _selectedIndex = 0;
  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future<bool>.value(true);
      },
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => PoliticHomePresenter(this)),
        ],
        child: Consumer<PoliticHomePresenter>(builder: (context, presenter, child) {
          final menuButton = new PopupMenuButton<int>(
            onSelected: (int i) {},
            itemBuilder: (BuildContext ctx) {},
            child: Padding(
              padding: const EdgeInsets.only(right: 32.0),
              child: new Icon(Icons.search, color: Theme.of(context).colorScheme.onSurface),
            ),
          );

          return Scaffold(
            key: scaffoldKey,
            backgroundColor: Theme.of(context).colorScheme.surface,
            appBar: AppBar(
              brightness: Brightness.light,
              backgroundColor: Theme.of(context).colorScheme.surface,
              // actions: <Widget>[menuButton],
              title: Text(
                "New Jersey’s 8th Congressional District".toUpperCase(),
                style: Styles.overline(Theme.of(context)).copyWith(color: Theme.of(context).colorScheme.onSurface),
              ),
              elevation: 0,
            ),
            bottomNavigationBar: BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.account_balance),
                  title: Text('Representatives'),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.format_align_left),
                  title: Text('Feed'),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.note),
                  title: Text('Elections'),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  title: Text('Settings'),
                ),
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: Theme.of(context).colorScheme.primary,
              unselectedItemColor: Theme.of(context).colorScheme.onSurface.withAlpha(150),
              onTap: _onItemTapped,
            ),
            body: IndexedStack(
              index: _selectedIndex,
              children: <Widget>[
              RepresentativesPage(),
              FeedStatePage(),
              LocalElectionPage(),
              SettingsPage()
            ]),
          );
        }),
      ),
    );
  }

  @override
  void onRefreshData() {}
}

abstract class PoliticHomeView implements BaseView, ListOps {
  // void navigateToSomewhere();
}

class PoliticHomePresenter extends BasePresenter<PoliticHomeView> with ChangeNotifier, DiagnosticableTreeMixin {
  Repo repo;

  StateFeedResponse stateFeedResponse;

  PoliticHomePresenter(PoliticHomeView view) : super(view) {
    final injector = Injector.getInjector();
    repo = injector.get();
    loadData();
  }

  loadData() async {
    stateFeedResponse = await repo.getStatesFeed("NJ").catchError((error) => {view.showErrorMessage(error, null)});
    notifyListeners();
  }

  onSaveAndContinue() {
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

  void onFindPollsClick() {}
}
