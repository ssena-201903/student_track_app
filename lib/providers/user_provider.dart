import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student_track/features/auth/data/auth_repository.dart';
import 'package:student_track/models/model_user.dart';

class UserNotifier extends AsyncNotifier<ModelUser> {
  @override
  Future<ModelUser> build() async {
    final authUser = FirebaseAuth.instance.currentUser;
    
    if (authUser != null) {
      try {
        final userData = await FirebaseFirestore.instance
            .collection('students')
            .doc(authUser.uid)
            .get();
        if (userData.exists && userData.data() != null) {
          return ModelUser.fromFirestore(userData.data()!, authUser.uid);
        }
      } catch (e) {
        return ModelUser.sample();
      }
    }
    return ModelUser.sample();
  }

  Future<void> updateField(String key, String value) async {
    final currentState = await future; // Güncel state'i al
    final newState = switch (key) {
      'name' => currentState.copyWith(name: value),
      'school' => currentState.copyWith(school: value),
      'grade' => currentState.copyWith(grade: value),
      'phone' => currentState.copyWith(phone: value),
      'weeklyStudy' => currentState.copyWith(weeklyStudy: value),
      _ => currentState,
    };

    state = AsyncValue.data(newState);

    if (newState.id != '0') {
      await FirebaseFirestore.instance
          .collection('students')
          .doc(newState.id)
          .update({key: value});
    }
  }
}

final userProvider = AsyncNotifierProvider<UserNotifier, ModelUser>(() {
  return UserNotifier();
});

final authStateProvider = StreamProvider<User?>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return repo.authStateChanges;
});