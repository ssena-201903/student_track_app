// profile_page.dart
import 'package:flutter/material.dart';
import 'package:student_track/constants/constants.dart';
import 'package:student_track/widgets/custom_text.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CustomText(
              text: "Profilim",
              color: Constants.primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 50,
              backgroundColor: Constants.primaryColor,
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 16),
            _buildInfoTile(title: "İsim", value: "Safiye Yılmaz"),
            _buildInfoTile(title: "Okul", value: "İstanbul Lisesi"),
            _buildInfoTile(title: "Sınıf", value: "11. Sınıf"),
            _buildInfoTile(title: "Yaş", value: "16"),
            _buildInfoTile(title: "Telefon", value: "+90 555 123 45 67"),
            _buildInfoTile(title: "E-posta", value: "safiye@example.com"),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile({required String title, required String value}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: _getIconForField(title),
        title: Text(title),
        subtitle: Text(value),
      ),
    );
  }

  Icon _getIconForField(String fieldName) {
    switch (fieldName.toLowerCase()) {
      case "isim":
        return const Icon(Icons.person);
      case "okul":
        return const Icon(Icons.school);
      case "sınıf":
        return const Icon(Icons.class_);
      case "yaş":
        return const Icon(Icons.cake);
      case "telefon":
        return const Icon(Icons.phone);
      case "e-posta":
        return const Icon(Icons.email);
      default:
        return const Icon(Icons.info_outline);
    }
  }
}
