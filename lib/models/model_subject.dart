class SubjectStat {
  final int correct;
  final int wrong;
  final int blank;
  final int? minutes; // o derse ayrılan süre (opsiyonel)

  const SubjectStat({
    required this.correct,
    required this.wrong,
    required this.blank,
    this.minutes,
  });

  /// Net hesabı (4 yanlış = 1 doğru kaybı)
  double net({double penaltyRate = 4}) => correct - wrong / penaltyRate;

  int total() => correct + wrong + blank;
}