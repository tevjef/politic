import 'package:collection/collection.dart';

import '../../core/lib.dart';
import '../../data/lib.dart';
import '../util/lib.dart';

abstract class HomeView implements BaseView, ListOps {
  // void navigateToSomewhere();
}

class HomePresenter extends BasePresenter<HomeView> {
  Repo repo;
  AnalyticsLogger analyticsLogger;
  AdInitializer adInitializer;

  HomePresenter(HomeView view) : super(view) {
    final injector = Injector.getInjector();
    analyticsLogger = injector.get();
    repo = injector.get();
    adInitializer = injector.get();
  }

  void onInitState() {
    super.onInitState();
    loadData();
  }

  void loadData() async {
    view.showLoading(true);

    List<Item> adapterItems = List();

    var data = await repo.getData();
    
    adapterItems.addAll(data.map((e) => TextItem(e.name)));
    // Update the UI with the
    view.setListData(adapterItems);
    view.showLoading(false);
  }
}
