// home_page.dart
import 'package:flutter/material.dart';
import 'package:student_track/constants/constants.dart';
import 'package:student_track/helpers/data_helper.dart';
import 'package:student_track/views/home/add_question_page.dart';
import 'package:student_track/views/home/study_hours_page.dart';
import 'package:student_track/views/pomodoro/pomodo_page.dart';
import 'package:student_track/views/questions/questions_page.dart';
import 'package:student_track/views/targets/target_page.dart';
import 'package:student_track/widgets/custom_text.dart';
import 'package:student_track/widgets/custom_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List firstCards = DataHelper.getTopCardsData();
  final List todaySentence = DataHelper.getTodaySentence();
  final List lastCards = DataHelper.getBottomCardsData();

  late List<Map<String, dynamic>> targets;
  int pendingTargetsCount = 0;

  @override
  void initState() {
    super.initState();

    // Static metotla targets verisini al
    targets = DataHelper.getTargetsData;

    // Tamamlanmamış hedefleri say
    pendingTargetsCount = targets.where((t) => t["tamamlandi"] == false).length;
  }

  void _updatePendingTargets() {
    setState(() {
      pendingTargetsCount = targets
          .where((t) => t["tamamlandi"] == false)
          .length;
    });
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(
        backgroundColor: Constants.primaryColor,
        foregroundColor: Constants.primaryWhiteTone,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Merhaba ",
                          style: TextStyle(
                            color: Constants.primaryWhiteTone,
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                          ),
                        ),
                        TextSpan(
                          text: "Safiye!",
                          style: TextStyle(
                            color: Constants.primaryWhiteTone,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  //Icon(Icons.waving_hand, color: Constants.primaryColor),
                ],
              ),
              const SizedBox(height: 6),
              const CustomText(
                text: "Günün harika geçsin!",
                color: Colors.white70,
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            _buildTopCards(firstCards),
            _buildTodaySentence(todaySentence, deviceWidth),
            _buildBottomCards(lastCards),
            const SizedBox(height: 20),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => AddQuestionPage()));
        },
        icon: Icon(Icons.add),
        label: CustomText(
          text: "Soru Ekle",
          color: Colors.white,
          fontWeight: FontWeight.normal,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildTopCards(List cards) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: List.generate(cards.length, (index) {
        // eğer 2. kart ise index değeri 1 olan kartı kontrol et
        if (index == 1) {
          return TopCard(
            index: index,
            title: cards[index]["title"],
            subTitle: cards[index]["subtitle"],
            onTap: () async {
              // Questions Page'e git
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const QuestionsPage()),
              );
            },
          );
        }
        // Eğer 3. kart (index 2) hedef kartı ise, title ve subtitle'ı özel yap
        if (index == 2) {
          return TopCard(
            index: index,
            title: pendingTargetsCount > 0
                ? pendingTargetsCount.toString()
                : "0",
            subTitle: pendingTargetsCount > 0 ? "Yeni Hedef" : "Yeni hedef yok",
            onTap: () async {
              // TargetPage'e git
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TargetPage()),
              );
              // Geri dönüldüğünde sayıyı güncelle
              _updatePendingTargets();
            },
          );
        }

        // Eğer 4. kart (index 3) hedef kartı ise, title ve subtitle'ı özel yap
        if (index == 3) {
          return TopCard(
            index: index,
            title: cards[index]["title"],
            subTitle: cards[index]["subtitle"],
            onTap: () async {
              // TargetPage'e git
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const StudyHoursPage()),
              );
            },
          );
        }

        return TopCard(
          index: index,
          title: cards[index]["title"],
          subTitle: cards[index]["subtitle"],
        );
      }),
    );
  }

  Widget _buildTodaySentence(List sentence, double deviceWidth) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Container(
        width: deviceWidth - 40,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Constants.lightPrimaryTone,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomText(
              text: "${sentence[0]["text"]}",
              color: Constants.primaryColor,
              fontWeight: FontWeight.w500,
              fontSize: 16,
              maxLines: null,
              textAlign: TextAlign.center,
              overflow: TextOverflow.visible, // wrap
            ),

            const SizedBox(height: 10),
            CustomText(
              text: "- ${sentence[0]["writer"]}",
              color: Colors.black54,
              fontWeight: FontWeight.w200,
              fontSize: 14,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomCards(List cards) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: List.generate(
          cards.length,
          (index) => BottomCard(index: index, title: cards[index]["title"]),
        ),
      ),
    );
  }
}

class BottomCard extends StatelessWidget {
  final int index;
  final String title;

  const BottomCard({super.key, required this.index, required this.title});

  IconData _getIconForIndex(int index) {
    switch (index) {
      case 0:
        return Icons.access_time;
      case 1:
        return Icons.description_outlined;
      default:
        return Icons.info_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: (MediaQuery.of(context).size.width - 48) / 2,
      child: Card(
        child: InkWell(
          onTap: index == 0
              ? () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => PomodoroPage()),
                  );
                }
              : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Constants.lightPrimaryTone, // ikon arka plan rengi
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Icon(
                    _getIconForIndex(index),
                    color: Constants.primaryColor, // ikon rengi
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomText(
                    text: title,
                    color: Colors.black87, // metin rengi
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TopCard extends StatelessWidget {
  final int index;
  final String title;
  final String subTitle;
  final VoidCallback? onTap;

  const TopCard({
    super.key,
    required this.index,
    required this.title,
    required this.subTitle,
    this.onTap,
  });

  IconData _getIconForIndex(int index) {
    switch (index) {
      case 0:
        return Icons.check_circle_outline;
      case 1:
        return Icons.edit;
      case 2:
        return Icons.track_changes;
      case 3:
        return Icons.timer_outlined;
      default:
        return Icons.info_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool shouldHighlight =
        index == 2 && int.tryParse(title) != null && int.parse(title) > 0;

    double cardHeight =
        MediaQuery.of(context).size.height *
        0.14; // Tüm kartlar için sabit, cihaz boyutuna göre

    return SizedBox(
      width: (MediaQuery.of(context).size.width - 48) / 2,
      height: cardHeight,
      child: Card(
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _getIconForIndex(index),
                          color: Constants.primaryColor,
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        CustomText(
                          text: index == 2 && shouldHighlight ? "" : title,
                          color: Constants.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    CustomText(
                      text: index == 2
                          ? (shouldHighlight ? "Yeni Hedef" : "Yeni hedef yok")
                          : subTitle,
                      color: Colors.black45,
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),
                    if (index == 3) ...[
                      const SizedBox(height: 20),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: 0.5, // ilerleme oranı
                          backgroundColor: Colors.grey[300],
                          color: Constants.primaryColor,
                          minHeight: 6,
                        ),
                      ),
                    ],
                  ],
                ),

                // Badge
                if (shouldHighlight)
                  Positioned(
                    top: 2,
                    right: 2,
                    child: Container(
                      width: 35,
                      height: 35,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Constants.primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: CustomText(
                        text: title,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
