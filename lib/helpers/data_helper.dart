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
      {'title': 'Pomodoro Başlat'},
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
}
