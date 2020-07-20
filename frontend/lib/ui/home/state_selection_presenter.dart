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

  List<String> _countyOptions = List();
  List<String> get countyOptions => _countyOptions;

  USState selectedState;
  String selectedCountyOption;

  String _firstName = null;
  String _lastName = null;
  int _zipcode = null;
  int _month = null;
  int _day = null;
  int _year = null;
  String _county = null;
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
    _firstName = null;
    _lastName = null;
    _zipcode = null;
    _month = null;
    _day = null;
    _year = null;
    _county = null;
    selectedCountyOption = null;
    countyOptions.clear();

    if (selectedState.fields.isNotEmpty) {
      var countyField =
          selectedState.fields.firstWhere((element) => element.inputType == "selection" && element.key == "county", orElse: () => null);
      if (countyField != null) {
        countyOptions.addAll(countyField.options);
        selectedCountyOption = countyOptions[0];
      }
    }

    notifyListeners();
  }

  void updateFirstName(String text) {
    _firstName = text;
  }

  void updateLastName(String text) {
    _lastName = text;
  }

  void updateDay(int day) {
    _day = day;
  }

  void updateMonth(int month) {
    _month = month;
  }

  void updateYear(int year) {
    _year = year;
  }

  void updateZipCode(int zipcode) {
    _zipcode = zipcode;
  }

  void updateCounty(String county) {
    _county = county;
    selectedCountyOption = county;
    notifyListeners();
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
          county: _county,
          year: _year),
    );
    var response = await repo.checkRegistration(checkRegistrationRequest).catchError(
          (error) => {updateLoading(false), view.showErrorMessage(error, null)},
        );

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
