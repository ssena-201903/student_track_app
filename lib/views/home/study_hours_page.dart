import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:student_track/constants/constants.dart';
import 'package:student_track/widgets/custom_text.dart';

class StudyHoursPage extends StatefulWidget {
  const StudyHoursPage({super.key});

  @override
  State<StudyHoursPage> createState() => _StudyHoursPageState();
}

class _StudyHoursPageState extends State<StudyHoursPage> {
  Map<String, double> studyHours = {
    "Pazartesi": 4,
    "Salı": 6,
    "Çarşamba": 2,
    "Perşembe": 0,
    "Cuma": 0,
    "Cumartesi": 0,
    "Pazar": 0,
  };

  final double weeklyGoal = 84; // haftalık hedef saat

  String _getTodayInTurkish() {
    final today = DateTime.now().weekday;
    final days = [
      "Pazartesi",
      "Salı",
      "Çarşamba",
      "Perşembe",
      "Cuma",
      "Cumartesi",
      "Pazar",
    ];
    return days[today - 1];
  }

  void _increaseHours() {
    final today = _getTodayInTurkish();

    if (studyHours[today]! >= 14) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Günlük çalışma sınırına ulaştınız"),
          backgroundColor: Colors.orange,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    setState(() {
      studyHours[today] = studyHours[today]! + 1;
    });
  }

  void _decreaseHours() {
    final today = _getTodayInTurkish();

    if (studyHours[today]! <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Çalışma saati 0'dan daha az olamaz"),
          backgroundColor: Colors.redAccent,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    setState(() {
      studyHours[today] = studyHours[today]! - 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double totalHours = studyHours.values.fold(0, (a, b) => a + b);
    final double progress = (totalHours / weeklyGoal).clamp(0.0, 1.0);
    final days = studyHours.keys.toList();
    final String today = _getTodayInTurkish();

    return Scaffold(
      appBar: AppBar(title: const Text("Ders Çalışma Saatleri")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 🔹 Haftalık ilerleme barı
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.timer, color: Constants.primaryColor, size: 24),
                    const SizedBox(width: 8),
                    CustomText(
                      text:
                          "Haftalık Hedef: ${totalHours.toInt()} / ${weeklyGoal.toInt()} saat",
                      fontWeight: FontWeight.bold,
                      color: Constants.primaryBlackTone,
                      fontSize: 14,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                LinearProgressIndicator(
                  value: progress,
                  minHeight: 8,
                  backgroundColor: Colors.grey.shade300,
                  color: Constants.primaryColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // 🔹 Yatay Bar Chart (90 derece döndürülmüş)
            Container(
              height: 450, // Sabit yükseklik
              margin: const EdgeInsets.all(16),
              child: RotatedBox(
                quarterTurns: 1, // 90 derece saat yönünde döndür
                child: BarChart(
                  BarChartData(
                    maxY: 14, // 14 saat maksimum
                    alignment: BarChartAlignment.spaceAround,
                    barTouchData: BarTouchData(enabled: false),
                    titlesData: FlTitlesData(
                      // Sol taraf: Saatler (döndürülmüş halde üst taraf)
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 2,
                          getTitlesWidget: (value, meta) {
                            return RotatedBox(
                              quarterTurns: -1, // Yazıları düz tut
                              child: CustomText(
                                text: value.toInt().toString(),
                                color: Constants.primaryBlackTone,
                                fontWeight: FontWeight.w900,
                                fontSize: 12,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          },
                          reservedSize: 30,
                        ),
                      ),
                      // Alt taraf: Günler (döndürülmüş halde sol taraf)
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            int index = value.toInt();
                            if (index >= 0 && index < days.length) {
                              return RotatedBox(
                                quarterTurns: -1, // Yazıları düz tut
                                child: CustomText(
                                  text: days[index],
                                  color: Constants.primaryBlackTone,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 12,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                          reservedSize: 80,
                        ),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: true,
                      drawHorizontalLine: true,
                      verticalInterval: 2,
                      horizontalInterval: 1,
                      getDrawingVerticalLine: (value) {
                        return FlLine(
                          color: Colors.grey.shade400,
                          strokeWidth: 1,
                        );
                      },
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: Colors.grey.shade400,
                          strokeWidth: 0.6,
                        );
                      },
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: Border.all(color: Colors.grey.shade200, width: 1),
                    ),

                    // 🔹 Günlere göre barlar
                    barGroups: List.generate(
                      days.length,
                      (i) => BarChartGroupData(
                        x: i,
                        barRods: [
                          BarChartRodData(
                            toY: studyHours[days[i]]!,
                            width: 20,
                            color: days[i] == today
                                ? Constants.lightPrimaryTone
                                : Constants.primaryColor,
                            borderRadius: BorderRadius.circular(4),
                            // Bugünkü bar için border ekleme
                            borderSide: days[i] == today
                                ? BorderSide(
                                    color: Constants.primaryColor,
                                    width: 2,
                                  )
                                : BorderSide.none,
                          ),
                        ],
                      ),
                    ),

                    baselineY: 0,
                  ),
                  swapAnimationDuration: const Duration(milliseconds: 300),
                ),
              ),
            ),

            // 🔹 Bugünkü saat artırma bölümü
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Constants.lightPrimaryTone,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Constants.primaryColor.withOpacity(0.5),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Constants.primaryColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.today,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: "Bugün - $today",
                            fontWeight: FontWeight.bold,
                            color: Constants.primaryBlackTone,
                            fontSize: 16,
                          ),
                          CustomText(
                            text: "${studyHours[today]!.toInt()} / 14 saat",
                            color: Constants.primaryColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      ),
                      const Spacer(),

                      // 🔹 Eksi Butonu (0’dan büyükse görünür)
                      if (studyHours[today]! > 0)
                        Container(
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            color: Constants.primaryColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: IconButton(
                            onPressed: _decreaseHours,
                            icon: const Icon(
                              Icons.remove,
                              color: Colors.white,
                              size: 24,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 48,
                              minHeight: 48,
                            ),
                          ),
                        ),

                      // 🔹 Artı Butonu (14’ten küçükse görünür)
                      if (studyHours[today]! < 14)
                        Container(
                          decoration: BoxDecoration(
                            color: Constants.primaryColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: IconButton(
                            onPressed: _increaseHours,
                            icon: const Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 24,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 48,
                              minHeight: 48,
                            ),
                          ),
                        ),
                    ],
                  ),

                  if (studyHours[today]! >= 14) ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.green.shade300,
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  color: Colors.green.shade700,
                                  size: 16,
                                ),
                                const SizedBox(width: 6),
                                CustomText(
                                  text: "Günlük hedef tamamlandı!",
                                  color: Colors.green.shade700,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
