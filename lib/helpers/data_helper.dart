class DataHelper {
  static String welcomeTextName = "Safiye";
  static String welcomeText = "Merhaba";

  static List<Map<String, String>> getTopCardsData() {
    return [
      {'title': '85%', 'subtitle': 'Hedef Tamamlama'},
      {'title': '127', 'subtitle': 'Haftalık Soru'},
      {'title': '4', 'subtitle': 'Yeni Hedef'},
      {'title': '12', 'subtitle': 'Pomodoro'},
    ];
  }

  static List<Map<String, String>> getBottomCardsData() {
    return [
      {'title': 'Pomodoro Başlat'},
      {'title': 'Hedefleri Gör'},
      {'title': 'Soru Ekle'},
      {'title': 'Denemelerim'},
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
}
