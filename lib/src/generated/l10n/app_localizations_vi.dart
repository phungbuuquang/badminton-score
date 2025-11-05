// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'Ghi điểm Cầu lông';

  @override
  String get capAt => '封頂分';

  @override
  String get endMatch => 'Kết thúc trận';

  @override
  String get endSet => 'Kết thúc set';

  @override
  String endSetContent(
    Object scoreA,
    Object scoreB,
    Object teamA,
    Object teamB,
  ) {
    return 'Xác nhận kết quả set: $teamA $scoreA : $scoreB $teamB';
  }

  @override
  String get endSetTitle => 'Kết thúc set?';

  @override
  String get history => 'Lịch sử';

  @override
  String get invalidRules => '無效規則：目標≥1、分差≥1、封頂≥目標。';

  @override
  String get keepup => 'Tiếp tục';

  @override
  String get noMatchesYet => 'Chưa có trận nào';

  @override
  String get resetSet => 'Làm lại set';

  @override
  String resultSets(Object a, Object b) {
    return 'Kết quả: $a - $b';
  }

  @override
  String get rules => '計分規則';

  @override
  String get rulesDescription => '自訂目標分、最小分差與封頂分。';

  @override
  String get save => '儲存';

  @override
  String setLabel(Object index) {
    return 'Set $index';
  }

  @override
  String setsCount(Object count) {
    return 'Số set: $count';
  }

  @override
  String get startMatch => 'Bắt đầu trận';

  @override
  String get swipeHint => 'Vuốt ↑ để cộng • Vuốt ↓ để trừ';

  @override
  String get targetPoints => '目標分';

  @override
  String get teamAName => 'Tên đội A';

  @override
  String get teamBName => 'Tên đội B';

  @override
  String vsFormat(Object teamA, Object teamB) {
    return '$teamA vs $teamB';
  }

  @override
  String get winBy => '最小分差';
}
