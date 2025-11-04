import 'package:hive/hive.dart';
import '../modesl/models.dart';

class MatchRepository {
  final Box<MatchRecord> box;
  MatchRepository(this.box);

  Future<void> add(MatchRecord r) async {
    await box.add(r);
  }

  List<MatchRecord> allDesc() {
    final list = box.values.toList();
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }
}
