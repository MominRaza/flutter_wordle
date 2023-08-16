import 'package:flutter/material.dart';

class WinDialog extends StatelessWidget {
  const WinDialog(
    this.card, {
    super.key,
    required this.restart,
  });

  final List<List<Map<dynamic, dynamic>>> card;
  final VoidCallback restart;

  @override
  Widget build(BuildContext context) {
    String emoji = '';
    for (var e in card) {
      for (var e in e) {
        e['match'] == 'MATCHED'
            ? emoji += '🟩'
            : e['match'] == 'PARTIAL'
                ? emoji += '🟨'
                : e['match'] == 'UNMATCHED'
                    ? emoji += '⬛'
                    : '';
      }
      emoji += '\n';
    }
    return AlertDialog(
      title: const Text('You win'),
      content: Text('Flutter Worldle\n$emoji'.trim()),
      actions: [
        TextButton(
          onPressed: () {
            restart();
            Navigator.pop(context);
          },
          child: const Text('Restart'),
        ),
        FilledButton.tonal(
          onPressed: () {},
          child: const Text('Share'),
        ),
      ],
    );
  }
}
