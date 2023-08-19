import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show ServicesBinding, KeyDownEvent;

class KeyBoard extends StatefulWidget {
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
  State<KeyBoard> createState() => _KeyBoardState();
}

class _KeyBoardState extends State<KeyBoard> {
  @override
  void initState() {
    super.initState();

    ServicesBinding.instance.keyboard.addHandler(
      (event) {
        if (event is KeyDownEvent) {
          switch (event.logicalKey.keyLabel) {
            case 'Enter' || ' ':
              widget.enterPress();
              return true;
            case 'Backspace' || 'Delete':
              widget.backPress();
              return true;
            default:
              if (event.logicalKey.keyLabel.length == 1 &&
                  65 <= event.logicalKey.keyLabel.codeUnitAt(0) &&
                  event.logicalKey.keyLabel.codeUnitAt(0) <= 90) {
                widget.keyPress({
                  'text': event.logicalKey.keyLabel.toLowerCase(),
                });
                return true;
              }
          }
        }
        return false;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final keyWidth = MediaQuery.sizeOf(context).shortestSide / 10;

    return BottomAppBar(
      elevation: 0,
      height: keyWidth * 1.6 * 3,
      padding: EdgeInsets.zero,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: widget.keys
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
                              'enter' => widget.enterPress,
                              'back' => widget.backPress,
                              Object() => () => widget.keyPress(key),
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
