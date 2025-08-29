import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student_track/constants/constants.dart';
import 'package:student_track/providers/user_provider.dart';
import 'package:student_track/views/login/login_page.dart';
import 'package:student_track/views/main_shell.dart';
import 'package:student_track/widgets/custom_text.dart';

class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (user) {
        if (user != null) {
          return const MainShell();
        } else {
          return const LoginPage();
        }
      },
      loading: () => Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Constants.primaryColor),
              ),
              const SizedBox(height: 16),
              CustomText(text: "Yükleniyor...", color: Constants.primaryColor, fontWeight: FontWeight.w600, fontSize: 16),
            ],
          ),
        ),
      ),
      error: (e, _) => Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('Bağlantı hatası: $e'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Yeniden deneme
                  ref.invalidate(authStateProvider);
                },
                child: const Text('Yeniden Dene'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}