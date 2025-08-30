import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student_track/constants/constants.dart';
import 'package:student_track/helpers/data_helper.dart';
import 'package:student_track/providers/user_provider.dart';
import 'package:student_track/views/exams/exam_page.dart';
import 'package:student_track/views/home/add_question_page.dart';
import 'package:student_track/views/home/study_hours_page.dart';
import 'package:student_track/views/pomodoro/pomodo_page.dart';
import 'package:student_track/views/questions/questions_page.dart';
import 'package:student_track/views/targets/target_page.dart';
import 'package:student_track/widgets/custom_text.dart';
import 'package:student_track/widgets/custom_drawer.dart';

class HomePage extends ConsumerStatefulWidget {
  final String studentId;

  const HomePage({super.key, required this.studentId});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  final List firstCards = DataHelper.getTopCardsData();
  final List todaySentence = DataHelper.getTodaySentence();
  final List lastCards = DataHelper.getBottomCardsData();

  List<Map<String, dynamic>> targets = [];
  Map<String, dynamic>? todayQuote;
  int pendingTargetsCount = 0;
  bool isLoading = true;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  bool get wantKeepAlive => true; // State'i canlı tutar, sayfa yenilenmesini engeller

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _fetchTargets();
    _fetchRandomQuote();
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _fetchTargets() async {
    // Eğer cache varsa loading gösterme ve cache'ten al
    if (DataHelper.isTargetsCached(widget.studentId)) {
      try {
        targets = await DataHelper.getTargetsData(widget.studentId);
        final now = DateTime.now();
        pendingTargetsCount = targets.where((t) {
          if (t['tamamlandi'] == true) return false;
          try {
            final targetDate = DateTime.parse(t['tarih']);
            return targetDate.isAfter(now) || targetDate.isAtSameMomentAs(now);
          } catch (e) {
            return false;
          }
        }).length;

        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
        return;
      } catch (e) {
        print('Cache\'ten targets alınırken hata: $e');
      }
    }

    // Cache yoksa normal flow
    setState(() {
      isLoading = true;
    });

    try {
      final userAsyncValue = await ref.read(userProvider.future);
      if (userAsyncValue.id.isNotEmpty) {
        targets = await DataHelper.getTargetsData(widget.studentId);
        setState(() {
          final now = DateTime.now();
          pendingTargetsCount = targets.where((t) {
            if (t['tamamlandi'] == true) return false;
            try {
              final targetDate = DateTime.parse(t['tarih']);
              return targetDate.isAfter(now) ||
                  targetDate.isAtSameMomentAs(now);
            } catch (e) {
              return false;
            }
          }).length;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Kullanıcı kimliği geçersiz.')),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hedefler yüklenirken hata oluştu: $e')),
      );
    }
  }

  Future<void> _fetchRandomQuote() async {
    try {
      // Cache'li DataHelper.getRandomQuote() kullanıyor
      final quote = await DataHelper.getRandomQuote();
      if (mounted) {
        setState(() {
          todayQuote = quote;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          todayQuote = {'owner': 'Bilinmeyen', 'speech': 'Söz yüklenemedi: $e'};
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // AutomaticKeepAliveClientMixin için zorunlu

    final userAsyncValue = ref.watch(userProvider);
    double deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(
        // backgroundColor: Constants.primaryColor,
        // foregroundColor: Constants.primaryWhiteTone,
        elevation: 0,
        title: userAsyncValue.when(
          data: (user) {
            final firstName = user.name.split(' ').isNotEmpty
                ? user.name.split(' ')[0]
                : 'Kullanıcı';
            return Padding(
              padding: const EdgeInsets.only(top: 8),
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
                                color: Constants.primaryColor,
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                              ),
                            ),
                            TextSpan(
                              text: "$firstName!",
                              style: TextStyle(
                                color: Constants.primaryColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  CustomText(
                    text: "Günün harika geçsin",
                    color: Constants.primaryColor,
                    fontWeight: FontWeight.w400,
                    fontSize: 13,
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
          error: (error, stack) => const Center(
            child: Text(
              'Kullanıcı yüklenemedi',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
      backgroundColor: Colors.grey[50],
      body: isLoading || todayQuote == null
          ? Center(
              child: CircularProgressIndicator(
                color: Constants.primaryColor,
                strokeWidth: 3,
              ),
            )
          : RefreshIndicator(
              color: Constants.primaryColor,
              onRefresh: () async {
                // Sadece targets'i yenile, quote cache'ini bozmayalım
                DataHelper.clearTargetsCache(); // Targets cache'ini temizle
                await _fetchTargets();
                // Quote için manuel yenileme istemiyorsanız bu satırı kaldırın:
                // DataHelper.clearQuoteCache();
                // await _fetchRandomQuote();
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: "Hızlı Erişim",
                        color: Constants.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                      const SizedBox(height: 16),
                      _buildTopCards(),

                      const SizedBox(height: 30),
                      // today sentence
                      CustomText(
                        text: "Günün Sözü",
                        color: Constants.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                      const SizedBox(height: 16),
                      _buildTodaySentence(todayQuote!, deviceWidth),

                      const SizedBox(height: 30),
                      // bottom cards
                      CustomText(
                        text: "Çalışma Araçları",
                        color: Constants.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                      const SizedBox(height: 16),
                      _buildBottomCards(lastCards),

                      const SizedBox(height: 100), // FAB için boşluk
                    ],
                  ),
                ),
              ),
            ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Constants.primaryColor.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          onPressed: () {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (context) => AddQuestionPage()));
          },
          backgroundColor: Constants.primaryColor,
          foregroundColor: Constants.primaryWhiteTone,
          elevation: 0,
          icon: const Icon(Icons.add, size: 24),
          label: const CustomText(
            text: "Soru Ekle",
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildTopCards() {
    return Column(
      children: [
        // İlk satır - 2 kart
        Row(
          children: [
            // Haftalık Soru kartı (firstCards[0])
            Expanded(
              child: _buildTopCard(
                index: 1,
                title: firstCards[0]["title"], // "127"
                subTitle: firstCards[0]["subtitle"], // "Haftalık Soru"
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const QuestionsPage()),
                  );
                },
              ),
            ),
            const SizedBox(width: 6),
            // Hedefler kartı (firstCards[1])
            Expanded(
              child: _buildTopCard(
                index: 2,
                title: pendingTargetsCount > 0
                    ? pendingTargetsCount.toString()
                    : firstCards[1]["title"],
                subTitle: pendingTargetsCount > 0
                    ? "Aktif Hedef"
                    : "Yeni hedef yok",
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TargetPage(studentId: widget.studentId),
                    ),
                  );
                  // Yeni hedef eklenmiş olabilir, cache'i temizle ve yenile
                  DataHelper.clearTargetsCache();
                  await _fetchTargets();
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // İkinci satır - 1 kart (tam genişlik) - Çalışma Saatleri
        _buildTopCard(
          index: 3,
          title: firstCards[2]["title"], // "28/84"
          subTitle: firstCards[2]["subtitle"], // "Saat Çalışma"
          isFullWidth: true,
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const StudyHoursPage()),
            );
          },
        ),
      ],
    );
  }

  Widget _buildTopCard({
    required int index,
    required String title,
    required String subTitle,
    VoidCallback? onTap,
    bool isFullWidth = false,
  }) {
    final bool shouldHighlight =
        index == 2 && int.tryParse(title) != null && int.parse(title) > 0;

    return SizedBox(
      height: isFullWidth ? 90 : 90,
      child: Card(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: EdgeInsets.all(isFullWidth ? 12 : 10),
              child: isFullWidth
                  ? Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Constants.lightPrimaryTone,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            _getIconForTopCard(index),
                            color: Constants.primaryColor,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomText(
                                text: title,
                                color: Constants.primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              CustomText(
                                text: subTitle,
                                color: Colors.black54,
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Constants.lightPrimaryTone,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            _getIconForTopCard(index),
                            color: Constants.primaryColor,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (index == 2 && shouldHighlight)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Constants.primaryColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: CustomText(
                                    text: title,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )
                              else
                                CustomText(
                                  text: title,
                                  color: Constants.primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              const SizedBox(height: 4),
                              CustomText(
                                text: index == 2
                                    ? (shouldHighlight
                                          ? "Aktif Hedef"
                                          : "Yeni hedef yok")
                                    : subTitle,
                                color: Colors.black54,
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTodaySentence(Map<String, dynamic> quote, double deviceWidth) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        color: Constants.lightPrimaryTone,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.format_quote,
                    color: Constants.primaryColor.withOpacity(0.7),
                    size: 32,
                  ),
                  const SizedBox(width: 16),
                  CustomText(
                    text: quote['speech'],
                    color: Constants.primaryColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    maxLines: null,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.visible,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: CustomText(
                  text: "— ${quote['owner']}",
                  color: Constants.primaryColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomCards(List cards) {
    return Row(
      children: [
        // Pomodoro kartı
        Expanded(
          child: _buildBottomCard(0, cards[0]["title"]), // "Pomodoro Yap"
        ),
        const SizedBox(width: 12),
        // Denemeler kartı
        Expanded(
          child: _buildBottomCard(1, cards[1]["title"]), // "Denemeler"
        ),
      ],
    );
  }

  Widget _buildBottomCard(int index, String title) {
    return SizedBox(
      height: 85,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: InkWell(
                onTap: index == 0
                    ? () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => PomodoroPage(),
                          ),
                        );
                      }
                    : () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const ExamPage(),
                          ),
                        );
                      },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Constants.lightPrimaryTone,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          _getIconForBottomCard(index),
                          color: Constants.primaryColor,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: CustomText(
                          text: title,
                          color: Colors.black54,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForTopCard(int index) {
    switch (index) {
      case 1:
        return Icons.edit;
      case 2:
        return Icons.track_changes;
      case 3:
        return Icons.hourglass_bottom;
      default:
        return Icons.help_outline;
    }
  }

  IconData _getIconForBottomCard(int index) {
    switch (index) {
      case 0:
        return Icons.timer;
      case 1:
        return Icons.school;
      default:
        return Icons.help_outline;
    }
  }
}
