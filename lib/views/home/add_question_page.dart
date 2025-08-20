import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddQuestionPage extends StatefulWidget {
  const AddQuestionPage({super.key});

  @override
  State<AddQuestionPage> createState() => _AddQuestionPageState();
}

class _AddQuestionPageState extends State<AddQuestionPage> {
  String? selectedLesson;
  String? selectedTopic;
  String questionText = '';
  DateTime? selectedDate;

  // Örnek ders ve konu verisi
  final List<String> lessons = ['Matematik', 'Fen', 'Türkçe'];
  final Map<String, List<String>> topics = {
    'Matematik': ['Fonksiyon', 'Geometri', 'Cebir'],
    'Fen': ['Fizik', 'Kimya', 'Biyoloji'],
    'Türkçe': ['Dil Bilgisi', 'Edebiyat', 'Okuma'],
  };

  bool get isFormValid =>
      selectedLesson != null &&
      selectedTopic != null &&
      questionText.isNotEmpty &&
      selectedDate != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Yeni Soru Ekle')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Ders seçimi
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Ders Seçin',
                border: OutlineInputBorder(),
              ),
              value: selectedLesson,
              items: lessons
                  .map(
                    (lesson) =>
                        DropdownMenuItem(value: lesson, child: Text(lesson)),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedLesson = value;
                  selectedTopic = null; // konu sıfırlanır
                });
              },
            ),
            const SizedBox(height: 16),

            // Konu seçimi
            if (selectedLesson != null)
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Konu Seçin',
                  border: OutlineInputBorder(),
                ),
                value: selectedTopic,
                items: topics[selectedLesson!]!
                    .map(
                      (topic) =>
                          DropdownMenuItem(value: topic, child: Text(topic)),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedTopic = value;
                  });
                },
              ),
            if (selectedLesson != null) const SizedBox(height: 16),

            // Soru inputu
            if (selectedTopic != null)
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Soru Sayısı Girin',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    questionText = value;
                  });
                },
              ),
            if (selectedTopic != null) const SizedBox(height: 16),

            // Tarih seçimi
            if (selectedTopic != null)
              InkWell(
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    setState(() {
                      selectedDate = picked;
                    });
                  }
                },
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Tarih Seçin',
                    border: OutlineInputBorder(),
                  ),
                  child: Text(
                    selectedDate != null
                        ? DateFormat('dd.MM.yyyy').format(selectedDate!)
                        : 'Tarih seçilmedi',
                    style: TextStyle(
                      color: selectedDate != null
                          ? Colors.black87
                          : Colors.black45,
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 24),

            // Verileri Gönder butonu
            ElevatedButton(
              onPressed: isFormValid
                  ? () {
                      // Tüm veriler doluysa işlem yap
                      // Örnek: veri kaydet veya geri dön
                      print('Ders: $selectedLesson');
                      print('Konu: $selectedTopic');
                      print('Soru: $questionText');
                      print(
                        'Tarih: ${DateFormat('dd.MM.yyyy').format(selectedDate!)}',
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.green,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              4,
                            ), 
                          ),
                          elevation: 5,
                          duration: const Duration(seconds: 2),
                          content: Text('Soru başarıyla kaydedildi!'),
                        ),
                      );

                      Navigator.pop(context);
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 20),
              ),
              child: const Text('Verileri Gönder'),
            ),
          ],
        ),
      ),
    );
  }
}
