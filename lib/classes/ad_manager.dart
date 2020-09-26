import 'dart:io';

import 'package:firebase_admob/firebase_admob.dart';

class AdManager {

  static String get appID {
    if(Platform.isAndroid) return "ca-app-pub-9309934780793349~5727629973";
    else throw new UnsupportedError("Platforma nesuportata");
  }

  static String get bannerAdUnitId {
    if(Platform.isAndroid)
//      return "ca-app-pub-3940256099942544/6300978111";
      return "ca-app-pub-9309934780793349/8832289557";
    else throw new UnsupportedError("Platforma nesuportata");
  }

  static String get interstitialAdUnitID {
    if(Platform.isAndroid)
      return "ca-app-pub-9309934780793349/6206126213";
//      return "ca-app-pub-3940256099942544/1033173712";
    else throw new UnsupportedError("Platforma nesuportata");
  }

  Future<void> initAdMob() {
    print("Se initializeaza reclamele");
    return FirebaseAdMob.instance.initialize(appId: AdManager.appID);
  }

  InterstitialAd interstitialAd(){
    return InterstitialAd(
      adUnitId: interstitialAdUnitID,
      listener: (MobileAdEvent event) {
        print("Interstitial Ad event is $event");
      },
    );
  }

  BannerAd bannerAd(){
    return BannerAd(
      size: AdSize.banner,
      adUnitId: bannerAdUnitId,
    );
  }

}