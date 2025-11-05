import 'package:badminton_score/models/match_record.dart';
import 'package:hive/hive.dart';

class HiveAdapterInitialize {
  static initialize()async{
    Hive.registerAdapter(SetRecordAdapter());
    Hive.registerAdapter(MatchRecordAdapter());
    await Hive.openBox<MatchRecord>('matches');
    await Hive.openBox('prefs');
  }
}