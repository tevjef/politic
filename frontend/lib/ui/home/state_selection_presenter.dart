import 'dart:convert';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:politic/data/models/voter_roll.dart';
import 'package:politic/ui/home/single_enrolled_view.dart';

import '../../core/lib.dart';
import '../../data/lib.dart';
import '../util/lib.dart';
import 'not_enrolled_view.dart';
import 'not_found_view.dart';

abstract class HomeView implements BaseView, ListOps {
  // void navigateToSomewhere();
}

class HomePresenter extends BasePresenter<HomeView> with ChangeNotifier, DiagnosticableTreeMixin {
  Repo repo;
  AnalyticsLogger analyticsLogger;
  AdInitializer adInitializer;

  List<USState> _states = List();
  List<USState> get states => _states;
  USState selectedState;

  String _firstName = "";
  String _lastName = "";
  int _zipCode = 0;
  int _month = 0;
  int _year = 0;
  bool isLoading = false;

  HomePresenter(HomeView view) : super(view) {
    final injector = Injector.getInjector();
    analyticsLogger = injector.get();
    repo = injector.get();
    adInitializer = injector.get();
    loadData();
  }

  void updateStates(List<USState> states) {
    selectedState = states[0];
    this.states.addAll(states);
    notifyListeners();
  }

  void updateSelectedState(USState state) {
    selectedState = state;
    notifyListeners();
  }

  void updateFirstName(String text) {
    _firstName = text;
  }

  void updateLastName(String text) {
    _lastName = text;
  }

  void updateMonth(int month) {
    _month = month;
  }

  void updateYear(int year) {
    _year = year;
  }

  void updateZipCode(int zipcode) {
    _zipCode = zipcode;
  }

  void updateLoading(bool isLoading) {
    this.isLoading = isLoading;
    notifyListeners();
  }

  void onSubmit(BuildContext context) async {
    updateLoading(true);
    var checkRegistrationRequest = CheckRegistrationRequest(
      voterInformation: VoterInformation(
          state: selectedState.abbreviation,
          firstName: _firstName,
          lastName: _lastName,
          month: _month.toString(),
          year: _year),
    );
    var response =
        await repo.checkRegistration(checkRegistrationRequest).catchError((error) => {view.showErrorMessage(error, null)});

    updateLoading(false);
    pushResultScreen(context, checkRegistrationRequest.voterInformation, response);
  }

  void onInitState() {
    super.onInitState();
    loadData();
  }

  void loadData() async {
    updateLoading(true);
    updateStates(await repo.getData());
    updateLoading(false);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('_firstName', _firstName));
    properties.add(StringProperty('_lastName', _lastName));
    properties.add(IntProperty('_month', _month));
    properties.add(IntProperty('_year', _year));
  }

  void pushResultScreen(BuildContext context, VoterInformation voterInformation, VoterStatus voterStatus) {
    StatelessWidget targetScreen;
    switch (voterStatus.type) {
      case 'multipleEnrolled':
        {
          throw UnimplementedError();
        }
        break;
      case 'singleEnrolled':
        {
          targetScreen = SingleEnrolledScreen(voterStatus.value as SingleEnrolled, voterInformation);
        }
        break;
      case 'notEnrolled':
        {
          targetScreen = NotEnrolledScreen(voterStatus.value as NotEnrolled, voterInformation);
        }
        break;
      case 'notFound':
        {
          targetScreen = NotFoundScreen(voterStatus.value as NotFound);
        }
        break;
      default:
        {
          throw UnimplementedError("unknown types");
        }
        break;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => targetScreen,
      ),
    );
  }
}
