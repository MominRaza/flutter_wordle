import 'package:flutter/material.dart';

class CardBoard extends StatelessWidget {
  const CardBoard({super.key, required this.card});

  final List<List<Map>> card;

  @override
  Widget build(BuildContext context) {
    final cardWidth = MediaQuery.sizeOf(context).shortestSide / 6;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: cardWidth / 2),
      child: Column(
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
                          color: switch (e['match']) {
                            null => null,
                            'MATCHED' => Colors.green,
                            'PARTIAL' => Colors.yellow,
                            'UNMATCHED' => Colors.black,
                            Object() => null,
                          },
                          child: Center(
                            child: Text(
                              (e['text'] as String? ?? '').toUpperCase(),
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: switch (e['match']) {
                                  null => null,
                                  'PARTIAL' => Colors.black,
                                  'UNMATCHED' => Colors.white,
                                  Object() => null,
                                },
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
