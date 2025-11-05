import 'package:badminton_score/routes/app_routes.dart';
import 'package:badminton_score/screens/match_page.dart';
import 'package:badminton_score/src/generated/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import '../main.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _a = TextEditingController(text: 'Team A');
  final _b = TextEditingController(text: 'Team B');

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, AppRouteName.history),
            icon: const Icon(Icons.history),
            tooltip: t.history,
          ),
          IconButton(
            onPressed: () => Navigator.pushNamed(context, AppRouteName.settings),
            icon: const Icon(Icons.tune),
            tooltip: t.rules,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _a,
              decoration: InputDecoration(labelText: t.teamAName),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _b,
              decoration: InputDecoration(labelText: t.teamBName),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                icon: const Icon(Icons.sports_tennis),
                label: Text(t.startMatch),
                onPressed: () {
                  final a = _a.text.trim().isEmpty ? 'Team A' : _a.text.trim();
                  final b = _b.text.trim().isEmpty ? 'Team B' : _b.text.trim();
                  Navigator.pushNamed(
                    context,
                    '/match',
                    arguments: MatchArgs(a, b),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
