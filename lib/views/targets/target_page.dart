import 'package:flutter/material.dart';
import 'package:student_track/constants/constants.dart';

import 'package:student_track/helpers/data_helper.dart';
import 'package:student_track/views/targets/target_card.dart';

class TargetPage extends StatefulWidget {
  const TargetPage({super.key});

  @override
  State<TargetPage> createState() => _TargetPageState();
}

class _TargetPageState extends State<TargetPage> {
  late List<Map<String, dynamic>> targets;

  @override
  void initState() {
    super.initState();
    // targets listesini güvenli şekilde al
    targets = DataHelper.getTargetsData;
  }

  double get totalProgress {
    if (targets.isEmpty) return 0;
    final tamamlanan = targets.where((t) => t["tamamlandi"] == true).length;
    return tamamlanan / targets.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Hedeflerim")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Toplam ilerleme göstergesi
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Toplam İlerleme",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Constants.primaryBlackTone,
                      ),
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: totalProgress,
                        minHeight: 8,
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Constants.primaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "${(totalProgress * 100).toStringAsFixed(0)}%",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Constants.primaryBlackTone,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Hedef kartlarını listele
            Expanded(
              child: targets.isEmpty
                  ? Center(
                      child: Text(
                        "Henüz hedefiniz yok",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: targets.length,
                      itemBuilder: (context, index) {
                        return TargetCard(
                          target: targets[index],
                          onChanged: () {
                            setState(
                              () {},
                            ); // checkbox değişince sayfayı güncelle
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
