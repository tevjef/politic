import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:geocoder/geocoder.dart';
import 'package:location/location.dart';
import 'package:politic/data/models/user.dart';
import 'package:politic/ui/home/home_view.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

import '../../core/lib.dart';
import '../../data/lib.dart';
import '../util/lib.dart';

class ManualLocationPage extends StatefulWidget {
  ManualLocationPage({Key key}) : super(key: key);

  @override
  ManualLocationState createState() => new ManualLocationState();
}

class ManualLocationState extends State<ManualLocationPage> with LDEViewMixin implements ManualLocationView {
  ManualLocationState() {}

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future<bool>.value(true);
      },
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ManualLocationPresenter(this)),
        ],
        child: Consumer<ManualLocationPresenter>(builder: (context, presenter, child) {
          return Scaffold(
            key: scaffoldKey,
            backgroundColor: Theme.of(context).colorScheme.surface,
            appBar: AppBar(
              leading: BackButton(
                color: Theme.of(context).colorScheme.onSurface,
              ),
              brightness: Brightness.light,
              backgroundColor: Theme.of(context).colorScheme.surface,
              elevation: 0,
            ),
            body: ListView(
              physics: ClampingScrollPhysics(),
              children: <Widget>[
                Headline("Search for an address below", "Manually located your address using the the input below."),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  child: TextFormField(
                    onChanged: presenter.onInputChanged,
                    decoration: InputDecoration(
                      labelText: "Search Addresss",
                      border: new OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          borderSide: new BorderSide(color: Theme.of(context).primaryColor)),
                    ),
                  ),
                ),
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: presenter.suggestions.length,
                    itemBuilder: (BuildContext context, int index) {
                      var address = presenter.suggestions[index];
                      return ListCellSubtitle2(address, () {
                        presenter.onAddressSelected(address);
                      });
                    }),
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

abstract class ManualLocationView implements BaseView, ListOps {
  // void navigateToSomewhere();
}

class ManualLocationPresenter extends BasePresenter<ManualLocationView> with ChangeNotifier, DiagnosticableTreeMixin {
  Repo repo;
  bool isLoading = false;

  List<String> suggestions = [];

  ManualLocationPresenter(ManualLocationView view) : super(view) {
    final injector = Injector.getInjector();
    repo = injector.get();
  }

  void updateLoading(bool isLoading) {
    this.isLoading = isLoading;
    notifyListeners();
  }

  onInputChanged(String input) async {
    updateLoading(true);
    if (input.isEmpty) {
      suggestions.clear();
    } else {
      var result = await repo.autocomplete(input).catchError((error) => {view.showErrorMessage(error, null)});
      suggestions.clear();
      suggestions.addAll(result);
    }

    notifyListeners();
    updateLoading(false);
  }

  onAddressSelected(String address) async {
    updateLoading(true);

    var coordinates = (await Geocoder.local.findAddressesFromQuery(address))[0].coordinates;

    await repo.saveLocation(LocationLatLng(lat: coordinates.latitude, lng: coordinates.longitude)).catchError((error) =>
        {view.showMessage(error, SnackBarAction(label: "Use location services", onPressed: onAddressNotFound))});

    onAddressFound();
    updateLoading(false);
  }

  onAddressFound() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => PoliticHomePage(),
      ),
    );
  }

  onAddressNotFound() {
    Navigator.pop(context);
  }
}
