import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:student_track/constants/constants.dart';
import 'package:student_track/features/auth/data/auth_repository.dart';
import 'package:student_track/widgets/custom_text.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  late TextEditingController emailTf;
  late TextEditingController passwordTf;
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    emailTf = TextEditingController();
    passwordTf = TextEditingController();
  }

  @override
  void dispose() {
    emailTf.dispose();
    passwordTf.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Eğer ekran genişliği yükseklikten fazlaysa yataydadır
          final isLandscape = constraints.maxWidth > constraints.maxHeight;
          final contentWidth = isLandscape
              ? 500.0
              : constraints.maxWidth * 0.85;

          return Center(
            child: isLandscape
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Lottie.asset(
                            "assets/animations/login_animation.json",
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: contentWidth,
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: _buildLoginForm(deviceWidth),
                        ),
                      ),
                    ],
                  )
                : SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 40),
                        Lottie.asset(
                          "assets/animations/login_animation.json",
                          width: constraints.maxWidth * 0.7,
                          height: constraints.maxHeight * 0.3,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: SizedBox(
                            width: contentWidth,
                            child: _buildLoginForm(deviceWidth),
                          ),
                        ),
                      ],
                    ),
                  ),
          );
        },
      ),
    );
  }

  Widget _buildLoginForm(double deviceWidth) {
    final authRepo = ref.read(authRepositoryProvider);

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomText(
            text: "Hoşgeldin!",
            color: Constants.primaryColor,
            fontWeight: FontWeight.normal,
            fontSize: (deviceWidth * 0.09).clamp(20.0, 32.0),
            fontFamily: "Caprasimo",
          ),
          const SizedBox(height: 6),
          CustomText(
            text: "Lütfen giriş için bilgilerinizi giriniz",
            color: Constants.primaryColor,
            fontWeight: FontWeight.w400,
            fontSize: (deviceWidth * 0.035).clamp(12.0, 18.0),
          ),
          const SizedBox(height: 24),

          // E-posta
          TextFormField(
            controller: emailTf,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "E-posta boş olamaz";
              }
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                return "Geçerli bir e-posta giriniz";
              }
              return null;
            },
            decoration: const InputDecoration(
              labelText: "E-posta",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),

          // Şifre
          TextFormField(
            controller: passwordTf,
            obscureText: _obscureText,
            validator: (value) =>
                value == null || value.length < 6 ? "Şifre en az 6 karakter" : null,
            decoration: InputDecoration(
              labelText: "Şifre",
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Giriş Yap Butonu
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Constants.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: isLoading
                  ? null
                  : () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() => isLoading = true);
                        try {
                          await authRepo.signIn(
                            email: emailTf.text.trim(),
                            password: passwordTf.text.trim(),
                          );
                          // AuthWrapper yönlendirecek
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(_handleAuthError(e))),
                          );
                        } finally {
                          if (mounted) setState(() => isLoading = false);
                        }
                      }
                    },
              child: Text(
                isLoading ? "Giriş Yapılıyor..." : "Giriş Yap",
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _handleAuthError(dynamic e) {
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'user-not-found':
          return 'Kullanıcı bulunamadı.';
        case 'wrong-password':
          return 'Yanlış şifre girdiniz.';
        case 'invalid-email':
          return 'Geçersiz e-posta adresi.';
        default:
          return 'Bir hata oluştu: ${e.message}';
      }
    }
    return 'Bilinmeyen bir hata oluştu.';
  }
}