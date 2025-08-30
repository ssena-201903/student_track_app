import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student_track/constants/constants.dart';
import 'package:student_track/views/subjects/courses_page.dart'; // konuListProvider burada
import 'package:student_track/widgets/custom_text.dart';

class SubjectsPage extends ConsumerWidget {
  final String title;
  final String studentId;
  final String? konuId; // nullable

  const SubjectsPage({
    super.key,
    required this.title,
    required this.studentId,
    required this.konuId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final konuListAsync = ref.watch(konuListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Constants.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: konuListAsync.when(
        data: (konuDocs) {
          // Seçilen derse ait konuları filtrele
          final filteredKonular = konuDocs
              .where((doc) => (doc['ders'] as String) == title)
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
              final courseBooks =
                  data['courseBooks'] as Map<String, dynamic>? ?? {};
              final topicBookTargets =
                  data['topicBookTargets'] as Map<String, dynamic>? ?? {};

              return ListView(
                padding: const EdgeInsets.all(8),
                children: filteredKonular.map((konuDoc) {
                  final konuName = konuDoc['konu'] as String;
                  final currentKonuId = konuDoc.id;

                  // Kitapları topla
                  final books = <BookItem>[];
                  if (courseBooks.containsKey(title)) {
                    final courseBookList =
                        courseBooks[title] as List<dynamic>? ?? [];
                    for (var book in courseBookList) {
                      final bookName = book.toString();
                      String cleanBookName = bookName;
                      if (bookName.startsWith('$title')) {
                        cleanBookName = bookName
                            .replaceFirst('$title', '')
                            .replaceFirst('_', '');
                      }
                      final targetKey = '${currentKonuId}_$cleanBookName';
                      final completed =
                          topicBookTargets[targetKey]?['completed'] ?? false;
                      books.add(
                          BookItem(name: cleanBookName, isRead: completed));
                    }
                  }

                  final progressValue = books.isNotEmpty
                      ? books.where((b) => b.isRead).length / books.length
                      : 0.0;

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ExpansionTile(
                      title: Row(
                        children: [
                          Expanded(
                            child: CustomText(
                              text: konuName,
                              color: Constants.primaryBlackTone,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 10),
                          SizedBox(
                            width: 80,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
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
                            text:
                                "${(progressValue * 100).toStringAsFixed(0)}%",
                            color: Constants.primaryBlackTone,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ],
                      ),
                      children: books.map((book) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 4),
                          child: Row(
                            children: [
                              Expanded(
                                child: CustomText(
                                  text: book.name,
                                  color: Constants.primaryBlackTone,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14,
                                ),
                              ),
                              CustomText(
                                text: book.isRead
                                    ? 'Tamamlandı'
                                    : 'Devam Ediyor',
                                color: book.isRead
                                    ? Constants.primaryColor
                                    : Colors.black54,
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  );
                }).toList(),
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

class BookItem {
  final String name;
  final bool isRead;

  BookItem({required this.name, this.isRead = false});
}
