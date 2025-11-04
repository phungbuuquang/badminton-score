bool isSetFinished(int a, int b) {
  if (a >= 30 || b >= 30) return true; // 30 cap
  if (a >= 21 || b >= 21) {
    return (a - b).abs() >= 2; // win by 2
  }
  return false;
}
