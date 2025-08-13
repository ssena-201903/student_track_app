import 'package:flutter/material.dart';
import 'package:student_track/constants/constants.dart';
import 'package:student_track/widgets/custom_text.dart';

class SubjectsPage extends StatefulWidget {
  final String title;
  const SubjectsPage({super.key, required this.title});

  @override
  State<SubjectsPage> createState() => _SubjectsPageState();
}

class _SubjectsPageState extends State<SubjectsPage> {
  final Map<String, List<BookItem>> subjects = {
    "Kuvvet": [
      BookItem(name: "Fizik Soru Bankası - Kuvvet", isRead: false),
      BookItem(name: "Kuvvet Konu Anlatımı", isRead: true),
      BookItem(name: "TYT Fizik Kuvvet Testleri", isRead: false),
      BookItem(name: "Palme Yayınları Kuvvet Fasikülü", isRead: true),
    ],
    "İş, Güç, Enerji": [
      BookItem(name: "Enerji ve Güç - TYT Soru Kitabı", isRead: false),
      BookItem(name: "Fizik Defteri - Enerji", isRead: false),
      BookItem(name: "İş ve Güç Konu Anlatımı", isRead: true),
      BookItem(name: "Enerji Soruları - Final Yayınları", isRead: false),
    ],
    "Hareket": [
      BookItem(name: "TYT Fizik - Hareket Soru Bankası", isRead: true),
      BookItem(name: "Hareket Konu Özetleri", isRead: false),
      BookItem(name: "Hız - Zaman - Yer Grafik Çalışmaları", isRead: false),
    ],
    "Newton'un Hareket Yasaları": [
      BookItem(name: "Newton Yasaları - Konu Anlatımı", isRead: true),
      BookItem(name: "TYT Newton Test Kitabı", isRead: false),
      BookItem(name: "Üç Yayın Newton Çıkmış Sorular", isRead: false),
    ],
    "Basit Makineler": [
      BookItem(name: "Basit Makineler - Soru Kitabı", isRead: true),
      BookItem(name: "Konu Anlatımı - Basit Makineler", isRead: true),
      BookItem(name: "Fizik Kitapçığı - Makaralar", isRead: false),
    ],
    "Ağırlık Merkezi": [
      BookItem(name: "Ağırlık Merkezi Çözümlü Sorular", isRead: false),
      BookItem(name: "TYT Fizik - Ağırlık Merkezi Fasikülü", isRead: true),
      BookItem(name: "Palme Yayınları - Ağırlık Merkezi", isRead: false),
    ],
    "Tork ve Denge": [
      BookItem(name: "Denge Soruları - Seçkin Yayıncılık", isRead: false),
      BookItem(name: "Tork Konu Notları", isRead: false),
      BookItem(name: "TYT Tork ve Denge Denemeleri", isRead: true),
    ],
  };

  double calculateProgress(List<BookItem> books) {
    if (books.isEmpty) return 0.0;
    int readCount = books.where((b) => b.isRead).length;
    return readCount / books.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Constants.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: subjects.entries.map((entry) {
          final subjectName = entry.key;
          final bookList = entry.value;
          final progressValue = calculateProgress(bookList);

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: ExpansionTile(
              title: Row(
                children: [
                  // Başlık (uzun olursa kısalt)
                  Expanded(
                    child: CustomText(text: subjectName, color: Constants.primaryBlackTone, fontWeight: FontWeight.w600, fontSize: 16, maxLines: 1, overflow: TextOverflow.ellipsis),
                  ),
                  const SizedBox(width: 10),
                  // Progress bar
                  SizedBox(
                    width: 80,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: progressValue,
                        backgroundColor: Colors.grey.shade300,
                        color: Constants.primaryColor,
                        minHeight: 6,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  // Yüzde metni
                  CustomText(text: "${(progressValue * 100).toStringAsFixed(0)}%", color: Constants.primaryBlackTone, fontWeight: FontWeight.bold, fontSize: 12)
                ],
              ),

              children: bookList.map((book) {
                return CheckboxListTile(
                  title: CustomText(text: book.name, color: Constants.primaryBlackTone, fontWeight: FontWeight.normal, fontSize: 14),
                  value: book.isRead,
                  onChanged: (val) {
                    setState(() {
                      book.isRead = val ?? false;
                    });
                  },
                );
              }).toList(),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class BookItem {
  final String name;
  bool isRead;

  BookItem({required this.name, this.isRead = false});
}
