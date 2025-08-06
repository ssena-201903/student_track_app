import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:student_track/constants/constants.dart';
import 'package:student_track/widgets/custom_text.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController emailTf;
  late TextEditingController passwordTf;

  // global form state
  final _formKey = GlobalKey<FormState>();

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
          // eğer ekran genişliği yükseklikten fazlaysa yataydadır
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
            color: Constants.lightPrimaryTone,
            fontWeight: FontWeight.w400,
            fontSize: (deviceWidth * 0.035).clamp(12.0, 18.0),
          ),
          const SizedBox(height: 24),

          // E-Posta Alanı
          TextFormField(
            controller: emailTf,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "E-posta boş olamaz";
              }
              if (!RegExp(r"^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(value)) {
                return "Geçerli bir e-posta girin";
              }
              return null;
            },
            decoration: InputDecoration(
              label: CustomText(
                text: "E-posta",
                color: Constants.lightPrimaryTone,
                fontWeight: FontWeight.normal,
                fontSize: (deviceWidth * 0.032).clamp(12.0, 16.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Constants.lightPrimaryTone),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Constants.primaryColor),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Şifre Alanı
          TextFormField(
            controller: passwordTf,
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Şifre boş olamaz";
              }
              if (value.length < 6) {
                return "Şifre en az 6 karakter olmalı";
              }
              return null;
            },
            decoration: InputDecoration(
              label: CustomText(
                text: "Şifre",
                color: Constants.lightPrimaryTone,
                fontWeight: FontWeight.normal,
                fontSize: (deviceWidth * 0.032).clamp(12.0, 16.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Constants.lightPrimaryTone),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Constants.primaryColor),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Giriş Butonu
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
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Her şey doğruysa giriş işlemleri yapılabilir
                  debugPrint(
                    "Giriş başarılı: ${emailTf.text}, ${passwordTf.text}",
                  );
                }
              },
              child: const Text(
                "Giriş Yap",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
