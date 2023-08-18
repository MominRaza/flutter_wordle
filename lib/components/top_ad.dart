import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart'
    show AdRequest, AdSize, AdWidget, BannerAd, BannerAdListener;

class TopAd extends StatefulWidget implements PreferredSizeWidget {
  const TopAd({super.key});

  @override
  State<TopAd> createState() => _TopAdState();

  @override
  Size get preferredSize =>
      Platform.isAndroid ? const Size.fromHeight(60) : Size.zero;
}

class _TopAdState extends State<TopAd> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;

  // TODO: replace this test ad unit with your own ad unit.
  final adUnitId = 'ca-app-pub-3940256099942544/6300978111';

  void loadAd() {
    _bannerAd = BannerAd(
      adUnitId: adUnitId,
      request: const AdRequest(),
      size: AdSize.fullBanner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          debugPrint('$ad loaded.');
          setState(() {
            _isLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          debugPrint('BannerAd failed to load: $err');
          ad.dispose();
        },
      ),
    )..load();
  }

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      loadAd();
    }
  }

  @override
  Widget build(BuildContext context) {
    return _bannerAd != null && _isLoaded
        ? SizedBox(
            height: _bannerAd!.size.height.toDouble(),
            child: AdWidget(ad: _bannerAd!),
          )
        : const SizedBox();
  }
}
