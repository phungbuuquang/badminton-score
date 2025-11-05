import 'package:badminton_score/models/match_record.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/rules.dart';
import 'package:hive/hive.dart';

class MatchState {
  final String teamA;
  final String teamB;
  final int scoreA;
  final int scoreB;
  final int setIndex;
  final List<(int, int)> displayHistory; // for banner
  final List<SetRecord> records; // persisted

  const MatchState({
    required this.teamA,
    required this.teamB,
    this.scoreA = 0,
    this.scoreB = 0,
    this.setIndex = 1,
    this.displayHistory = const [],
    this.records = const [],
  });

  MatchState copyWith({
    String? teamA,
    String? teamB,
    int? scoreA,
    int? scoreB,
    int? setIndex,
    List<(int, int)>? displayHistory,
    List<SetRecord>? records,
  }) => MatchState(
    teamA: teamA ?? this.teamA,
    teamB: teamB ?? this.teamB,
    scoreA: scoreA ?? this.scoreA,
    scoreB: scoreB ?? this.scoreB,
    setIndex: setIndex ?? this.setIndex,
    displayHistory: displayHistory ?? this.displayHistory,
    records: records ?? this.records,
  );
}

class MatchController extends StateNotifier<MatchState> {
  final Box<MatchRecord> box;
  MatchController(this.box, String teamA, String teamB)
    : super(MatchState(teamA: teamA, teamB: teamB));

  void increaseA(BuildContext context) {
    final a = state.scoreA + 1;
    state = state.copyWith(scoreA: a);
    _maybeEndSet(context);
  }

  void decreaseA() {
    if (state.scoreA == 0) return;
    state = state.copyWith(scoreA: state.scoreA - 1);
  }

  void increaseB(BuildContext context) {
    final b = state.scoreB + 1;
    state = state.copyWith(scoreB: b);
    _maybeEndSet(context);
  }

  void decreaseB() {
    if (state.scoreB == 0) return;
    state = state.copyWith(scoreB: state.scoreB - 1);
  }

  void resetSet() {
    state = state.copyWith(scoreA: 0, scoreB: 0);
  }

  Future<void> _maybeEndSet(BuildContext context) async {
    final a = state.scoreA;
    final b = state.scoreB;
    if (!isSetFinished(a, b)) return;

    final loc = Localizations.localeOf(context);
    // showDialog needs strings provided outside (we'll pass them from UI using AppLocalizations)
    // To keep controller UI-agnostic, confirmation is triggered by UI.
  }

  Future<void> confirmEndSet() async {
    final a = state.scoreA;
    final b = state.scoreB;
    final his = [...state.displayHistory, (a, b)];
    final recs = [...state.records, SetRecord(scoreA: a, scoreB: b)];
    state = state.copyWith(
      displayHistory: his,
      records: recs,
      scoreA: 0,
      scoreB: 0,
      setIndex: state.setIndex + 1,
    );
  }

  Future<void> endMatch() async {
    if (state.records.isEmpty && state.scoreA == 0 && state.scoreB == 0) return;
    final includeCurrent = (state.scoreA > 0 || state.scoreB > 0);
    final setList = [
      ...state.records,
      if (includeCurrent) SetRecord(scoreA: state.scoreA, scoreB: state.scoreB),
    ];
    final rec = MatchRecord(
      teamA: state.teamA,
      teamB: state.teamB,
      sets: setList,
      createdAt: DateTime.now(),
    );
    await box.add(rec);
  }
}

final matchControllerProvider =
    StateNotifierProvider.family<MatchController, MatchState, (String, String)>(
      (ref, args) {
        final box = Hive.box<MatchRecord>('matches');
        return MatchController(box, args.$1, args.$2);
      },
    );
