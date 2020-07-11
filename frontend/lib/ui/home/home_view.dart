import 'dart:ui';

import 'package:politic/data/models/voter_roll.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

import '../../core/lib.dart';
import '../../data/lib.dart';
import '../util/lib.dart';
import 'home_presenter.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  HomeListState createState() => new HomeListState();
}

class HomeListState extends State<HomePage> with LDEViewMixin implements HomeView {
  AdInitializer adInitializer;

  HomeListState() {
    final injector = Injector.getInjector();
    adInitializer = injector.get();
    adInitializer.showBanner(false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          return Future<bool>.value(true);
        },
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => HomePresenter(this)),
          ],
          child: Scaffold(
              key: scaffoldKey,
              // resizeToAvoidBottomInset: false,
              backgroundColor: Theme.of(context).colorScheme.surface,
              appBar: AppBar(
                backgroundColor: Theme.of(context).colorScheme.surface,
                elevation: 0,
              ),
              body: ListView(
                children: <Widget>[
                  Headline(
                      title: "Are you registered to vote?",
                      message: "Check if you’re registered to vote in your electoral district."),
                  StateSelectDropDown(),
                  RegistrationForm(),
                  Padding(
                    padding: const EdgeInsets.only(top: 64.0),
                    child: Consumer<HomePresenter>(builder: (context, presenter, child) {
                      return ButtonGroup("Check Voter Registration", () => {presenter.onSubmit(context)},
                          secondaryCtaText: "I’m already registered",
                          secodaryListener: () => {presenter.onSubmit(context)});
                    }),
                  )
                ],
              )),
        ));
  }

  @override
  void onRefreshData() {
    // TODO: implement onRefreshData
  }
}

class RegistrationForm extends StatelessWidget {
  final FocusNode firstNameNode = FocusNode();
  final FocusNode lastNameNode = FocusNode();
  final FocusNode monthNode = FocusNode();
  final FocusNode yearNode = FocusNode();

  RegistrationForm({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<HomePresenter>(builder: (context, presenter, child) {
      var lastName = PoliticTextInputField(
          hint: "Last Name",
          focusNode: lastNameNode,
          onSubmit: (e) => {_fieldFocusChange(context, lastNameNode, monthNode)},
          onValueChanged: (value) => {presenter.updateLastName(value)});
      var firstName = PoliticTextInputField(
          hint: "First Name",
          focusNode: firstNameNode,
          onSubmit: (e) => {_fieldFocusChange(context, firstNameNode, lastNameNode)},
          onValueChanged: (value) => {presenter.updateFirstName(value)});

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 32),
            child: firstName,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 32),
            child: lastName,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 24, bottom: 12, left: 32, right: 32),
            child: Text(
              "Date of Birth",
              style: Styles.headline6(Theme.of(context)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 32),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Expanded(
                    child: Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: TextFormField(
                          inputFormatters: [
                            WhitelistingTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(2)
                          ],
                          keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                          onFieldSubmitted: (e) => {_fieldFocusChange(context, monthNode, yearNode)},
                          focusNode: monthNode,
                          textInputAction: TextInputAction.next,
                          onChanged: (e) => {presenter.updateMonth(int.parse(e))},
                          decoration: InputDecoration(
                            labelText: "MM",
                            border: new OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                borderSide: new BorderSide(color: Theme.of(context).primaryColor)),
                          ),
                        ))),
                Expanded(
                    flex: 2,
                    child: TextFormField(
                      inputFormatters: [WhitelistingTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(4)],
                      onFieldSubmitted: (e) => {},
                      focusNode: yearNode,
                      keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                      textInputAction: TextInputAction.done,
                      onChanged: (e) => {presenter.updateYear(int.parse(e))},
                      decoration: InputDecoration(
                        labelText: "YYYY",
                        border: new OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8.0)),
                            borderSide: new BorderSide(color: Theme.of(context).primaryColor)),
                      ),
                    ))
              ],
            ),
          )
        ],
      );
    });
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
      textInputAction: TextInputAction.next,
      onChanged: onValueChanged,
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
    return Consumer<HomePresenter>(builder: (context, stateDropDown, child) {
      return Container(
        margin: EdgeInsets.symmetric(vertical: 12, horizontal: 32),
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            border: Border.all(color: Theme.of(context).hintColor, width: 1.0),
            borderRadius: BorderRadius.all(Radius.circular(8))),
        child: new SizedBox(
          width: double.infinity,
          child: DropdownButtonHideUnderline(
            child: DropdownButton<USState>(
                value: stateDropDown.selectedState,
                onChanged: (USState newValue) {
                  stateDropDown.updateSelectedState(newValue);
                },
                isDense: true,
                items: stateDropDown.states.map((USState value) {
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
