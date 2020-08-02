import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:politic/data/models/voter_roll.dart';
import 'package:politic/ui/home/voter_registration_flow.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/lib.dart';
import '../../data/lib.dart';
import '../util/lib.dart';
import 'location_services.dart';

class NotFoundPage extends StatefulWidget {
  final NotFound voterStatus;
  final VoterInformationFlow flow;

  const NotFoundPage(this.voterStatus, this.flow, {Key key}) : super(key: key);

  @override
  NotFoundState createState() => new NotFoundState(voterStatus, flow);
}

class NotFoundState extends State<NotFoundPage> with LDEViewMixin implements NotFoundView {
  final NotFound voterStatus;
  final VoterInformationFlow flow;

  NotFoundState(this.voterStatus, this.flow) {}

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future<bool>.value(true);
      },
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => NotFoundPresenter(this, context, flow)),
        ],
        child: Consumer<NotFoundPresenter>(builder: (context, presenter, child) {
          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.surface,
            appBar: AppBar(
              brightness: Brightness.light,
              backgroundColor: Theme.of(context).colorScheme.surface,
              elevation: 0,
            ),
            body: Stack(
              children: <Widget>[
                ListView(
                  children: <Widget>[
                    Headline("We could not verify your registration.",
                        "You can manually check your registration status using the options below. "),
                    Markdown(
                      data: voterStatus.requirements,
                      shrinkWrap: true,
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 32),
                    ),
                    ListButtonCell("Phone", voterStatus.phone.label, "Call", () => {launch(voterStatus.phone.uri)}),
                    ListButtonCell("Website", voterStatus.registrationUrl.label, "Visit",
                        () => {launch(voterStatus.registrationUrl.uri)})
                  ],
                ),
                ButtonGroup(
                  "Continue",
                  () {
                    presenter.onContinue();
                  },
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

abstract class NotFoundView implements BaseView, ListOps {
  // void navigateToSomewhere();
}

class NotFoundPresenter extends BasePresenter<NotFoundView> with ChangeNotifier, DiagnosticableTreeMixin {
  Repo repo;

  bool isLoading = false;

  final BuildContext context;
  final VoterInformationFlow flow;

  NotFoundPresenter(NotFoundView view, this.context, this.flow) : super(view) {
    final injector = Injector.getInjector();
    repo = injector.get();
  }

  void updateLoading(bool isLoading) {
    this.isLoading = isLoading;
    notifyListeners();
  }

  onContinue() async {
    updateLoading(true);
    var userUid = await repo.signIn().catchError((error) => {view.showErrorMessage(error, null)});
    if (userUid == null) {
      return;
    }

    await repo.manualRegistration().catchError((error) => {view.showErrorMessage(error)});
    updateLoading(false);

    flow.onVoterInformationNotFound(context);
  }
}
