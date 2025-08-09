import 'package:flutter/material.dart';
import 'package:student_track/constants/constants.dart';
import 'package:student_track/views/subjects/subjects_page.dart';
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
      appBar: AppBar(
        title: Text("Konular"),
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
                title: CustomText(text: subject, color: Constants.primaryBlackTone, fontWeight: FontWeight.w600, fontSize: 16),
                trailing: const Icon(Icons.arrow_forward_ios, size: 20,),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => SubjectsPage(title: subject,)));
                },
              ),
            ),
          );
        },
      ),
    );
  }
}