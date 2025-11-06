import 'dart:async';

import 'package:badminton_score/models/match_record.dart';
import 'package:badminton_score/models/set_rules.dart';
import 'package:badminton_score/providers/match/match_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

/// Provider lấy luật từ Hive (box 'prefs', key 'rules')
final rulesProvider = Provider<SetRules>((ref) {
  final prefs = Hive.box('prefs');
  final map = (prefs.get('rules') as Map?)?.cast<String, int>();
  if (map == null) return SetRules.defaults();
  final t = map['target'] ?? 21;
  final w = map['winBy']  ?? 2;
  final c = map['cap']    ?? 30;
  return SetRules(target: t, winBy: w, cap: c);
});

/// StreamProvider phát SetRules mỗi khi key 'rules' trong Hive thay đổi
final rulesStreamProvider = StreamProvider<SetRules>((ref) {
  final box = Hive.box('prefs');
  final controller = StreamController<SetRules>();

  SetRules readRules() {
    final map = (box.get('rules') as Map?)?.cast<String, int>();
    if (map == null) return SetRules.defaults();
    return SetRules(
      target: map['target'] ?? 21,
      winBy : map['winBy']  ?? 2,
      cap   : map['cap']    ?? 30,
    );
  }

  // emit lần đầu
  controller.add(readRules());

  // emit khi có thay đổi trên key 'rules'
  final sub = box.watch(key: 'rules').listen((_) {
    controller.add(readRules());
  });

  ref.onDispose(() {
    sub.cancel();
    controller.close();
  });

  return controller.stream;
});

class MatchController extends StateNotifier<MatchState> {
  final Box<MatchRecord> box;
  MatchController(this.box, String teamA, String teamB, SetRules rules)
      : super(MatchState(teamA: teamA, teamB: teamB, rules: rules));

  // Cho phép provider bên ngoài cập nhật luật ngay lập tức
  void applyRules(SetRules next) {
    if (state.rules != next) {
      state = state.copyWith(rules: next);
    }
  }

  void increaseA(BuildContext context) {
    state = state.copyWith(scoreA: state.scoreA + 1);
  }
  void decreaseA() { if (state.scoreA > 0) state = state.copyWith(scoreA: state.scoreA - 1); }
  void increaseB(BuildContext context) {
    state = state.copyWith(scoreB: state.scoreB + 1);
  }
  void decreaseB() { if (state.scoreB > 0) state = state.copyWith(scoreB: state.scoreB - 1); }
  void resetSet() { state = state.copyWith(scoreA: 0, scoreB: 0); }

  bool get shouldSuggestEnd =>
      isSetFinishedWithRules(state.scoreA, state.scoreB, state.rules);

  Future<void> confirmEndSet() async {
    final a = state.scoreA, b = state.scoreB;
    state = state.copyWith(
      displayHistory: [...state.displayHistory, (a,b)],
      records: [...state.records, SetRecord(scoreA: a, scoreB: b)],
      scoreA: 0,
      scoreB: 0,
      setIndex: state.setIndex + 1,
    );
  }

  Future<void> endMatch() async {
    if (state.records.isEmpty && state.scoreA==0 && state.scoreB==0) return;
    final includeCurrent = (state.scoreA>0 || state.scoreB>0);
    final sets = [
      ...state.records,
      if (includeCurrent) SetRecord(scoreA: state.scoreA, scoreB: state.scoreB),
    ];
    await box.add(MatchRecord(
      teamA: state.teamA,
      teamB: state.teamB,
      sets: sets,
      createdAt: DateTime.now(),
    ));
  }
}

final matchControllerProvider = StateNotifierProvider.family<MatchController, MatchState, (String, String)>(
  (ref, args) {
     final box = Hive.box<MatchRecord>('matches');

    // Lấy luật hiện tại (nếu stream chưa có data, dùng defaults)
    final currentRules = ref.read(rulesStreamProvider).maybeWhen(
      data: (r) => r,
      orElse: () => SetRules.defaults(),
    );

    final controller = MatchController(box, args.$1, args.$2, currentRules);

    // Lắng nghe stream rules và apply ngay cho controller
    ref.listen<AsyncValue<SetRules>>(rulesStreamProvider, (prev, next) {
      next.whenData(controller.applyRules);
    });

    return controller;
  },
);