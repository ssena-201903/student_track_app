import 'package:flutter/material.dart';
import 'package:student_track/constants/constants.dart';
import 'package:student_track/widgets/custom_text.dart';

class CoursesPage extends StatelessWidget {
  CoursesPage({super.key});
  // Örnek ders listesi (ileride veritabanından çekilecek)
  final List<String> subjects = [
    "Matematik",
    "Fizik",
    "Kimya",
    "Biyoloji",
    "Türkçe",
    "Tarih",
    "Coğrafya",
    "Felsefe",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: CustomText(text: "Konular", color: Constants.primaryColor, fontWeight: FontWeight.w600, fontSize: 20),
        backgroundColor: Constants.primaryWhiteTone,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: subjects.length,
        itemBuilder: (context, index) {
          final subject = subjects[index];

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: ListTile(
                title: CustomText(text: subject, color: Colors.black87, fontWeight: FontWeight.w600, fontSize: 16),
                trailing: const Icon(Icons.arrow_forward_ios, size: 20,),
                onTap: () {
                  // İleride bu kısımda detay sayfasına yönlendirme olacak
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("$subject konularına gidilecek")),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}