import 'package:badminton_score/models/match_record.dart';
import 'package:badminton_score/src/generated/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final box = Hive.box<MatchRecord>('matches');
    return Scaffold(
      appBar: AppBar(title: Text(t.history)),
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box<MatchRecord> b, _) {
          final list = b.values.toList();
          list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          if (list.isEmpty) return Center(child: Text(t.noMatchesYet));
          return ListView.separated(
            itemCount: list.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, i) {
              final m = list[i];
              final sets = m.sets.length;
              final score = t.resultSets(m.setsWonA, m.setsWonB);
              return ListTile(
                title: Text(t.vsFormat(m.teamA, m.teamB)),
                subtitle: Text(
                  '${t.setsCount(sets)}  •  $score  •  ${m.createdAt.toLocal()}',
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () =>
                    Navigator.pushNamed(context, '/match_detail', arguments: m),
              );
            },
          );
        },
      ),
    );
  }
}
