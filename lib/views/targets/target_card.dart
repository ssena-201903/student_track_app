import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:student_track/constants/constants.dart';
import 'package:student_track/widgets/custom_text.dart';

class TargetCard extends StatelessWidget {
  final Map<String, dynamic> target;
  final VoidCallback? onChanged;
  final String studentId;
  final bool isLate;

  const TargetCard({
    super.key,
    required this.target,
    this.onChanged,
    required this.studentId,
    required this.isLate,
  });

  Future<void> _updateCompletionStatus() async {
    try {
      await FirebaseFirestore.instance
          .collection('students')
          .doc(studentId)
          .update({
        'topicBookTargets.${target['id']}.completed': true,
      });
      if (onChanged != null) onChanged!();
    } catch (e) {
      print('Hata: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Tarih doğrudan String olarak kullanılıyor
    String tarihStr = target['tarih'] ?? 'Tarih belirtilmemiş';

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: "${target['ders']} - ${target['konu']}",
              color: Constants.primaryBlackTone,
              fontWeight: FontWeight.bold,
              fontSize: 16,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            CustomText(
              text: target['kitap'],
              color: Colors.black87,
              fontWeight: FontWeight.normal,
              fontSize: 14,
            ),
            const SizedBox(height: 4),
            CustomText(
              text: "Gönderilme tarihi: $tarihStr",
              color: Colors.black54,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                if (isLate)
                  Row(
                    children: [
                      const Icon(Icons.warning, color: Colors.red, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        'Geç kaldınız!',
                        style: TextStyle(
                          color: Constants.primaryRedTone,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  )
                else
                  Row(
                    children: [
                      Checkbox(
                        value: target['tamamlandi'],
                        onChanged: (val) {
                          if (val == true && !target['tamamlandi']) {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Onay'),
                                content: const Text(
                                    'Yapıldı olarak işaretlerseniz bunun geri dönüşü olmaz. Emin misiniz?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('İptal'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      await _updateCompletionStatus();
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Evet'),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                      ),
                      Text(
                        target['tamamlandi'] ? 'Tamamlandı' : 'Henüz tamamlanmadı',
                        style: TextStyle(
                          color: target['tamamlandi']
                              ? Constants.primaryColor
                              : Constants.primaryRedTone,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}