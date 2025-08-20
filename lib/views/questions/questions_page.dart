import 'package:flutter/material.dart';
import 'package:student_track/constants/constants.dart';
import 'package:student_track/widgets/custom_text.dart';
import 'package:fl_chart/fl_chart.dart';

class QuestionsPage extends StatefulWidget {
  const QuestionsPage({super.key});

  @override
  State<QuestionsPage> createState() => _QuestionsPageState();
}

class _QuestionsPageState extends State<QuestionsPage> {
  String? selectedPastWeek;

  final Map<String, Map<String, List<Map<String, dynamic>>>> data = {
    "18.08.2025 - 24.08.2025": {
      "Matematik": [
        {"konu": "Limit", "kaynak": "Eis Yayınları", "adet": 50},
        {"konu": "Türev", "kaynak": "Palme Yayınları", "adet": 20},
      ],
      "Fizik": [
        {"konu": "Kuvvet", "kaynak": "Eis Yayınları", "adet": 30},
        {"konu": "Elektrik", "kaynak": "Fenomen Yayıncılık", "adet": 27},
      ],
    },
    "11.08.2025 - 17.08.2025": {
      "Matematik": [
        {"konu": "Fonksiyon", "kaynak": "Eis Yayınları", "adet": 25},
        {"konu": "Trigonometri", "kaynak": "Palme Yayınları", "adet": 18},
      ],
      "Kimya": [
        {"konu": "Organik Kimya", "kaynak": "Karekök Yayınları", "adet": 30},
      ],
    },
    "04.08.2025 - 10.08.2025": {
      "Matematik": [
        {"konu": "Limit", "kaynak": "Apotemi Yayınları", "adet": 20},
        {"konu": "Türev", "kaynak": "Karekök Yayınları", "adet": 15},
      ],
      "Fizik": [
        {"konu": "Newton Kanunları", "kaynak": "Palme Yayınları", "adet": 12},
        {"konu": "Elektrik", "kaynak": "Okyanus Yayınları", "adet": 10},
      ],
    },
    "28.07.2025 - 03.08.2025": {
      "Matematik": [
        {"konu": "Integral", "kaynak": "Apotemi Yayınları", "adet": 18},
        {"konu": "Karmaşık Sayılar", "kaynak": "Eis Yayınları", "adet": 22},
      ],
      "Kimya": [
        {"konu": "Asit-Baz", "kaynak": "Palme Yayınları", "adet": 25},
        {
          "konu": "Kimyasal Tepkimeler",
          "kaynak": "Okyanus Yayınları",
          "adet": 15,
        },
      ],
    },
  };

  @override
  Widget build(BuildContext context) {
    final thisWeek = data.keys.first;
    final pastWeeks = data.keys.skip(1).toList();

    final thisWeekTotal = data[thisWeek]!.values
        .expand((list) => list)
        .fold<int>(0, (sum, e) => sum + (e['adet'] as int));

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Soru İstatistikleri"),
          bottom: const TabBar(
            tabs: [
              Tab(text: "Soru Tablosu"),
              Tab(text: "Grafikler"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // 🔹 Tab 1: Çalışma Tablosu
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Constants.lightPrimaryTone,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            size: 20,
                            color: Constants.primaryBlackTone,
                          ),
                          const SizedBox(width: 8),
                          CustomText(
                            text: "Bu Hafta",
                            color: Constants.primaryBlackTone,
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                          ),
                          const Spacer(),
                          CustomText(
                            text: "$thisWeekTotal soru",
                            color: Constants.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    ..._buildLessonSections(data[thisWeek]!),
                    const SizedBox(height: 20),
                    DropdownButton<String>(
                      isExpanded: true,
                      hint: const Text("Geçmiş Hafta Seçiniz"),
                      value: selectedPastWeek,
                      items: pastWeeks
                          .map(
                            (week) => DropdownMenuItem(
                              value: week,
                              child: Text(week),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedPastWeek = value;
                        });
                      },
                    ),
                    if (selectedPastWeek != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildWeekHeader(
                              selectedPastWeek!,
                              data[selectedPastWeek]!,
                            ),
                            const SizedBox(height: 12),
                            ..._buildLessonSections(data[selectedPastWeek]!),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // 🔹 Tab 2: Grafikler
            _buildBarCharts(),
          ],
        ),
      ),
    );
  }

  Widget _buildBarCharts() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomText(
            text: "Çok yakında grafikler tablosu sizlerle...",
            color: Constants.primaryColor,
            fontWeight: FontWeight.w600,
            fontSize: 16,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildWeekHeader(
    String week,
    Map<String, List<Map<String, dynamic>>> weekData,
  ) {
    final totalQuestions = weekData.values
        .expand((list) => list)
        .fold<int>(0, (sum, e) => sum + (e['adet'] as int));

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Constants.lightPrimaryTone,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.calendar_today_outlined, size: 20),
          const SizedBox(width: 8),
          Text(
            week,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          // Text(
          //   "$totalQuestions Soru",
          //   style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          // ),
          CustomText(
            text: "$totalQuestions Soru",
            color: Constants.primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ],
      ),
    );
  }

  List<Widget> _buildLessonSections(
    Map<String, List<Map<String, dynamic>>> weekData,
  ) {
    // Tüm dersler
    final allLessons = [
      "Matematik",
      "Fizik",
      "Kimya",
      "Biyoloji",
      "Tarih",
      "Coğrafya",
    ];

    return allLessons.map((lesson) {
      final details = weekData[lesson] ?? [];
      final totalQuestions = details.fold<int>(
        0,
        (sum, e) => sum + (e['adet'] as int),
      );

      return Card(
        margin: const EdgeInsets.symmetric(vertical: 4),
        child: ExpansionTile(
          title: Row(
            children: [
              CustomText(
                text: lesson,
                color: Constants.primaryBlackTone,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              Spacer(),
              CustomText(
                text: "$totalQuestions Soru",
                color: Constants.primaryBlackTone,
                fontWeight: FontWeight.w900,
                fontSize: 14,
              ),
            ],
          ),
          children: details.isNotEmpty
              ? details.map((detail) {
                  return ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          text: detail["konu"],
                          color: Constants.primaryBlackTone,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        CustomText(
                          text: detail["kaynak"],
                          color: Colors.black87,
                          fontWeight: FontWeight.normal,
                          fontSize: 12,
                        ),
                      ],
                    ),
                    trailing: CustomText(
                      text: "${detail['adet']} Soru",
                      color: Constants.primaryBlackTone,
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                    ),
                  );
                }).toList()
              : [
                  ListTile(
                    title: Center(
                      child: CustomText(
                        text: "Henüz bu derse soru eklemediniz!",
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
        ),
      );
    }).toList();
  }
}
