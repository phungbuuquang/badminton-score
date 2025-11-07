import 'package:badminton_score/models/set_rules.dart';
import 'package:badminton_score/models/match_record.dart';

class MatchState {
  final String teamA;
  final String teamB;
  final int scoreA;
  final int scoreB;
  final int setIndex;
  final List<(int, int)> displayHistory;
  final List<SetRecord> records;
  final SetRules rules;
  final bool swapped;

  const MatchState({
    required this.teamA,
    required this.teamB,
    this.scoreA = 0,
    this.scoreB = 0,
    this.setIndex = 1,
    this.displayHistory = const [],
    this.records = const [],
    this.rules = const SetRules(target: 21, winBy: 2, cap: 30),
    this.swapped = false,
  });

  MatchState copyWith({
    String? teamA,
    String? teamB,
    int? scoreA,
    int? scoreB,
    int? setIndex,
    List<(int, int)>? displayHistory,
    List<SetRecord>? records,
    SetRules? rules,
    bool? swapped,
  }) => MatchState(
    teamA: teamA ?? this.teamA,
    teamB: teamB ?? this.teamB,
    scoreA: scoreA ?? this.scoreA,
    scoreB: scoreB ?? this.scoreB,
    setIndex: setIndex ?? this.setIndex,
    displayHistory: displayHistory ?? this.displayHistory,
    records: records ?? this.records,
    rules: rules ?? this.rules,
    swapped: swapped ?? this.swapped,
  );
}
