import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student_track/providers/user_provider.dart';

final subjectListProvider = FutureProvider.autoDispose<List<QueryDocumentSnapshot>>((ref) async {
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