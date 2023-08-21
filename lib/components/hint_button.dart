import 'dart:io' show Platform;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'
    show ConsumerStatefulWidget, ConsumerState;
import 'package:google_mobile_ads/google_mobile_ads.dart'
    show
        RewardedAd,
        AdRequest,
        RewardedAdLoadCallback,
        FullScreenContentCallback;

import '../providers/hint_point.dart';

class HintButton extends ConsumerStatefulWidget {
  const HintButton({super.key, required this.wordle});

  final List<String> wordle;

  @override
  ConsumerState<HintButton> createState() => _HintButtonState();
}

class _HintButtonState extends ConsumerState<HintButton> {
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      loadAd();
    }
    ref.read(hintPointProvider.notifier).load();
  }

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () => showDialog(
        context: context,
        builder: (context) => _HintDialog(
          wordle: widget.wordle,
          rewardedAd: _rewardedAd,
        ),
      ).then(
        (_) => Platform.isAndroid && _rewardedAd == null ? loadAd() : null,
      ),
      icon: const Icon(Icons.tips_and_updates_outlined),
      label: Text(ref.watch(hintPointProvider).toString()),
    );
  }

  RewardedAd? _rewardedAd;

  // TODO: replace this test ad unit with your own ad unit.
  final adUnitId = 'ca-app-pub-3940256099942544/5224354917';

  void loadAd() {
    RewardedAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdFailedToShowFullScreenContent: (ad, err) {
              ad.dispose();
              _rewardedAd?.dispose();
              _rewardedAd = null;
            },
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _rewardedAd?.dispose();
              _rewardedAd = null;
            },
          );

          debugPrint('$ad loaded.');
          _rewardedAd = ad;
        },
        onAdFailedToLoad: (error) {
          debugPrint('RewardedAd failed to load: $error');
        },
      ),
    );
  }
}

class _HintDialog extends ConsumerStatefulWidget {
  const _HintDialog({required this.wordle, required this.rewardedAd});

  @override
  ConsumerState<_HintDialog> createState() => __HintDialogState();
  final List<String> wordle;
  final RewardedAd? rewardedAd;
}

class __HintDialogState extends ConsumerState<_HintDialog> {
  bool _showHint = false;
  final List<int> random = [
    Random().nextInt(5),
    Random().nextInt(5),
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Icon(Icons.tips_and_updates_outlined),
      title: const Text('Wordle Hint'),
      content: _showHint
          ? Row(
              children: widget.wordle
                  .map(
                    (e) => Expanded(
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Card(
                          color: Colors.green,
                          child: Center(
                            child: Text(
                              random.contains(widget.wordle.indexOf(e))
                                  ? e.toUpperCase()
                                  : '',
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            )
          : const Text('Use 1 Hint Point or Watch an Ad to see a hint.'),
      actions: _showHint
          ? null
          : [
              TextButton.icon(
                onPressed: widget.rewardedAd != null
                    ? () => widget.rewardedAd!.show(
                          onUserEarnedReward: (_, __) {
                            setState(() => _showHint = true);
                          },
                        )
                    : null,
                icon: const Icon(Icons.ad_units),
                label: const Text('Free'),
              ),
              TextButton(
                onPressed: ref.watch(hintPointProvider) >= 1
                    ? () {
                        ref.read(hintPointProvider.notifier).showHint();
                        setState(() => _showHint = true);
                      }
                    : null,
                child: const Text('1 Point'),
              ),
            ],
    );
  }
}
