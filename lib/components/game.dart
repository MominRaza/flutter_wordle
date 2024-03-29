import 'dart:io' show Platform;
import 'dart:math' show Random;

import 'package:flutter/foundation.dart' show listEquals;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'
    show ConsumerStatefulWidget, ConsumerState;
import 'package:google_mobile_ads/google_mobile_ads.dart'
    show
        InterstitialAd,
        AdRequest,
        InterstitialAdLoadCallback,
        FullScreenContentCallback;

import '../dictionary.dart';
import '../providers/hint_point.dart';
import 'card_board.dart';
import 'hint_button.dart';
import 'key_board.dart';
import 'loser_dialog.dart';
import 'top_ad.dart';
import 'win_dialog.dart';

class Game extends ConsumerStatefulWidget {
  const Game({
    super.key,
  });

  @override
  ConsumerState<Game> createState() => _GameState();
}

class _GameState extends ConsumerState<Game> {
  late List<String> wordle, guess;
  late int length;
  late List<List<Map>> keys, card;
  late bool winner;

  @override
  void initState() {
    super.initState();
    restart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Wordle'),
        actions: [
          HintButton(wordle: wordle),
          IconButton(
            onPressed: restart,
            icon: const Icon(Icons.restart_alt),
          ),
        ],
        bottom: const TopAd(),
      ),
      body: CardBoard(card: card),
      bottomNavigationBar: KeyBoard(
        keys: keys,
        keyPress: keyPress,
        enterPress: enterPress,
        backPress: backPress,
      ),
    );
  }

  void restart() {
    if (Platform.isAndroid && _interstitialAd == null) {
      loadAd();
    }
    wordle = dictionary[Random().nextInt(dictionary.length)].split('');
    debugPrint(wordle.toString());
    length = 0;
    guess = [];
    keys = [
      [
        {'text': 'q'},
        {'text': 'w'},
        {'text': 'e'},
        {'text': 'r'},
        {'text': 't'},
        {'text': 'y'},
        {'text': 'u'},
        {'text': 'i'},
        {'text': 'o'},
        {'text': 'p'},
      ],
      [
        {'text': 'a'},
        {'text': 's'},
        {'text': 'd'},
        {'text': 'f'},
        {'text': 'g'},
        {'text': 'h'},
        {'text': 'j'},
        {'text': 'k'},
        {'text': 'l'},
      ],
      [
        {'text': 'back'},
        {'text': 'z'},
        {'text': 'x'},
        {'text': 'c'},
        {'text': 'v'},
        {'text': 'b'},
        {'text': 'n'},
        {'text': 'm'},
        {'text': 'enter'},
      ],
    ];
    card = [
      [{}, {}, {}, {}, {}],
      [{}, {}, {}, {}, {}],
      [{}, {}, {}, {}, {}],
      [{}, {}, {}, {}, {}],
      [{}, {}, {}, {}, {}],
      [{}, {}, {}, {}, {}],
    ];
    winner = false;
    setState(() {});
  }

  void keyPress(key) {
    if (length >= 30 || guess.length == 5 || winner) return;

    setState(() {
      guess.add(key['text']!);
      length++;
      card[(length - 1) ~/ 5][((length % 5) - 1) == -1 ? 4 : (length % 5) - 1]
          ['text'] = key['text'];
    });
  }

  void backPress() {
    if (guess.isEmpty) return;

    setState(() {
      guess.removeLast();
      card[(length - 1) ~/ 5][((length % 5) - 1) == -1 ? 4 : (length % 5) - 1]
          ['text'] = '';
      length--;
    });
  }

  void enterPress() {
    if (guess.isEmpty) return;
    if (guess.length % 5 != 0) return;

    if (!dictionary.contains(guess.join())) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Not in word list',
          ),
          duration: Duration(
            seconds: 1,
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    for (var i = 0; i < 5; i++) {
      final lengthDiff = guess.where((e) => e == guess[i]).length -
          wordle.where((e) => e == guess[i]).length;

      card[(length - 1) ~/ 5][i]['match'] = guess[i] == wordle[i]
          ? 'MATCHED'
          : wordle.contains(guess[i]) &&
                  (lengthDiff == 0 || guess.indexOf(guess[i]) + lengthDiff > i)
              ? 'PARTIAL'
              : 'UNMATCHED';

      for (var element in keys) {
        for (var element in element) {
          if (element['text'] == guess[i] && element['match'] != 'MATCHED') {
            element['match'] = guess[i] == wordle[i]
                ? 'MATCHED'
                : wordle.contains(guess[i])
                    ? 'PARTIAL'
                    : 'UNMATCHED';
          }
        }
      }
    }

    if (listEquals(wordle, guess)) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => WillPopScope(
          onWillPop: () async => false,
          child: WinDialog(
            card,
            restart: _interstitialAd != null ? _interstitialAd!.show : restart,
          ),
        ),
      );
      ref.read(hintPointProvider.notifier).win(
            6 - (length ~/ 5),
          );
      winner = true;
    } else if (length >= 30) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => WillPopScope(
          onWillPop: () async => false,
          child: LoserDialog(
            restart: _interstitialAd != null ? _interstitialAd!.show : restart,
            wordle: wordle,
          ),
        ),
      );
    }

    setState(() => guess = []);
  }

  InterstitialAd? _interstitialAd;

  // TODO: replace this test ad unit with your own ad unit.
  final adUnitId = 'ca-app-pub-3940256099942544/1033173712';

  void loadAd() {
    InterstitialAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdFailedToShowFullScreenContent: (ad, err) {
              ad.dispose();
              _interstitialAd!.dispose();
              _interstitialAd = null;
              restart();
            },
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _interstitialAd!.dispose();
              _interstitialAd = null;
              restart();
            },
          );

          debugPrint('$ad loaded.');
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (error) {
          debugPrint('InterstitialAd failed to load: $error');
        },
      ),
    );
  }
}
