import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:package_info/package_info.dart';
import 'package:politic/data/models/user.dart';
import 'package:politic/ui/home/home_view.dart';
import 'package:politic/ui/home/state_selection_view.dart';
import 'package:politic/ui/home/voter_registration_flow.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/lib.dart';
import '../../data/lib.dart';
import '../util/lib.dart';
import 'location_services.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key key}) : super(key: key);

  @override
  SettingsState createState() => new SettingsState();
}

class SettingsState extends State<SettingsPage> with LDEViewMixin implements SettingsView {
  SettingsState() {}

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future<bool>.value(true);
      },
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => SettingsPresenter(this, context)),
        ],
        child: Consumer<SettingsPresenter>(builder: (context, presenter, child) {
          Widget resetAppData;
          Widget signIn;
          Widget email;
          Widget location;
          List<Widget> settingsWidgets = [];
          Widget registration;

          if (true) {
            resetAppData = ListCellSubtitle2(
              "Logout",
              () {
                presenter.onLogout();
              },
            );
          }

          if (true) {
            settingsWidgets.add(ListCellSubtitle2(
              "About",
              () {
                presenter.onAboutClick();
              },
            ));
          }

          if (true) {
            settingsWidgets.add(ListCellSubtitle2(
              "Contact Us",
              () {
                presenter.onContactUsClick();
              },
            ));
          }

          if (presenter.isAnonymous) {
            // signIn = ListCellSubtitle2(
            //   "Sign in",
            //   () {
            //     presenter.onSignIn();
            //   },
            // );
          }

          if (presenter.email != null) {
            signIn = ListCell(
              "Email",
              presenter.email,
            );
          }

          if (true) {
            location = ListCellSubtitle2(
              "Change my location",
              () {
                presenter.onChangeLocation();
              },
            );
          }

          if (kDebugMode) {
            settingsWidgets.add(ListCellSubtitle2(
              "Georgia",
              () {
                presenter.onChangeLocationGeorgia();
              },
            ));
          }

          if (kDebugMode) {
            settingsWidgets.add(ListCellSubtitle2(
              "Oaklahoma",
              () {
                presenter.onChangeLocationOaklahoma();
              },
            ));
          }

          if (kDebugMode) {
            settingsWidgets.add(ListCellSubtitle2(
              "Wyoming",
              () {
                presenter.onChangeLocationWyoming();
              },
            ));
          }

          if (kDebugMode) {
            settingsWidgets.add(ListCellSubtitle2(
              "New York",
              () {
                presenter.onChangeLocationNewYork();
              },
            ));
          }

          if (true) {
            registration = ListCellSubtitle2(
              "Update voter registration",
              () {
                presenter.onChangeVoterRegistration();
              },
            );
          }

          var widgets = [email, signIn, location, registration, ...settingsWidgets, resetAppData]
              .where((element) => element != null);

          return Scaffold(
            key: scaffoldKey,
            backgroundColor: Theme.of(context).colorScheme.surface,
            body: ListView(
              children: <Widget>[...widgets],
            ),
          );
        }),
      ),
    );
  }

  @override
  void onRefreshData() {}
}

abstract class SettingsView implements BaseView, ListOps {
  // void navigateToSomewhere();
}

class SettingsPresenter extends BasePresenter<SettingsView> with ChangeNotifier, DiagnosticableTreeMixin {
  Repo repo;
  bool isLoading = false;
  BuildContext context;

  String email;
  bool isAnonymous = true;

  SettingsPresenter(SettingsView view, BuildContext context) : super(view) {
    final injector = Injector.getInjector();
    repo = injector.get();
    this.context = context;
    loadData();
  }

  void loadData() async {
    email = await repo.userEmail();
    isAnonymous = await repo.isAnonymous();
    notifyListeners();
  }

  void updateLoading(bool isLoading) {
    this.isLoading = isLoading;
    notifyListeners();
  }

  onLogout() async {
    await repo.logout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(CreateVoterInformationFlow()),
      ),
    );
  }

  void onSignIn() async {}

  void onChangeLocation() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LocationServicesPage(),
      ),
    );
  }

  void onChangeLocationGeorgia() async {
    await repo.saveLocation(LocationLatLng(lat: 33.759894, lng: -84.406412));

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => PoliticHomePage(),
      ),
    );
  }

  void onChangeLocationWyoming() async {
    await repo.saveLocation(LocationLatLng(lat: 42.847274, lng: -106.316668));

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => PoliticHomePage(),
      ),
    );
  }

  void onChangeLocationOaklahoma() async {
    await repo.saveLocation(LocationLatLng(lat: 35.418916, lng: -97.526745));

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => PoliticHomePage(),
      ),
    );
  }

  void onChangeLocationNewYork() async {
    await repo.saveLocation(LocationLatLng(lat: 40.717732, lng: -73.954549));

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => PoliticHomePage(),
      ),
    );
  }

  void onChangeVoterRegistration() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(UpdateVoterInformationFlow()),
      ),
    );
  }

  void onAboutClick() async {
    var versionName = (await PackageInfo.fromPlatform()).version;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text("Politic", style: Styles.headline5(Theme.of(context))),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: Text("Made with <3 by Tevin Jeffrey", style: Styles.body2(Theme.of(context))),
                    ),
                    Text(versionName, style: Styles.body2(Theme.of(context)))
                  ],
                ),
              ),
            ),
          );
        });
  }

  void onContactUsClick() {
    var uri = Uri(
        scheme: 'mailto',
        path: 'tev.jeffrey@gmail.com',
        queryParameters: {'subject': 'Politic Feedback'});
    launch(uri.toString());
  }
}
