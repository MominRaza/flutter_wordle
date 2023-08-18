import 'dart:math' show Random;

import 'package:flutter/foundation.dart' show listEquals;
import 'package:flutter/material.dart';

import '../dictionary.dart';
import 'card_board.dart';
import 'key_board.dart';
import 'loser_dialog.dart';
import 'top_ad.dart';
import 'win_dialog.dart';

class Game extends StatefulWidget {
  const Game({
    super.key,
  });

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  late List<String> wordle, guess;
  late int length;
  late List<List<Map>> keys, card;

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
          if ((length == 25 && guess.isEmpty) || length > 25)
            IconButton(
              onPressed: () => showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Hint'),
                  content: Text(
                    wordle.join(''),
                  ),
                ),
              ),
              icon: const Icon(Icons.tips_and_updates_outlined),
            ),
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
    setState(() {});
  }

  void keyPress(key) {
    if (length >= 30) return;
    if (guess.length == 5) return;

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
      card[(length - 1) ~/ 5][i]['match'] = guess[i] == wordle[i]
          ? 'MATCHED'
          : wordle.contains(guess[i])
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
            restart: restart,
          ),
        ),
      );
    } else if (length >= 30) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => WillPopScope(
          onWillPop: () async => false,
          child: LoserDialog(restart: restart),
        ),
      );
    }

    setState(() => guess = []);
  }
}
