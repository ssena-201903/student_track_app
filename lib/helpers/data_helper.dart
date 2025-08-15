class DataHelper {
  static String welcomeTextName = "Safiye";
  static String welcomeText = "Merhaba";

  static List<Map<String, String>> getTopCardsData() {
    return [
      {'title': '85%', 'subtitle': 'Hedeflerim'},
      {'title': '127', 'subtitle': 'Haftalık Soru'},
      {'title': '0', 'subtitle': 'Yeni Hedef'},
      {'title': '6/12', 'subtitle': 'Saat Çalışma'},
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

  static List<Map<String, dynamic>> getTargetsData = [
  {
    "ders": "Matematik",
    "konu": "Üslü Sayılar",
    "kitap": "Eis Yayınları",
    "tarih": DateTime(2025, 8, 15),
    "tamamlandi": false
  },
  {
    "ders": "Kimya",
    "konu": "Enerji",
    "kitap": "Karekök Yayınları",
    "tarih": DateTime(2025, 8, 14),
    "tamamlandi": false
  },
  {
    "ders": "Fizik",
    "konu": "Kuvvet",
    "kitap": "Palme Yayınları",
    "tarih": DateTime(2025, 8, 14),
    "tamamlandi": false
  },
  {
    "ders": "Biyoloji",
    "konu": "Hücre",
    "kitap": "Palme Yayınları",
    "tarih": DateTime(2025, 8, 14),
    "tamamlandi": false
  },
  {
    "ders": "Fizik",
    "konu": "Mekanik",
    "kitap": "Eis Yayınları",
    "tarih": DateTime(2025, 8, 14),
    "tamamlandi": false
  },
];

}
