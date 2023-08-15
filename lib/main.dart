import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final keys = [
      ['q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p'],
      ['a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l'],
      ['back', 'z', 'x', 'c', 'v', 'b', 'n', 'm', 'enter'],
    ];

    final width = MediaQuery.sizeOf(context).width / 10;

    return MaterialApp(
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              children: keys
                  .map(
                    (e) => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: e
                          .map(
                            (e) => SizedBox(
                              width: ['enter', 'back'].contains(e)
                                  ? width * 1.5
                                  : width,
                              height: width * 1.6,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 3,
                                  horizontal: 2,
                                ),
                                child: FilledButton.tonal(
                                  onPressed: () {},
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
      ),
    );
  }
}
