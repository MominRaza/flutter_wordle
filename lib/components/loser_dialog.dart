import 'package:flutter/material.dart';

class LoserDialog extends StatelessWidget {
  const LoserDialog({super.key, required this.restart});

  final VoidCallback restart;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Loser'),
      actions: [
        FilledButton.tonal(
          onPressed: () {
            restart();
            Navigator.pop(context);
          },
          child: const Text('Restart'),
        ),
      ],
    );
  }
}
