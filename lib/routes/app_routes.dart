import 'package:badminton_score/main.dart';
import 'package:badminton_score/models/match_record.dart';
import 'package:badminton_score/screens/history_page.dart';
import 'package:badminton_score/screens/home_page.dart';
import 'package:badminton_score/screens/match_detail_page.dart';
import 'package:badminton_score/screens/match_page.dart';
import 'package:badminton_score/screens/settings_page.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  AppRoutes._(); // private constructor

  /// Dùng cho MaterialApp(onGenerateRoute: AppRoutes.onGenerateRoute)
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
        case AppRouteName.home:
        return MaterialPageRoute(
          builder: (_) => HomePage(),
          settings: settings,
        ); 

      case AppRouteName.match:
        final args = settings.arguments as MatchArgs;
        return MaterialPageRoute(
          builder: (_) => MatchPage(teamA: args.teamA, teamB: args.teamB),
          settings: settings,
        );

      case AppRouteName.matchDetail:
        final rec = settings.arguments as MatchRecord;
        return MaterialPageRoute(
          builder: (_) => MatchDetailPage(record: rec),
          settings: settings,
        );

      case AppRouteName.settings:
        return MaterialPageRoute(
          builder: (_) => SettingsPage(),
          settings: settings,
        );

        case AppRouteName.history:
        return MaterialPageRoute(
          builder: (_) => HistoryPage(),
          settings: settings,
        );


      default:
        // Có thể trả về 1 trang 404 hoặc null theo nhu cầu
        return _unknownRoute(settings);
    }
  }

  static Route<dynamic> _unknownRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Not found')),
        body: Center(child: Text('Route "${settings.name}" không tồn tại')),
      ),
      settings: settings,
    );
  }
}

class AppRouteName {
  static const String home = '/home';
  static const String match = '/match';
  static const String matchDetail = '/match_detail';
  static const String settings = '/settings';
  static const String history = '/history';
}
