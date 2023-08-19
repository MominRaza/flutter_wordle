import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart' show Share;

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
        emoji += e['match'] == 'MATCHED'
            ? '🟩'
            : e['match'] == 'PARTIAL'
                ? '🟨'
                : e['match'] == 'UNMATCHED'
                    ? '⬛'
                    : '';
      }
      emoji += '\n';
    }
    final message = 'Flutter Wordle\n$emoji'.trim();
    return AlertDialog(
      title: const Text('You win'),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () {
            restart();
            Navigator.pop(context);
          },
          child: const Text('Restart'),
        ),
        TextButton(
          onPressed: () => Share.share(
            '$message\n\nhttps://mominraza.dev/flutter_wordle',
          ),
          child: const Text('Share'),
        ),
      ],
    );
  }
}
