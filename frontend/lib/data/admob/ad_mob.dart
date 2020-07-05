import 'dart:io' show Platform;


class AdInitializer {
  String unitId;

  AdInitializer() {
    var appId;
    if (Platform.isAndroid) { 
      appId = "??";
      unitId = "??";
    } else if (Platform.isIOS) {
      appId = "??";
      unitId = "??";
    }

    // FirebaseAdMob.instance.initialize(appId: appId);
  }

  // BannerAd btmBanner;

  void showBanner(bool show) {
    if (!isAdsEnabled()) {
      return null;
    }

    // if (btmBanner == null && show) {
    //   MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    //     childDirected: false,
    //     testDevices: <
    //         String>[], // Android emulators are considered test devices
    //   );

    //   btmBanner = BannerAd(
    //     // Replace the testAdUnitId with an ad unit id from the AdMob dash.
    //     // https://developers.google.com/admob/android/test-ads
    //     // https://developers.google.com/admob/ios/test-ads
    //     adUnitId: unitId,
    //     size: AdSize.smartBanner,
    //     targetingInfo: targetingInfo,
    //   );
    // }

    // if (show) {
    //   btmBanner.load().then((loaded) {
    //     btmBanner.show();
    //   });
    // }

    // if (!show && btmBanner != null) {
    //   btmBanner.load().then((loaded) {
    //     if (btmBanner != null) {
    //       btmBanner.dispose();
    //       btmBanner = null;
    //     }
    //   });
    // }
  }

  bool isAdsEnabled() {
    return false;
  }
}
