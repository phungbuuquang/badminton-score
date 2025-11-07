class SetRules {
  final int target; // điểm mục tiêu thắng set (vd 21 hoặc 15)
  final int winBy;  // cách biệt tối thiểu để thắng (vd 2)
  final int cap;    // điểm trần (vd 30 hoặc 21)

  const SetRules({required this.target, required this.winBy, required this.cap});

  factory SetRules.defaults() => const SetRules(target: 21, winBy: 2, cap: 30);

  SetRules copyWith({int? target, int? winBy, int? cap}) =>
      SetRules(target: target ?? this.target, winBy: winBy ?? this.winBy, cap: cap ?? this.cap);
}

/// Kiểm tra kết thúc set theo luật tuỳ chỉnh
bool isSetFinishedWithRules(int a, int b, SetRules rules) {
  if (a >= rules.cap || b >= rules.cap) return true; // chạm trần là thắng ngay
  if (a >= rules.target || b >= rules.target) {
    return (a - b).abs() >= rules.winBy;
  }
  return false;
}