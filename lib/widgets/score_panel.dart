import 'package:flutter/material.dart';

class ScorePanel extends StatelessWidget {
  final String teamName;
  final int score;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final String hintText;

  const ScorePanel({
    super.key,
    required this.teamName,
    required this.score,
    required this.onIncrease,
    required this.onDecrease,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onVerticalDragEnd: (details) {
          final v = details.primaryVelocity ?? 0;
          if (v < 0) {
            onIncrease();
          } else if (v > 0) {
            onDecrease();
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: LayoutBuilder(
            builder: (context, c) {
              final isTablet = c.maxWidth > 600;
              final scoreSize = isTablet ? 168.0 : 124.0;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    teamName,
                    textAlign: TextAlign.center,
                    style: Theme.of(
                      context,
                    ).textTheme.headlineLarge?.copyWith(letterSpacing: 1.2),
                  ),
                  const SizedBox(height: 18),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      '$score',
                      style: Theme.of(
                        context,
                      ).textTheme.displayLarge?.copyWith(fontSize: scoreSize),
                    ),
                  ),
                  const SizedBox(height: 18),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
