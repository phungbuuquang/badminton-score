import 'package:badminton_score/src/generated/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import '../modesl/models.dart';

class MatchDetailPage extends StatelessWidget {
  final MatchRecord record;
  const MatchDetailPage({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(t.vsFormat(record.teamA, record.teamB))),
      body: ListView.separated(
        itemCount: record.sets.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, i) {
          final set = record.sets[i];
          return ListTile(
            leading: CircleAvatar(child: Text('${i + 1}')),
            title: Text('${record.teamA} ${set.scoreA} : ${set.scoreB} ${record.teamB}'),
          );
        },
      ),
    );
  }
}
