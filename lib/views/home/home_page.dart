// home_page.dart
import 'package:flutter/material.dart';
import 'package:student_track/helpers/data_helper.dart';
import 'package:student_track/widgets/custom_text.dart';
import 'package:student_track/widgets/custom_drawer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final List firstCards = DataHelper.getTopCardsData();
    final List todaySentence = DataHelper.getTodaySentence();
    final List lastCards = DataHelper.getBottomCardsData();

    double deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: "Merhaba ",
                          style: TextStyle(
                            color: Colors.indigo,
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                          ),
                        ),
                        TextSpan(
                          text: "Safiye",
                          style: TextStyle(
                            color: Colors.indigo,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Icon(Icons.waving_hand, color: Colors.indigo),
                ],
              ),
              const CustomText(
                text: "Bugün harika bir gün olacak!",
                color: Colors.black38,
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.indigo,
        elevation: 0,
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
    );
  }

  Widget _buildTopCards(List cards) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: List.generate(
        cards.length,
        (index) => TopCard(
          index: index,
          title: cards[index]["title"],
          subTitle: cards[index]["subtitle"],
        ),
      ),
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
          color: const Color.fromARGB(255, 224, 227, 245),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomText(
              text: "${sentence[0]["text"]}",
              color: Colors.indigo,
              fontWeight: FontWeight.w400,
              fontSize: 16,
              textAlign: TextAlign.center,
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

class TopCard extends StatelessWidget {
  final int index;
  final String title;
  final String subTitle;

  const TopCard({
    super.key,
    required this.index,
    required this.title,
    required this.subTitle,
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
    return SizedBox(
      width: (MediaQuery.of(context).size.width - 48) / 2,
      height: 120,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(_getIconForIndex(index), color: Colors.indigo, size: 24),
                  const SizedBox(width: 8),
                  CustomText(
                    text: title,
                    color: Colors.indigo,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ],
              ),
              const SizedBox(height: 6),
              CustomText(
                text: subTitle,
                color: Colors.black45,
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
            ],
          ),
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
        return Icons.track_changes;
      case 2:
        return Icons.edit;
      case 3:
        return Icons.fact_check_outlined;
      default:
        return Icons.info_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: (MediaQuery.of(context).size.width - 48) / 2,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(_getIconForIndex(index), color: Colors.indigo, size: 24),
              const SizedBox(width: 8),
              CustomText(
                text: title,
                color: Colors.black87,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
