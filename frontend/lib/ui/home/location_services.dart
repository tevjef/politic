import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:geocoder/geocoder.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

import '../../core/lib.dart';
import '../../data/lib.dart';
import '../util/lib.dart';

class LocationServicesPage extends StatefulWidget {
  const LocationServicesPage({Key key}) : super(key: key);

  @override
  LocationServicesState createState() => new LocationServicesState();
}

class LocationServicesState extends State<LocationServicesPage> with LDEViewMixin implements LocationServicesView {
  LocationServicesState() {}

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future<bool>.value(true);
      },
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => LocationServicesPresenter(this)),
        ],
        child: Consumer<LocationServicesPresenter>(builder: (context, presenter, child) {
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
                        Image.asset('res/images/location_services.png'),
                        Text(
                          "Turn on location services to see your district and representatives.",
                          textAlign: TextAlign.center,
                          style: Styles.headline5(Theme.of(context)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Text(
                            "We can’t find your representatives and district lines unless your turn on location services.",
                            textAlign: TextAlign.center,
                            style: Styles.body1(Theme.of(context)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ButtonGroup(
                    "Turn on location services",
                    () => {presenter.onRequestionLocationServicesClick()},
                    secondaryCtaText: "Enter address manually",
                    secodaryListener: () => {presenter.onManualEntryClick()},
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

abstract class LocationServicesView implements BaseView, ListOps {
  // void navigateToSomewhere();
}

class LocationServicesPresenter extends BasePresenter<LocationServicesView>
    with ChangeNotifier, DiagnosticableTreeMixin {
  Location location = new Location();

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;

  Repo repo;

  bool isLoading = false;

  LocationServicesPresenter(LocationServicesView view) : super(view) {
    final injector = Injector.getInjector();
    repo = injector.get();
  }

  void updateLoading(bool isLoading) {
    this.isLoading = isLoading;
    notifyListeners();
  }

  void onRequestionLocationServicesClick() async {
    updateLoading(true);

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        updateLoading(false);
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        updateLoading(false);
        return;
      }
    } else if (_permissionGranted == PermissionStatus.deniedForever) {
      onManualEntryClick();
    }

    _locationData = await location.getLocation();

    updateLoading(false);

    final coordinates = new Coordinates(_locationData.latitude, _locationData.longitude);
    var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);

    view.showMessage("Location result ${addresses.first.toMap()}");
  }

  onManualEntryClick() {}
}
