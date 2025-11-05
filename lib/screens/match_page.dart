import 'package:badminton_score/src/generated/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/score_panel.dart';
import '../widgets/set_banner.dart';
import '../providers/match/match_controller.dart';

class MatchArgs {
  final String teamA;
  final String teamB;
  const MatchArgs(this.teamA, this.teamB);
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
      if (ctrl.shouldSuggestEnd) {
        await confirmEndSetDialog();
      }
    }

    void onIncreaseB() async {
      ctrl.increaseB(context);
      if (ctrl.shouldSuggestEnd) {
        await confirmEndSetDialog();
      }
    }

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
            child: Row(
              children: [
                ScorePanel(
                  teamName: state.teamA,
                  score: state.scoreA,
                  onIncrease: onIncreaseA,
                  onDecrease: ctrl.decreaseA,
                  hintText: t.swipeHint,
                ),
                const VerticalDivider(width: 1),
                ScorePanel(
                  teamName: state.teamB,
                  score: state.scoreB,
                  onIncrease: onIncreaseB,
                  onDecrease: ctrl.decreaseB,
                  hintText: t.swipeHint,
                ),
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
