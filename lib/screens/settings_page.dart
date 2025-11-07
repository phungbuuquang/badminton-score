import 'package:badminton_score/models/set_rules.dart';
import 'package:badminton_score/src/generated/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late final TextEditingController _target;
  late final TextEditingController _winBy;
  late final TextEditingController _cap;

  @override
  void initState() {
    super.initState();
    final prefs = Hive.box('prefs');
    final map = (prefs.get('rules') as Map?)?.cast<String,int>();
    final rules = map == null
        ? SetRules.defaults()
        : SetRules(target: map['target'] ?? 21, winBy: map['winBy'] ?? 2, cap: map['cap'] ?? 30);

    _target = TextEditingController(text: rules.target.toString());
    _winBy  = TextEditingController(text: rules.winBy.toString());
    _cap    = TextEditingController(text: rules.cap.toString());
  }

  @override
  void dispose() {
    _target.dispose();
    _winBy.dispose();
    _cap.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final t = int.tryParse(_target.text) ?? 21;
    final w = int.tryParse(_winBy.text)  ?? 2;
    final c = int.tryParse(_cap.text)    ?? 30;

    if (t < 1 || w < 1 || c < t) {
      final loc = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.invalidRules)),
      );
      return;
    }

    final prefs = Hive.box('prefs');
    await prefs.put('rules', {'target': t, 'winBy': w, 'cap': c});
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(t.rules)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(t.rulesDescription),
          const SizedBox(height: 12),
          TextField(
            controller: _target,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: t.targetPoints),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _winBy,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: t.winBy),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _cap,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: t.capAt),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: _save,
            icon: const Icon(Icons.save),
            label: Text(t.save),
          ),
        ],
      ),
    );
  }
}
