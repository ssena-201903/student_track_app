import 'package:flutter/material.dart';
import 'package:student_track/constants/constants.dart';
import 'package:student_track/views/subjects/subjects_page.dart';
import 'package:student_track/widgets/custom_text.dart';

class CoursesPage extends StatelessWidget {
  CoursesPage({super.key});

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

  final List<double> progress = [0.75, 0.4, 0.2, 0.9, 0.6, 0.3, 0.5, 0.1];

  double getTotalProgress() {
    if (progress.isEmpty) return 0.0;
    double total = 0;
    for (var p in progress) {
      total += p;
    }
    return total / progress.length; // Ortalama
  }

  @override
  Widget build(BuildContext context) {
    final totalProgress = getTotalProgress();

    return Scaffold(
      appBar: AppBar(title: Text("Konular")),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Canlı tasarımlı toplam ilerleme bölümü
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                // Küçük dairesel ilerleme göstergesi
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 48,
                      height: 48,
                      child: CircularProgressIndicator(
                        value: totalProgress,
                        strokeWidth: 5,
                        backgroundColor: Colors.grey.shade300,
                        color: Constants.primaryColor,
                      ),
                    ),
                    Text(
                      "${(totalProgress * 100).toStringAsFixed(0)}%",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Constants.primaryBlackTone,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                // Metin
                Expanded(
                  child: CustomText(
                    text: "Toplam İlerleme",
                    color: Constants.primaryBlackTone,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // Ders listesi
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: subjects.length,
              itemBuilder: (context, index) {
                final subject = subjects[index];
                final progressValue = progress[index];

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: subject,
                            color: Constants.primaryBlackTone,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                          const SizedBox(height: 6),
                          SizedBox(
                            height: 6,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: progressValue,
                                backgroundColor: Colors.grey.shade300,
                                color: Constants.primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 20),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => SubjectsPage(title: subject),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
