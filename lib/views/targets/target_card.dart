import 'package:flutter/material.dart';
import 'package:student_track/constants/constants.dart';
import 'package:student_track/widgets/custom_text.dart';

class TargetCard extends StatelessWidget {
  final Map<String, dynamic> target;
  final VoidCallback? onChanged; // opsiyonel callback

  const TargetCard({super.key, required this.target, this.onChanged});

  @override
  Widget build(BuildContext context) {
    // Tarih formatı
    String tarihStr = target["tarih"] != null
        ? "${target["tarih"].day}.${target["tarih"].month}.${target["tarih"].year}"
        : "Bilinmiyor";

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // subject and topic
            CustomText(text: "${target["ders"]} - ${target["konu"]}", color: Constants.primaryBlackTone, fontWeight: FontWeight.bold, fontSize: 16, maxLines: 2, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 4),

            // book
            CustomText(text: target["kitap"], color: Colors.black87, fontWeight: FontWeight.normal, fontSize: 14),
            const SizedBox(height: 4),

            // date
            
            CustomText(
              text: "Gönderilme tarihi: $tarihStr",
              color: Colors.black54,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
            const SizedBox(height: 8),

            // Checkbox and status
            Row(
              children: [
                Checkbox(
                  value: target["tamamlandi"],
                  onChanged: (val) {
                    if (val == true) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Onay"),
                          content: const Text(
                              "Yapıldı olarak işaretlerseniz bunun geri dönüşü olmaz. Emin misiniz?"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("İptal"),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                target["tamamlandi"] = true;
                                Navigator.pop(context);
                                if (onChanged != null) onChanged!();
                              },
                              child: const Text("Evet"),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
                Text(
                  target["tamamlandi"]
                      ? "Tamamlandı"
                      : "Henüz tamamlanmadı",
                  style: TextStyle(
                    color: target["tamamlandi"]
                        ? Constants.primaryColor
                        : Constants.primaryRedTone,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
