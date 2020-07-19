import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:location/location.dart';
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
                    () => {presenter.onRequestionManualLocationClick()},
                    secondaryCtaText: "Enter address manually",
                    secodaryListener: () => {presenter.onManualEntryClick(context)},
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

abstract class ManualLocationView implements BaseView, ListOps {
  // void navigateToSomewhere();
}

class ManualLocationPresenter extends BasePresenter<ManualLocationView>
    with ChangeNotifier, DiagnosticableTreeMixin {
  Location location = new Location();

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;

  Repo repo;

  bool isLoading = false;

  ManualLocationPresenter(ManualLocationView view) : super(view) {
    final injector = Injector.getInjector();
    repo = injector.get();
  }

  onRequestionManualLocationClick() async {
    isLoading = true;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        isLoading = false;
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        isLoading = false;
        return;
      }
    } else if (_permissionGranted == PermissionStatus.deniedForever) {
      onManualEntryClick();
    }

    _locationData = await location.getLocation();

    isLoading = false;
    view.showMessage("Location result ${_locationData.latitude} ${_locationData.longitude}");
  }

  onManualEntryClick() {}
}
