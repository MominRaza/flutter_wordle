import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../dictionary.dart';
import 'win_dialog.dart';

class Game extends StatefulWidget {
  const Game({
    super.key,
  });

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  final wordle = dictionary[Random().nextInt(dictionary.length)].split('');
  int length = 0;
  List<String> guess = [];
  final keys = [
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

  final card = [
    [{}, {}, {}, {}, {}],
    [{}, {}, {}, {}, {}],
    [{}, {}, {}, {}, {}],
    [{}, {}, {}, {}, {}],
    [{}, {}, {}, {}, {}],
    [{}, {}, {}, {}, {}],
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final keyWidth = width / 10;
    final cardWidth = width / 6;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Wordle'),
        actions: length <= 25
            ? null
            : [
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
                )
              ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: card
                  .map(
                    (e) => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: e
                          .map(
                            (e) => SizedBox(
                              width: cardWidth,
                              height: cardWidth,
                              child: Card(
                                color: e['match'] == null
                                    ? null
                                    : (e['match'] as String) == 'MATCHED'
                                        ? Colors.green
                                        : (e['match'] as String) == 'PARTIAL'
                                            ? Colors.yellow
                                            : (e['match'] as String) ==
                                                    'UNMATCHED'
                                                ? Colors.black
                                                : null,
                                child: Center(
                                  child: Text(
                                    (e['text'] as String? ?? '').toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: e['match'] == null
                                          ? null
                                          : (e['match'] as String) ==
                                                  'UNMATCHED'
                                              ? Colors.white
                                              : (e['match'] as String) ==
                                                      'PARTIAL'
                                                  ? Colors.black
                                                  : null,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  )
                  .toList(),
            ),
          ),
          Column(
            children: keys
                .map(
                  (k) => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: k
                        .map(
                          (key) => SizedBox(
                            width: ['enter', 'back'].contains(key['text'])
                                ? keyWidth * 1.5
                                : keyWidth,
                            height: keyWidth * 1.6,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 3,
                                horizontal: 2,
                              ),
                              child: FilledButton.tonal(
                                onPressed: key['text'] == 'enter'
                                    ? guess.isNotEmpty && guess.length % 5 == 0
                                        ? () {
                                            if (!dictionary
                                                .contains(guess.join())) {
                                              ScaffoldMessenger.of(context)
                                                  .hideCurrentSnackBar();
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: const Text(
                                                    'Not in word list',
                                                  ),
                                                  duration: const Duration(
                                                    seconds: 1,
                                                  ),
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                  margin: EdgeInsets.fromLTRB(
                                                    15.0,
                                                    5.0,
                                                    15.0,
                                                    10.0 + keyWidth * 1.6 * 3,
                                                  ),
                                                ),
                                              );
                                              return;
                                            }

                                            for (var i = 0; i < 5; i++) {
                                              card[(length - 1) ~/ 5][i]
                                                  ['match'] = guess[i] ==
                                                      wordle[i]
                                                  ? 'MATCHED'
                                                  : wordle.contains(guess[i])
                                                      ? 'PARTIAL'
                                                      : 'UNMATCHED';

                                              for (var element in keys) {
                                                for (var element in element) {
                                                  if (element['text'] ==
                                                          guess[i] &&
                                                      element['match'] !=
                                                          'MATCHED') {
                                                    element['match'] =
                                                        guess[i] == wordle[i]
                                                            ? 'MATCHED'
                                                            : wordle.contains(
                                                                    guess[i])
                                                                ? 'PARTIAL'
                                                                : 'UNMATCHED';
                                                  }
                                                }
                                              }
                                            }

                                            if (listEquals(wordle, guess)) {
                                              showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    WinDialog(card),
                                              );
                                            }

                                            setState(() {
                                              guess = [];
                                            });
                                          }
                                        : null
                                    : key['text'] == 'back'
                                        ? guess.isNotEmpty
                                            ? () {
                                                setState(() {
                                                  guess.removeLast();
                                                  card[(length - 1) ~/ 5][
                                                      ((length % 5) - 1) == -1
                                                          ? 4
                                                          : (length % 5) -
                                                              1]['text'] = '';
                                                  length--;
                                                });
                                              }
                                            : null
                                        : length >= 30
                                            ? null
                                            : guess.length == 5
                                                ? null
                                                : () {
                                                    setState(() {
                                                      guess.add(key['text']!);
                                                      length++;
                                                      card[(length - 1) ~/
                                                              5][((length % 5) -
                                                                      1) ==
                                                                  -1
                                                              ? 4
                                                              : (length % 5) -
                                                                  1]['text'] =
                                                          key['text'];
                                                    });
                                                  },
                                style: ButtonStyle(
                                  padding: const MaterialStatePropertyAll(
                                    EdgeInsets.zero,
                                  ),
                                  shape: MaterialStatePropertyAll(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  backgroundColor: key['match'] != null
                                      ? MaterialStatePropertyAll(
                                          key['match'] == 'MATCHED'
                                              ? Colors.green
                                              : key['match'] == 'PARTIAL'
                                                  ? Colors.yellow
                                                  : key['match'] == 'UNMATCHED'
                                                      ? Colors.black
                                                      : null,
                                        )
                                      : null,
                                ),
                                child: key['text'] == 'enter'
                                    ? const Icon(Icons.keyboard_return)
                                    : key['text'] == 'back'
                                        ? const Icon(Icons.backspace_outlined)
                                        : Text(
                                            key['text']!.toUpperCase(),
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 22,
                                              color: key['match'] == null
                                                  ? null
                                                  : (key['match'] as String) ==
                                                          'UNMATCHED'
                                                      ? Colors.white
                                                      : (key['match']
                                                                  as String) ==
                                                              'PARTIAL'
                                                          ? Colors.black
                                                          : null,
                                            ),
                                          ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
