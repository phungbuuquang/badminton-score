import 'package:badminton_score/src/generated/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'theme/app_theme.dart';
import 'screens/home_page.dart';
import 'screens/history_page.dart';
import 'screens/match_detail_page.dart';
import 'screens/match_page.dart';
import 'models/match_record.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(SetRecordAdapter());
  Hive.registerAdapter(MatchRecordAdapter());
  await Hive.openBox<MatchRecord>('matches');
  runApp(const ProviderScope(child: BadmintonApp()));
}

class BadmintonApp extends StatelessWidget {
  const BadmintonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Badminton Score',
      theme: buildDarkTheme(),
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('vi'),
        Locale('zh', 'CN'),
        Locale('zh', 'TW'),
      ],
      initialRoute: '/',
      routes: {
        '/': (_) => const HomePage(),
        '/history': (_) => const HistoryPage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/match') {
          final args = settings.arguments as MatchArgs;
          return MaterialPageRoute(
            builder: (_) => MatchPage(teamA: args.teamA, teamB: args.teamB),
          );
        }
        if (settings.name == '/match_detail') {
          final rec = settings.arguments as MatchRecord;
          return MaterialPageRoute(
            builder: (_) => MatchDetailPage(record: rec),
          );
        }
        return null;
      },
    );
  }
}

class MatchArgs {
  final String teamA;
  final String teamB;
  const MatchArgs(this.teamA, this.teamB);
}
