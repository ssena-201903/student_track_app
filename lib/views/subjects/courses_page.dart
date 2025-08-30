import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student_track/constants/constants.dart';
import 'package:student_track/providers/user_provider.dart';
import 'package:student_track/views/subjects/subjects_page.dart';
import 'package:student_track/widgets/custom_text.dart';

// Yeni Provider: konuListProvider
final konuListProvider = FutureProvider.autoDispose<List<QueryDocumentSnapshot>>((ref) async {
  final user = ref.watch(userProvider).value;
  final courseId = user?.grade;
  if (courseId == null || courseId.isEmpty) {
    throw Exception('Kurs bilgisi bulunamadı.');
  }

  final snapshot = await FirebaseFirestore.instance
      .collection('konular')
      .doc(courseId)
      .collection('konuListesi')
      .orderBy('code', descending: false)
      .get();

  return snapshot.docs;
});

class CoursesPage extends ConsumerWidget {
  final String studentId;

  const CoursesPage({super.key, required this.studentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final konuListAsync = ref.watch(konuListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Konular")),
      body: konuListAsync.when(
        data: (konuDocs) {
          // Unique dersleri topla
          final uniqueDersler = konuDocs
              .map((doc) => doc['ders'] as String)
              .toSet()
              .toList();

          return StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('students')
                .doc(studentId)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(
                  child: CustomText(
                    text: 'Hata oluştu: ${snapshot.error}',
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                );
              }
              if (!snapshot.hasData || !snapshot.data!.exists) {
                return const Center(
                  child: CustomText(
                    text: 'Veri bulunamadı.',
                    color: Colors.black54,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                );
              }

              final data = snapshot.data!.data() as Map<String, dynamic>;
              final courseBooks = data['courseBooks'] as Map<String, dynamic>? ?? {};
              final topicBookTargets = data['topicBookTargets'] as Map<String, dynamic>? ?? {};

              // Genel ilerleme için sayaç
              int toplamKitap = 0;
              int tamamlananKitap = 0;

              // UI
              return ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  // Genel ilerleme barı
                  Builder(builder: (_) {
                    uniqueDersler.forEach((ders) {
                      final matchingDocs = konuDocs.where((doc) => (doc['ders'] as String) == ders).toList();
                      final courseBookList = courseBooks[ders] as List<dynamic>? ?? [];

                      for (var konuDoc in matchingDocs) {
                        final currentKonuId = konuDoc.id;

                        for (var book in courseBookList) {
                          final bookName = book.toString();
                          String cleanBookName = bookName;
                          if (bookName.startsWith('$ders')) {
                            cleanBookName = bookName.replaceFirst('$ders', '').replaceFirst('_', '');
                          }
                          final targetKey = '${currentKonuId}_$cleanBookName';
                          final completed = topicBookTargets[targetKey]?['completed'] ?? false;

                          toplamKitap++;
                          if (completed) tamamlananKitap++;
                        }
                      }
                    });

                    final genelProgress = toplamKitap > 0 ? tamamlananKitap / toplamKitap : 0.0;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: "Genel İlerleme",
                          color: Constants.primaryBlackTone,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: genelProgress,
                            backgroundColor: Colors.grey.shade300,
                            color: Constants.primaryColor,
                            minHeight: 12,
                          ),
                        ),
                        const SizedBox(height: 6),
                        CustomText(
                          text: "%${(genelProgress * 100).toStringAsFixed(0)} tamamlandı",
                          color: Constants.primaryBlackTone,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                        const SizedBox(height: 20),
                      ],
                    );
                  }),

                  // Ders kartları
                  ...uniqueDersler.map((ders) {
                    final matchingDocs = konuDocs.where((doc) => (doc['ders'] as String) == ders).toList();
                    final konuId = matchingDocs.isNotEmpty ? matchingDocs.first.id : null;

                    int totalBooks = 0;
                    int completedBooks = 0;

                    final courseBookList = courseBooks[ders] as List<dynamic>? ?? [];
                    for (var konuDoc in matchingDocs) {
                      final currentKonuId = konuDoc.id;

                      for (var book in courseBookList) {
                        final bookName = book.toString();
                        String cleanBookName = bookName;
                        if (bookName.startsWith('$ders')) {
                          cleanBookName = bookName.replaceFirst('$ders', '').replaceFirst('_', '');
                        }
                        final targetKey = '${currentKonuId}_$cleanBookName';
                        final completed = topicBookTargets[targetKey]?['completed'] ?? false;

                        totalBooks++;
                        if (completed) completedBooks++;
                      }
                    }

                    final progressValue = totalBooks > 0 ? completedBooks / totalBooks : 0.0;

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        title: CustomText(
                          text: ders,
                          color: Constants.primaryBlackTone,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 60,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: progressValue,
                                  backgroundColor: Colors.grey.shade300,
                                  color: Constants.primaryColor,
                                  minHeight: 6,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            CustomText(
                              text: "${(progressValue * 100).toStringAsFixed(0)}%",
                              color: Constants.primaryBlackTone,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                            const SizedBox(width: 6),
                            const Icon(Icons.arrow_forward_ios, size: 20),
                          ],
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => SubjectsPage(
                                title: ders,
                                studentId: studentId,
                                konuId: konuId,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }).toList(),
                ],
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: CustomText(
            text: 'Veri yüklenemedi: $error',
            color: Colors.red,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
