import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:geocoder/geocoder.dart';
import 'package:location/location.dart';
import 'package:politic/data/models/feed.dart';
import 'package:politic/data/models/user.dart';
import 'package:politic/ui/home/feed_state_view.dart';
import 'package:politic/ui/home/state_selection_view.dart';
import 'package:politic/ui/home/voter_registration_flow.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
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
          Widget registration;

          if (true) {
            resetAppData = ListCellSubtitle2(
              presenter.email == null ? "Reset app data" : "Logout",
              () {
                presenter.onLogout();
              },
            );
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

          if (true) {
            registration = ListCellSubtitle2(
              "Update voter registration",
              () {
                presenter.onChangeVoterRegistration();
              },
            );
          }

          var widgets = [email, signIn, location, registration, resetAppData].where((element) => element != null);

          return Scaffold(
            key: scaffoldKey,
            backgroundColor: Theme.of(context).colorScheme.surface,
            appBar: AppBar(
              brightness: Brightness.light,
              backgroundColor: Theme.of(context).colorScheme.surface,
              elevation: 0,
            ),
            body: RefreshIndicator(
              key: refreshIndicatorKey,
              onRefresh: handleRefresh,
              child: ListView(
                children: <Widget>[...widgets],
              ),
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

  void onSignIn() async {
    await repo.signinWithGoogle();
  }

  void onChangeLocation() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LocationServicesPage(),
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
}
