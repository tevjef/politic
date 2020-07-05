import '../../core/lib.dart';
import '../../data/lib.dart';
import '../util/lib.dart';
import 'home_presenter.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  HomeListState createState() => new HomeListState();
}

class HomeListState extends State<HomePage>
    with LDEViewMixin
    implements HomeView {
  HomePresenter presenter;
  AdInitializer adInitializer;

  HomeListState() {
    final injector = Injector.getInjector();
    adInitializer = injector.get();
    adInitializer.showBanner(false);

    presenter = new HomePresenter(this);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          return Future<bool>.value(true);
        },
        child: Scaffold(
          key: scaffoldKey,
          appBar: new AppBar(
            title: new Text("Title"),
          ),
          body: makeRefreshingList(),
        ));
  }

  @override
  void onRefreshData() {
    presenter.loadData();
  }
}
