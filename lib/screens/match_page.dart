import 'package:badminton_score/providers/match/match_controller.dart';
import 'package:badminton_score/src/generated/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/set_banner.dart';

class MatchArgs {
  final String teamA;
  final String teamB;
  MatchArgs(this.teamA, this.teamB);
}

class MatchPage extends ConsumerWidget {
  final String teamA;
  final String teamB;
  const MatchPage({super.key, required this.teamA, required this.teamB});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    final state = ref.watch(matchControllerProvider((teamA, teamB)));
    final ctrl = ref.read(matchControllerProvider((teamA, teamB)).notifier);

    Future<void> confirmEndSetDialog() async {
      final a = state.scoreA;
      final b = state.scoreB;
      final yes =
          await showDialog<bool>(
            context: context,
            builder: (_) => AlertDialog(
              title: Text(t.endSetTitle),
              content: Text(t.endSetContent(state.teamA, a, b, state.teamB)),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text(t.keepup),
                ),
                FilledButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: Text(t.endSet),
                ),
              ],
            ),
          ) ??
          false;
      if (yes) await ctrl.confirmEndSet();
    }

    void onIncreaseA() async {
      ctrl.increaseA(context);
      ctrl.shouldSuggestEnd ? await confirmEndSetDialog() : null;
    }

    void onIncreaseB() async {
      ctrl.increaseB(context);
      ctrl.shouldSuggestEnd ? await confirmEndSetDialog() : null;
    }

    // Prebuild panels (no Expanded inside)
    final panelA = ScorePanel(
      key: const ValueKey('panel-A'),
      teamName: state.teamA,
      score: state.scoreA,
      onIncrease: onIncreaseA,
      onDecrease: ctrl.decreaseA,
      hintText: t.swipeHint,
    );
    final panelB = ScorePanel(
      key: const ValueKey('panel-B'),
      teamName: state.teamB,
      score: state.scoreB,
      onIncrease: onIncreaseB,
      onDecrease: ctrl.decreaseB,
      hintText: t.swipeHint,
    );

    // Animated slide+fade builder
    Widget slideFade(
      Widget child,
      Animation<double> anim, {
      required bool fromLeft,
    }) {
      final curved = CurvedAnimation(parent: anim, curve: Curves.easeOutCubic);
      return SlideTransition(
        position: Tween<Offset>(
          begin: Offset(fromLeft ? -0.15 : 0.15, 0),
          end: Offset.zero,
        ).animate(curved),
        child: FadeTransition(opacity: curved, child: child),
      );
    }

    final swapButton = Tooltip(
      message: '',
      child: FloatingActionButton.small(
        heroTag: 'swap_sides_center',
        onPressed: () {
          HapticFeedback.selectionClick();
          ctrl.toggleSwap();
        },
        child: AnimatedRotation(
          turns: state.swapped ? 0.5 : 0.0,
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          child: const Icon(Icons.swap_horiz),
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(title: Text(t.vsFormat(state.teamA, state.teamB))),
      body: Column(
        children: [
          SetBanner(
            setIndex: state.setIndex,
            history: state.displayHistory,
            setLabel: t.setLabel(state.setIndex),
          ),
          const Divider(),
          Expanded(
            child: Stack(
              children: [
                // Two half-width panels that slide/cross when swapping
                AnimatedAlign(
                  duration: const Duration(milliseconds: 360),
                  curve: Curves.easeOutCubic,
                  alignment: state.swapped
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: const SizedBox(),
                ),
                AnimatedAlign(
                  duration: const Duration(milliseconds: 360),
                  curve: Curves.easeOutCubic,
                  alignment: state.swapped
                      ? Alignment.centerLeft
                      : Alignment.centerRight,
                  child: const SizedBox(),
                ),
                // Panel A
                AnimatedAlign(
                  duration: const Duration(milliseconds: 360),
                  curve: Curves.easeOutCubic,
                  alignment: state.swapped
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: FractionallySizedBox(
                    widthFactor: 0.5,
                    heightFactor: 1.0,
                    child: panelA,
                  ),
                ),
                // Panel B
                AnimatedAlign(
                  duration: const Duration(milliseconds: 360),
                  curve: Curves.easeOutCubic,
                  alignment: state.swapped
                      ? Alignment.centerLeft
                      : Alignment.centerRight,
                  child: FractionallySizedBox(
                    widthFactor: 0.5,
                    heightFactor: 1.0,
                    child: panelB,
                  ),
                ),
                // Center divider spanning full height
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: 1,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Theme.of(context).dividerColor,
                        ),
                      ),
                    ),
                  ),
                ),
                Align(alignment: Alignment.center, child: swapButton),
              ],
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: ctrl.resetSet,
                      child: Text(t.resetSet),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      icon: const Icon(Icons.flag),
                      onPressed: () async {
                        await ctrl.endMatch();
                        if (context.mounted) Navigator.pop(context);
                      },
                      label: Text(t.endMatch),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Keep ScorePanel here without Expanded to avoid ParentData issues under AnimatedSwitcher
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
    return GestureDetector(
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
                Opacity(
                  opacity: .5,
                  child: Text(hintText, textAlign: TextAlign.center),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
