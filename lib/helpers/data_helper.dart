import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';

class DataHelper {
  static final DataHelper _instance = DataHelper._internal();
  factory DataHelper() => _instance;
  DataHelper._internal();

  // Quote cache için değişkenler
  Map<String, dynamic>? _cachedQuote;
  bool _isQuoteLoaded = false;
  String? _cacheDate;

  // Targets cache için değişkenler
  List<Map<String, dynamic>>? _cachedTargets;
  bool _isTargetsLoaded = false;
  String? _cachedStudentId;

  static String welcomeTextName = "Safiye";
  static String welcomeText = "Merhaba";

  static List<Map<String, String>> getTopCardsData() {
    return [
      {'title': '127', 'subtitle': 'Haftalık Soru'},
      {'title': '0', 'subtitle': 'Yeni Hedef'},
      {'title': '28/84', 'subtitle': 'Haftalık Saat'},
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

  // Günlük sözü tek sefer fetch et - Singleton pattern ile cache
  static Future<Map<String, dynamic>> getRandomQuote() async {
    final instance = DataHelper();
    final today = DateTime.now().toIso8601String().split('T')[0];

    // Eğer bugün için cache var ise kullan
    if (instance._isQuoteLoaded && 
        instance._cacheDate == today && 
        instance._cachedQuote != null) {
      print('Cache\'ten döndürülüyor: ${instance._cachedQuote!['speech']}');
      return instance._cachedQuote!;
    }

    print('Firestore\'dan yeni veri çekiliyor...');

    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('words')
          .doc('metadata')
          .collection('quotes')
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final random = Random();
        final randomDoc = querySnapshot.docs[random.nextInt(querySnapshot.docs.length)];
        
        // Cache'e kaydet
        instance._cachedQuote = {
          'owner': randomDoc['owner'],
          'speech': randomDoc['speech'],
        };
        instance._isQuoteLoaded = true;
        instance._cacheDate = today;
        
        print('Yeni söz cache\'lendi: ${instance._cachedQuote!['speech']}');
        return instance._cachedQuote!;
      }
    } catch (e) {
      print('Firestore hatası: $e');
      
      // Eğer daha önce cache'lenmiş veri varsa onu döndür
      if (instance._cachedQuote != null) {
        return instance._cachedQuote!;
      }
    }

    // Hata durumunda varsayılan değer
    final defaultQuote = {'owner': 'Bilinmeyen', 'speech': 'Hiçbir söz bulunamadı.'};
    
    // Varsayılan değeri de cache'le (network hatası durumunda)
    if (!instance._isQuoteLoaded) {
      instance._cachedQuote = defaultQuote;
      instance._isQuoteLoaded = true;
      instance._cacheDate = today;
    }
    
    return defaultQuote;
  }

  // Cache'i temizleme metodu (yeni gün için veya manuel yenileme)
  static void clearQuoteCache() {
    final instance = DataHelper();
    instance._isQuoteLoaded = false;
    instance._cachedQuote = null;
    instance._cacheDate = null;
    print('Quote cache temizlendi');
  }

  // Cache durumunu kontrol et
  static bool get isQuoteCached {
    final instance = DataHelper();
    final today = DateTime.now().toIso8601String().split('T')[0];
    return instance._isQuoteLoaded && instance._cacheDate == today;
  }

  // get targets data from firestore - Cache'li versiyon
  static Future<List<Map<String, dynamic>>> getTargetsData(
    String studentId,
  ) async {
    final instance = DataHelper();

    // Eğer cache var ve aynı student için ise kullan
    if (instance._isTargetsLoaded && 
        instance._cachedStudentId == studentId && 
        instance._cachedTargets != null) {
      print('Targets cache\'ten döndürülüyor - Student: $studentId');
      return instance._cachedTargets!;
    }

    print('Firestore\'dan targets yeni veri çekiliyor - Student: $studentId');

    try {
      // Öğrencinin dokümanını al
      DocumentSnapshot studentDoc = await FirebaseFirestore.instance
          .collection('students')
          .doc(studentId)
          .get();

      if (!studentDoc.exists) {
        instance._cachedTargets = [];
        instance._isTargetsLoaded = true;
        instance._cachedStudentId = studentId;
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
        String sourceName = idParts.length > 1
            ? idParts[1]
            : ''; // alt tireden sonraki kısım

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
            'tarih':
                targetData['targetDate']?.toString() ?? 'Tarih belirtilmemiş',
            'tamamlandi': targetData['completed'] ?? false,
          });
        }
      }

      // Cache'e kaydet
      instance._cachedTargets = targets;
      instance._isTargetsLoaded = true;
      instance._cachedStudentId = studentId;

      print('Targets cache\'lendi - ${targets.length} hedef');
      return targets;
    } catch (e) {
      print('Targets fetch hatası: $e');
      
      // Hata durumunda eski cache varsa döndür
      if (instance._cachedTargets != null && instance._cachedStudentId == studentId) {
        return instance._cachedTargets!;
      }
      
      return [];
    }
  }

  // Targets cache'ini temizle (yeni hedef eklendiğinde kullan)
  static void clearTargetsCache() {
    final instance = DataHelper();
    instance._isTargetsLoaded = false;
    instance._cachedTargets = null;
    instance._cachedStudentId = null;
    print('Targets cache temizlendi');
  }

  // Targets cache durumunu kontrol et
  static bool isTargetsCached(String studentId) {
    final instance = DataHelper();
    return instance._isTargetsLoaded && instance._cachedStudentId == studentId;
  }
}