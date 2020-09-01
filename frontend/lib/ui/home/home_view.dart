import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:politic/data/models/feed.dart';
import 'package:politic/data/models/user.dart';
import 'package:politic/ui/home/feed_state_view.dart';
import 'package:politic/ui/home/representatives_view.dart';
import 'package:politic/ui/home/settings_view.dart';
import 'package:politic/ui/home/state_selection_view.dart';
import 'package:politic/ui/util/constants.dart';
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
          ChangeNotifierProvider(create: (_) => PoliticHomePresenter(this, context)),
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

          var title = "";

          if (presenter.districtLocation != null) {
            var cd = presenter.districtLocation.congressionalDistrict;
            var district = cd.isNotEmpty ? getOrdinal(int.parse(cd)) : "";
            title = "${Constants.states[presenter.districtLocation.state]}'s ${cd}${district} congressional district".toUpperCase();
          }

          return Scaffold(
            key: scaffoldKey,
            backgroundColor: Theme.of(context).colorScheme.surface,
            appBar: AppBar(
              brightness: Brightness.light,
              backgroundColor: Theme.of(context).colorScheme.surface,
              // actions: <Widget>[menuButton],
              title: Text(
                title,
                style: Styles.overline(Theme.of(context)).copyWith(color: Theme.of(context).colorScheme.onSurface),
              ),
              elevation: 0,
            ),
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: Theme.of(context).colorScheme.surface,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: ImageIcon(AssetImage("res/images/house.png")),
                  title: Text('Feed'),
                ),
                BottomNavigationBarItem(
                  icon: ImageIcon(AssetImage("res/images/people.png")),
                  title: Text('Representatives'),
                ),
                BottomNavigationBarItem(
                  icon: ImageIcon(AssetImage("res/images/elections.png")),
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
            body: Stack(
              children: <Widget>[
                IndexedStack(
                  index: _selectedIndex,
                  children: <Widget>[
                    presenter.districtLocation != null ? FeedStatePage(presenter.districtLocation) : Container(),
                    RepresentativesPage(),
                    LocalElectionPage(),
                    SettingsPage()
                  ],
                ),
                presenter.isLoading ? Center(child: CircularProgressIndicator()) : SizedBox.shrink(),
              ],
            ),
          );
        }),
      ),
    );
  }

  @override
  void onRefreshData() {}

  String getOrdinal(int d) {
    if (d > 3 && d < 21) return "th";
    switch (d % 10) {
      case 1:
        return "st";
      case 2:
        return "nd";
      case 3:
        return "rd";
      default:
        return "th";
    }
  }
}

abstract class PoliticHomeView implements BaseView, ListOps {
  // void navigateToSomewhere();
}

class PoliticHomePresenter extends BasePresenter<PoliticHomeView> with ChangeNotifier, DiagnosticableTreeMixin {
  Repo repo;
  final BuildContext context;
  DistrictLocation districtLocation;
  bool isLoading = false;

  PoliticHomePresenter(PoliticHomeView view, this.context) : super(view) {
    final injector = Injector.getInjector();
    repo = injector.get();
    loadData();
  }

  void updateLoading(bool isLoading) {
    this.isLoading = isLoading;
    notifyListeners();
  }

  loadData() async {
    updateLoading(true);
    districtLocation = await repo.getLocation().catchError((error) => {view.showErrorMessage(error, null)});
    updateLoading(false);

    if (districtLocation.state == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LocationServicesPage(),
        ),
      );
    }
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
