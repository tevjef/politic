import 'dart:ui';

import 'package:logging/logging.dart';
import 'package:politic/data/models/voter_roll.dart';
import 'package:politic/ui/home/voter_registration_flow.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

import '../../core/lib.dart';
import '../../data/lib.dart';
import '../util/lib.dart';
import 'state_selection_presenter.dart';

class HomePage extends StatefulWidget {
  final VoterInformationFlow flow;

  HomePage(this.flow, {Key key}) : super(key: key);

  @override
  HomeListState createState() => new HomeListState(flow);
}

class HomeListState extends State<HomePage> with LDEViewMixin implements HomeView {
  final VoterInformationFlow flow;

  AdInitializer adInitializer;

  HomeListState(this.flow) {
    final injector = Injector.getInjector();
    adInitializer = injector.get();
    adInitializer.showBanner(false);
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return WillPopScope(
        onWillPop: () {
          return Future<bool>.value(true);
        },
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => HomePresenter(this, flow)),
          ],
          child: Consumer<HomePresenter>(builder: (context, presenter, child) {
            Widget buttonContainer = Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: ButtonGroup(
                "Check Voter Registration",
                () => {
                  if (_formKey.currentState.validate()) {presenter.onSubmit(context)}
                },
                secondaryCtaText: "I’m already registered",
                secodaryListener: () => {presenter.onSubmit(context)},
                isLoading: presenter.isLoading,
              ),
            );

            Widget buttonContainerList = Container();
            Widget buttonContainerStack = Container();

            if (presenter.selectedState != null && presenter.selectedState.fields.length > 0) {
              buttonContainerStack = Container();
              buttonContainerList = buttonContainer;
            } else {
              buttonContainerList = Container();
              buttonContainerStack = buttonContainer;
            }

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
                      ListView(
                        children: <Widget>[
                          Headline("Are you registered to vote?",
                              "Check if you’re registered to vote in your electoral district."),
                          StateSelectDropDown(),
                          RegistrationForm(formKey: _formKey),
                          buttonContainerList
                        ],
                      ),
                      buttonContainerStack
                    ],
                  ),
                ));
          }),
        ));
  }

  @override
  void onRefreshData() {}
}

class RegistrationForm extends StatelessWidget {
  final FocusNode firstNameNode = FocusNode();
  final FocusNode lastNameNode = FocusNode();
  final FocusNode monthNode = FocusNode();
  final FocusNode yearNode = FocusNode();
  GlobalKey<FormState> formKey;

  RegistrationForm({Key key, this.formKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Consumer<HomePresenter>(builder: (context, presenter, child) {
        List<Widget> inputCells = List();

        if (presenter.selectedState == null) return Container();
        if (presenter.selectedState.fields.isEmpty) return Container();
        var stateFields = presenter.selectedState.fields;
        if (stateFields.firstWhere((element) => element.key == "firstName", orElse: () => null) != null) {
          var firstName = Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 32),
              child: PoliticTextInputField(
                  hint: "First Name",
                  focusNode: firstNameNode,
                  onSubmit: (e) => {_fieldFocusChange(context, firstNameNode, lastNameNode)},
                  onValueChanged: (value) => {presenter.updateFirstName(value)}));

          inputCells.add(firstName);
        }

        if (stateFields.firstWhere((element) => element.key == "lastName", orElse: () => null) != null) {
          var lastName = Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 32),
              child: PoliticTextInputField(
                  hint: "Last Name",
                  focusNode: lastNameNode,
                  onSubmit: (e) => {_fieldFocusChange(context, lastNameNode, monthNode)},
                  onValueChanged: (value) => {presenter.updateLastName(value)}));

          inputCells.add(lastName);
        }

        if (stateFields.firstWhere((element) => element.key == "county", orElse: () => null) != null) {
          var header = Padding(
            padding: const EdgeInsets.only(top: 24, bottom: 12, left: 32, right: 32),
            child: Text(
              "County",
              style: Styles.headline6(Theme.of(context)),
            ),
          );
          inputCells.add(header);
          inputCells.add(CountySelectDropDown());
        }

        if (stateFields.firstWhere((element) => element.key == "zipcode", orElse: () => null) != null) {
          var zipCode = Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: TextFormField(
                inputFormatters: [WhitelistingTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(5)],
                keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                onFieldSubmitted: (e) => {_fieldFocusChange(context, monthNode, yearNode)},
                focusNode: monthNode,
                textInputAction: TextInputAction.next,
                onChanged: (e) => {presenter.updateZipCode(int.parse(e))},
                decoration: InputDecoration(
                  labelText: "Zip Code",
                  border: new OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      borderSide: new BorderSide(color: Theme.of(context).primaryColor)),
                ),
              ));
          inputCells.add(zipCode);
        }

        var hasDobDMY = stateFields.firstWhere((element) => element.inputType == "dobDMY", orElse: () => null) != null;
        var hasDobMY = stateFields.firstWhere((element) => element.inputType == "dobMY", orElse: () => null) != null;

        if (hasDobMY || hasDobDMY) {
          var header = Padding(
            padding: const EdgeInsets.only(top: 24, bottom: 12, left: 32, right: 32),
            child: Text(
              "Date of Birth",
              style: Styles.headline6(Theme.of(context)),
            ),
          );

          List<Widget> dobWidgets = List();

          if (hasDobDMY) {
            var dayWidget = Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: TextFormField(
                  inputFormatters: [WhitelistingTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(2)],
                  keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                  onFieldSubmitted: (e) => {_fieldFocusChange(context, monthNode, yearNode)},
                  focusNode: monthNode,
                  textInputAction: TextInputAction.next,
                  onChanged: (e) => {presenter.updateDay(int.parse(e))},
                  validator: (value) {
                    if (value.isEmpty) {
                      return '';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: "DD",
                    border: new OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        borderSide: new BorderSide(color: Theme.of(context).primaryColor)),
                  ),
                ),
              ),
            );
            dobWidgets.add(dayWidget);
          }
          var monthWidget = Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: TextFormField(
                inputFormatters: [WhitelistingTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(2)],
                keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                onFieldSubmitted: (e) => {_fieldFocusChange(context, monthNode, yearNode)},
                focusNode: monthNode,
                textInputAction: TextInputAction.next,
                onChanged: (e) => {presenter.updateMonth(int.parse(e))},
                validator: (value) {
                  if (value.isEmpty) {
                    return 'e.g 09';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: "MM",
                  border: new OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      borderSide: new BorderSide(color: Theme.of(context).primaryColor)),
                ),
              ),
            ),
          );
          var yearWidget = Expanded(
              flex: 1,
              child: TextFormField(
                inputFormatters: [WhitelistingTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(4)],
                onFieldSubmitted: (e) => {},
                focusNode: yearNode,
                keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                textInputAction: TextInputAction.done,
                onChanged: (e) => {presenter.updateYear(int.parse(e))},
                validator: (value) {
                  if (value.isEmpty) {
                    return 'e.g 1990';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: "YYYY",
                  border: new OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      borderSide: new BorderSide(color: Theme.of(context).primaryColor)),
                ),
              ));
          dobWidgets.add(monthWidget);
          dobWidgets.add(yearWidget);

          var dobCells = Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 32),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: dobWidgets,
            ),
          );

          inputCells.add(header);
          inputCells.add(dobCells);
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: inputCells,
        );
      }),
    );
  }

  _fieldFocusChange(BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
}

class PoliticTextInputField extends StatelessWidget {
  final String hint;
  final FocusNode focusNode;
  final ValueChanged onSubmit;
  final ValueChanged onValueChanged;

  PoliticTextInputField({Key key, this.hint, this.focusNode, this.onSubmit, this.onValueChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onFieldSubmitted: onSubmit,
      focusNode: focusNode,
      autocorrect: false,
      textInputAction: TextInputAction.next,
      onChanged: onValueChanged,
      validator: (value) {
        if (value.isEmpty) {
          return "Please enter your ${hint.toLowerCase()}.";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: hint,
        border: new OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            borderSide: new BorderSide(color: Theme.of(context).primaryColor)),
      ),
    );
  }
}

class StateSelectDropDown extends StatelessWidget {
  const StateSelectDropDown({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<HomePresenter>(builder: (context, presenter, child) {
      return Container(
        margin: EdgeInsets.symmetric(vertical: 12, horizontal: 32),
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            border: Border.all(color: Theme.of(context).disabledColor, width: 1.0),
            borderRadius: BorderRadius.all(Radius.circular(8))),
        child: new SizedBox(
          width: double.infinity,
          child: DropdownButtonHideUnderline(
            child: DropdownButton<USState>(
                value: presenter.selectedState,
                onChanged: (USState newValue) {
                  presenter.updateSelectedState(newValue);
                },
                isDense: true,
                items: presenter.states.map((USState value) {
                  return DropdownMenuItem<USState>(
                      value: value,
                      child: Text(
                        value.name,
                        overflow: TextOverflow.ellipsis,
                      ));
                }).toList()),
          ),
        ),
      );
    });
  }
}

class CountySelectDropDown extends StatelessWidget {
  final List<String> options;

  const CountySelectDropDown({Key key, this.options}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<HomePresenter>(builder: (context, presenter, child) {
      return Container(
        margin: EdgeInsets.symmetric(vertical: 12, horizontal: 32),
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            border: Border.all(color: Theme.of(context).disabledColor, width: 1.0),
            borderRadius: BorderRadius.all(Radius.circular(8))),
        child: new SizedBox(
          width: double.infinity,
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
                value: presenter.selectedCountyOption,
                onChanged: (String newValue) {
                  presenter.updateCounty(newValue);
                },
                isDense: true,
                items: presenter.countyOptions.map((String value) {
                  return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        overflow: TextOverflow.ellipsis,
                      ));
                }).toList()),
          ),
        ),
      );
    });
  }
}
