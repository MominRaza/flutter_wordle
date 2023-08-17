import 'package:flutter/material.dart';

class CardBoard extends StatelessWidget {
  const CardBoard({super.key, required this.card});

  final List<List<Map>> card;

  @override
  Widget build(BuildContext context) {
    final cardWidth = MediaQuery.sizeOf(context).width / 6;

    return Column(
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
                                    : (e['match'] as String) == 'UNMATCHED'
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
                                  : (e['match'] as String) == 'UNMATCHED'
                                      ? Colors.white
                                      : (e['match'] as String) == 'PARTIAL'
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
    );
  }
}
