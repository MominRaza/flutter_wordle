import 'package:flutter/material.dart';

class KeyBoard extends StatelessWidget {
  const KeyBoard({
    super.key,
    required this.keys,
    required this.keyPress,
    required this.enterPress,
    required this.backPress,
  });

  final List<List<Map>> keys;
  final void Function(Map) keyPress;
  final VoidCallback enterPress, backPress;

  @override
  Widget build(BuildContext context) {
    final keyWidth = MediaQuery.sizeOf(context).width / 10;

    return BottomAppBar(
      elevation: 0,
      height: keyWidth * 1.6 * 3,
      padding: EdgeInsets.zero,
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
                            onPressed: switch (key['text']) {
                              null => null,
                              'enter' => enterPress,
                              'back' => backPress,
                              Object() => () => keyPress(key),
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
                              backgroundColor: MaterialStatePropertyAll(
                                switch (key['match']) {
                                  null => null,
                                  'MATCHED' => Colors.green,
                                  'PARTIAL' => Colors.yellow,
                                  'UNMATCHED' => Colors.black,
                                  Object() => null,
                                },
                              ),
                            ),
                            child: switch (key['text']) {
                              null => null,
                              'enter' => const Icon(Icons.keyboard_return),
                              'back' => const Icon(Icons.backspace_outlined),
                              Object() => Text(
                                  key['text']!.toUpperCase(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                    color: switch (key['match']) {
                                      null => null,
                                      'PARTIAL' => Colors.black,
                                      'UNMATCHED' => Colors.white,
                                      Object() => null,
                                    },
                                  ),
                                ),
                            },
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            )
            .toList(),
      ),
    );
  }
}
