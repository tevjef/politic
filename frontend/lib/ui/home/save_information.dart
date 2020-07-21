import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:politic/data/models/voter_roll.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

import '../../core/lib.dart';
import '../../data/lib.dart';
import '../util/lib.dart';
import 'location_services.dart';

class SaveInformationPage extends StatefulWidget {
  final VoterInformation voterInformation;

  const SaveInformationPage({Key key, this.voterInformation}) : super(key: key);

  @override
  SaveInformationState createState() => new SaveInformationState(voterInformation);
}

class SaveInformationState extends State<SaveInformationPage> with LDEViewMixin implements SaveInformationView {
  final VoterInformation voterInformation;

  SaveInformationState(this.voterInformation);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future<bool>.value(true);
      },
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => SaveInformationPresenter(this)),
        ],
        child: Consumer<SaveInformationPresenter>(builder: (context, presenter, child) {
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
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 0.0),
                    child: ListView(
                      children: <Widget>[
                        Image.asset('res/images/notifications.png'),
                        Text(
                          "Get notified if you’re dropped from voter registration.",
                          textAlign: TextAlign.center,
                          style: Styles.headline5(Theme.of(context)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Text(
                            "Save your name and date of birth to get notified if you’re dropped from the voter registration record.",
                            textAlign: TextAlign.center,
                            style: Styles.body1(Theme.of(context)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ButtonGroup(
                    "Save and Continue",
                    () => {presenter.onSaveAndContinue(voterInformation)},
                    secondaryCtaText: "I don't want notification",
                    secodaryListener: () => {presenter.onContinue(context)},
                    isLoading: presenter.isLoading,
                  ),
                ],
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

abstract class SaveInformationView implements BaseView, ListOps {
  // void navigateToSomewhere();
}

class SaveInformationPresenter extends BasePresenter<SaveInformationView> with ChangeNotifier, DiagnosticableTreeMixin {
  Repo repo;

  bool isLoading = false;

  SaveInformationPresenter(SaveInformationView view) : super(view) {
    final injector = Injector.getInjector();
    repo = injector.get();
  }

  void updateLoading(bool isLoading) {
    this.isLoading = isLoading;
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
