import 'package:flutter/material.dart';
import 'package:student_track/constants/constants.dart';
import 'package:student_track/helpers/data_helper.dart';
import 'package:student_track/views/exams/exam_page.dart';
import 'package:student_track/views/home/add_question_page.dart';
import 'package:student_track/views/home/study_hours_page.dart';
import 'package:student_track/views/pomodoro/pomodo_page.dart';
import 'package:student_track/views/questions/questions_page.dart';
import 'package:student_track/views/targets/target_page.dart';
import 'package:student_track/widgets/custom_text.dart';
import 'package:student_track/widgets/custom_drawer.dart';

class HomePage extends StatefulWidget {
  final String studentId; // Öğrenci ID'si

  const HomePage({super.key, required this.studentId});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List firstCards = DataHelper.getTopCardsData();
  final List todaySentence = DataHelper.getTodaySentence();
  final List lastCards = DataHelper.getBottomCardsData();

  List<Map<String, dynamic>> targets = [];
  int pendingTargetsCount = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTargets();
  }

  Future<void> _fetchTargets() async {
    setState(() {
      isLoading = true;
    });
    try {
      targets = await DataHelper.getTargetsData(widget.studentId);
      setState(() {
        // Sadece tarihi bugünden ileri ve tamamlanmamış hedefleri say
        final now = DateTime.now();
        pendingTargetsCount = targets.where((t) {
          if (t['tamamlandi'] == true) return false;
          try {
            final targetDate = DateTime.parse(t['tarih']);
            return targetDate.isAfter(now) || targetDate.isAtSameMomentAs(now);
          } catch (e) {
            return false; // Geçersiz tarih formatı varsa bu hedefi dahil etme
          }
        }).length;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hedefler yüklenirken hata oluştu: $e')),
      );
    }
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => AddQuestionPage()),
          );
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
        if (index == 1) {
          return TopCard(
            index: index,
            title: cards[index]["title"],
            subTitle: cards[index]["subtitle"],
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const QuestionsPage()),
              );
            },
          );
        }
        if (index == 2) {
          return TopCard(
            index: index,
            title: pendingTargetsCount > 0
                ? pendingTargetsCount.toString()
                : "0",
            subTitle: pendingTargetsCount > 0 ? "Yeni Hedef" : "Yeni hedef yok",
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TargetPage(studentId: widget.studentId),
                ),
              );
              await _fetchTargets(); // Geri dönüldüğünde hedefleri güncelle
            },
          );
        }
        if (index == 3) {
          return TopCard(
            index: index,
            title: cards[index]["title"],
            subTitle: cards[index]["subtitle"],
            onTap: () async {
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
              overflow: TextOverflow.visible,
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
              : () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const ExamPage()),
                  );
                },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Constants.lightPrimaryTone,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Icon(
                    _getIconForIndex(index),
                    color: Constants.primaryColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomText(
                    text: title,
                    color: Colors.black87,
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

    double cardHeight = MediaQuery.of(context).size.height * 0.14;

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
                    
                  ],
                ),
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