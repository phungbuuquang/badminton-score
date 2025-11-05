import 'package:hive/hive.dart';

// (not used for codegen; placeholder to avoid analyzer warnings if you add generator later)

class MatchRecord {
  final String teamA;
  final String teamB;
  final List<SetRecord> sets;
  final DateTime createdAt;

  const MatchRecord({
    required this.teamA,
    required this.teamB,
    required this.sets,
    required this.createdAt,
  });

  int get setsWonA => sets.where((s) => s.scoreA > s.scoreB).length;
  int get setsWonB => sets.length - setsWonA;
}

class SetRecord {
  final int scoreA;
  final int scoreB;
  const SetRecord({required this.scoreA, required this.scoreB});
}

// ---- Hive Adapters (manual) ----
class SetRecordAdapter extends TypeAdapter<SetRecord> {
  @override
  final int typeId = 1;

  @override
  SetRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (int i = 0; i < numOfFields; i++) {
      fields[reader.readByte()] = reader.read();
    }
    return SetRecord(
      scoreA: fields[0] as int,
      scoreB: fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, SetRecord obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.scoreA)
      ..writeByte(1)
      ..write(obj.scoreB);
  }
}

class MatchRecordAdapter extends TypeAdapter<MatchRecord> {
  @override
  final int typeId = 2;

  @override
  MatchRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (int i = 0; i < numOfFields; i++) {
      fields[reader.readByte()] = reader.read();
    }
    return MatchRecord(
      teamA: fields[0] as String,
      teamB: fields[1] as String,
      sets: (fields[2] as List).cast<SetRecord>(),
      createdAt: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, MatchRecord obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.teamA)
      ..writeByte(1)
      ..write(obj.teamB)
      ..writeByte(2)
      ..write(obj.sets)
      ..writeByte(3)
      ..write(obj.createdAt);
  }
}
