import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        brightness: Brightness.dark,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final wordle = ['i', 'n', 'd', 'i', 'a'];
  int length = 0;
  List<String> guess = [];
  final keys = [
    ['q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p'],
    ['a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l'],
    ['back', 'z', 'x', 'c', 'v', 'b', 'n', 'm', 'enter'],
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
                                                    : null),
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
                  (e) => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: e
                        .map(
                          (e) => SizedBox(
                            width: ['enter', 'back'].contains(e)
                                ? keyWidth * 1.5
                                : keyWidth,
                            height: keyWidth * 1.6,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 3,
                                horizontal: 2,
                              ),
                              child: FilledButton.tonal(
                                onPressed: e == 'enter'
                                    ? guess.isNotEmpty && guess.length % 5 == 0
                                        ? () {
                                            setState(() {
                                              for (var i = 0; i < 5; i++) {
                                                card[(length - 1) ~/ 5][i]
                                                    ['match'] = guess[i] ==
                                                        wordle[i]
                                                    ? 'MATCHED'
                                                    : wordle.contains(guess[i])
                                                        ? 'PARTIAL'
                                                        : 'UNMATCHED';
                                              }
                                              guess = [];
                                            });
                                          }
                                        : null
                                    : e == 'back'
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
                                                      guess.add(e);
                                                      length++;
                                                      card[(length - 1) ~/ 5][
                                                              ((length % 5) -
                                                                          1) ==
                                                                      -1
                                                                  ? 4
                                                                  : (length %
                                                                          5) -
                                                                      1]
                                                          ['text'] = e;
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
                                ),
                                child: e == 'enter'
                                    ? const Icon(Icons.keyboard_return)
                                    : e == 'back'
                                        ? const Icon(Icons.backspace_outlined)
                                        : Text(
                                            e.toUpperCase(),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 22,
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
