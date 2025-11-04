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
  String get history => 'Lịch sử';

  @override
  String get teamAName => 'Tên đội A';

  @override
  String get teamBName => 'Tên đội B';

  @override
  String get startMatch => 'Bắt đầu trận';

  @override
  String get endSetTitle => 'Kết thúc set?';

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
  String get keepup => 'Tiếp tục';

  @override
  String get endSet => 'Kết thúc set';

  @override
  String get resetSet => 'Làm lại set';

  @override
  String get endMatch => 'Kết thúc trận';

  @override
  String get noMatchesYet => 'Chưa có trận nào';

  @override
  String setLabel(Object index) {
    return 'Set $index';
  }

  @override
  String get swipeHint => 'Vuốt ↑ để cộng • Vuốt ↓ để trừ';

  @override
  String vsFormat(Object teamA, Object teamB) {
    return '$teamA vs $teamB';
  }

  @override
  String setsCount(Object count) {
    return 'Số set: $count';
  }

  @override
  String resultSets(Object a, Object b) {
    return 'Kết quả: $a - $b';
  }
}
