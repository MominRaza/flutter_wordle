import 'package:flutter/material.dart';

class LoserDialog extends StatelessWidget {
  const LoserDialog({super.key, required this.restart, required this.wordle});

  final VoidCallback restart;
  final List<String> wordle;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Loser'),
      content: Text('Correct word was "${wordle.join().toUpperCase()}"'),
      actions: [
        TextButton(
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
