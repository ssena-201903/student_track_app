import 'package:cloud_firestore/cloud_firestore.dart';

class DataHelper {
  static String welcomeTextName = "Safiye";
  static String welcomeText = "Merhaba";

  static List<Map<String, String>> getTopCardsData() {
    return [
      {'title': '85%', 'subtitle': 'Hedeflerim'},
      {'title': '127', 'subtitle': 'Haftalık Soru'},
      {'title': '0', 'subtitle': 'Yeni Hedef'},
      {'title': '28/84', 'subtitle': 'Saat Çalışma'},
    ];
  }

  static List<Map<String, String>> getBottomCardsData() {
    return [
      {'title': 'Pomodoro Yap'},
      {'title': 'Denemeler'},
    ];
  }

  static List<Map<String, String>> getTodaySentence() {
    return [
      {
        'text': 'Başarı, hazırlık fırsatla buluştuğunda ortaya çıkar.',
        'writer': 'Seneca',
      },
    ];
  }

static Future<List<Map<String, dynamic>>> getTargetsData(String studentId) async {
    try {
      // Öğrencinin dokümanını al
      DocumentSnapshot studentDoc = await FirebaseFirestore.instance
          .collection('students')
          .doc(studentId)
          .get();

      if (!studentDoc.exists) {
        return [];
      }

      // Öğrencinin course değerini al
      String course = studentDoc['course'] ?? '';

      // Öğrencinin hedeflerini al (map yapısı)
      Map<String, dynamic> targetsMap = studentDoc['topicBookTargets'] ?? {};

      List<Map<String, dynamic>> targets = [];
      for (var entry in targetsMap.entries) {
        String id = entry.key; // id: konuId_kaynakAdi
        Map<String, dynamic> targetData = entry.value;

        // id'yi _ ile ayır
        List<String> idParts = id.split('_');
        String topicId = idParts[0]; // alt tireye kadar olan kısım
        String sourceName = idParts.length > 1 ? idParts[1] : ''; // alt tireden sonraki kısım

        // konular koleksiyonundan konu ve ders bilgisini al
        DocumentSnapshot topicDoc = await FirebaseFirestore.instance
            .collection('konular')
            .doc(course)
            .collection('konuListesi')
            .doc(topicId)
            .get();

        if (topicDoc.exists) {
          targets.add({
            'id': id,
            'ders': topicDoc['ders'] ?? 'Bilinmiyor',
            'konu': topicDoc['konu'] ?? 'Bilinmiyor',
            'kitap': sourceName,
            'tarih': targetData['targetDate']?.toString() ?? 'Tarih belirtilmemiş',
            'tamamlandi': targetData['completed'] ?? false,
          });
        }
      }

      return targets;
    } catch (e) {
      print('Hata: $e');
      return [];
    }
  }

}
