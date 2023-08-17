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
                            onPressed: key['text'] == 'enter'
                                ? enterPress
                                : key['text'] == 'back'
                                    ? backPress
                                    : () => keyPress(key),
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
                                                  : (key['match'] as String) ==
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
    );
  }
}
