import 'package:student_track/models/model_subject.dart';

class Trial {
  final String id;
  final String title;
  final String publisher;   // Yayınevi
  final String category;    // TYT, AYT
  final DateTime date;
  final Map<String, SubjectStat> subjects; // ders adı -> istatistik
  final String note;

  Trial({
    required this.id,
    required this.title,
    required this.publisher,
    required this.category,
    required this.date,
    required this.subjects,
    this.note = '',
  });

  /// 4 yanlış 1 doğruyu götürür varsayımı ile toplam net
  double get totalNet {
    const penalty = 4.0;
    double sum = 0;
    for (final s in subjects.values) {
      sum += s.net(penaltyRate: penalty);
    }
    return double.parse(sum.toStringAsFixed(2));
  }

  int get totalCorrect => subjects.values.fold(0, (p, s) => p + s.correct);
  int get totalWrong   => subjects.values.fold(0, (p, s) => p + s.wrong);
  int get totalBlank   => subjects.values.fold(0, (p, s) => p + s.blank);
}