// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Badminton Score';

  @override
  String get capAt => 'Điểm trần';

  @override
  String get endMatch => 'End Match';

  @override
  String get endSet => 'End Set';

  @override
  String endSetContent(
    Object scoreA,
    Object scoreB,
    Object teamA,
    Object teamB,
  ) {
    return 'Confirm set result: $teamA $scoreA : $scoreB $teamB';
  }

  @override
  String get endSetTitle => 'End Set?';

  @override
  String get history => 'History';

  @override
  String get invalidRules =>
      'Luật không hợp lệ: mục tiêu ≥1, cách biệt ≥1, trần ≥ mục tiêu.';

  @override
  String get keepup => 'Continue';

  @override
  String get noMatchesYet => 'No matches yet';

  @override
  String get resetSet => 'Reset Set';

  @override
  String resultSets(Object a, Object b) {
    return 'Result: $a - $b';
  }

  @override
  String get rules => 'Luật tính điểm';

  @override
  String get rulesDescription =>
      'Tuỳ chỉnh điểm mục tiêu, cách biệt tối thiểu và điểm trần.';

  @override
  String get save => 'Lưu';

  @override
  String setLabel(Object index) {
    return 'Set $index';
  }

  @override
  String setsCount(Object count) {
    return 'Sets: $count';
  }

  @override
  String get startMatch => 'Start Match';

  @override
  String get swipeHint => 'Swipe ↑ to add • Swipe ↓ to subtract';

  @override
  String get targetPoints => 'Điểm mục tiêu';

  @override
  String get teamAName => 'Team A name';

  @override
  String get teamBName => 'Team B name';

  @override
  String vsFormat(Object teamA, Object teamB) {
    return '$teamA vs $teamB';
  }

  @override
  String get winBy => 'Cách biệt tối thiểu';
}
