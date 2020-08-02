import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:politic/data/models/feed.dart';
import 'package:politic/data/models/user.dart';
import 'package:politic/ui/util/constants.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/lib.dart';
import '../../data/lib.dart';
import '../util/lib.dart';
import 'location_services.dart';

class FeedStatePage extends StatefulWidget {
  final DistrictLocation districtLocation;

  const FeedStatePage(this.districtLocation, {Key key}) : super(key: key);

  @override
  FeedStateState createState() => new FeedStateState(districtLocation);
}

class FeedStateState extends State<FeedStatePage> with LDEViewMixin implements FeedStateView {
  final DistrictLocation districtLocation;

  FeedStateState(this.districtLocation);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future<bool>.value(true);
      },
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => FeedStatePresenter(this, districtLocation)),
        ],
        child: Consumer<FeedStatePresenter>(builder: (context, presenter, child) {
          final menuButton = new PopupMenuButton<int>(
            onSelected: (int i) {},
            itemBuilder: (BuildContext ctx) {},
            child: Padding(
              padding: const EdgeInsets.only(right: 32.0),
              child: new Icon(Icons.search, color: Theme.of(context).colorScheme.onSurface),
            ),
          );

          return Scaffold(
            key: scaffoldKey,
            backgroundColor: Theme.of(context).colorScheme.surface,
            body: Stack(
              children: <Widget>[
                presenter.isLoading ? Center(child: CircularProgressIndicator()) : SizedBox.shrink(),
                ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 23),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Upcoming election in 21 Days".toUpperCase(),
                                style: Styles.overline(Theme.of(context)),
                              ),
                              Text(
                                "You’re registered!",
                                style: Styles.headline5(Theme.of(context)),
                              ),
                            ],
                          ),
                          FlatButton(
                            textColor: Theme.of(context).colorScheme.primary,
                            child: Text("Find Polls".toUpperCase()),
                            onPressed: () {
                              presenter.onFindPollsClick();
                            },
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 106,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: RepresentativeStories(presenter),
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemCount: presenter.stateFeedResponse?.feed?.length ?? 0,
                      itemBuilder: (BuildContext context, int index) {
                        return StateFeedWidget(presenter.stateFeedResponse.feed[index]);
                      },
                    ),
                  ],
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

class StateFeedWidget extends StatelessWidget {
  final StateFeedItem item;
  const StateFeedWidget(
    this.item, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String type = "Press Release";
    Color typeColor = Colors.teal.shade400;
    if (item.itemType == "keyVote") {
      type = "Key Votes";
      typeColor = Colors.red.shade400;
    }

    return Container(
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: () {
            launch(item.link);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
            child: Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                      decoration:
                          BoxDecoration(color: typeColor, borderRadius: BorderRadius.all(Radius.circular(32.0))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
                        child: Text(
                          type.toUpperCase(),
                          style: Styles.overline(Theme.of(context))
                              .copyWith(color: Theme.of(context).colorScheme.onSecondary),
                        ),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    item.title,
                    style: Styles.headline6(
                      Theme.of(context),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RepresentativeStories extends StatelessWidget {
  final FeedStatePresenter presenter;

  const RepresentativeStories(
    this.presenter, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: presenter.stateFeedResponse?.representatives?.length ?? 0,
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(width: 16);
        },
        itemBuilder: (BuildContext context, int index) {
          var rep = presenter.stateFeedResponse.representatives[index];
          return Column(
            children: <Widget>[
              CircularImage(rep.image ?? Constants.placeholderImageUrl, Constants.colorForParty(rep.party), 2, 50),
              Container(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    rep.displayName,
                    style: Styles.subtitle2(
                      Theme.of(context),
                    ).copyWith(fontSize: 12),
                  ),
                ),
              )
            ],
          );
        });
  }
}

abstract class FeedStateView implements BaseView, ListOps {
  // void navigateToSomewhere();
}

class FeedStatePresenter extends BasePresenter<FeedStateView> with ChangeNotifier, DiagnosticableTreeMixin {
  Repo repo;
  bool isLoading = false;
  StateFeedResponse stateFeedResponse;
  DistrictLocation districtLocation;

  FeedStatePresenter(FeedStateView view, this.districtLocation) : super(view) {
    final injector = Injector.getInjector();
    repo = injector.get();
    loadData();
  }

  void updateLoading(bool isLoading) {
    this.isLoading = isLoading;
    notifyListeners();
  }

  loadData() async {
    updateLoading(true);
    stateFeedResponse =
        await repo.getStatesFeed(districtLocation.state).catchError((error) => {view.showErrorMessage(error, null)});
    updateLoading(false);
    notifyListeners();
  }

  onSaveAndContinue() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LocationServicesPage(),
      ),
    );
  }

  onContinue(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LocationServicesPage(),
      ),
    );
  }

  void onFindPollsClick() {}
}
