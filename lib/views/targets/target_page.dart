import 'package:flutter/material.dart';
import 'package:student_track/constants/constants.dart';
import 'package:student_track/helpers/data_helper.dart';
import 'package:student_track/views/targets/target_card.dart';

class TargetPage extends StatefulWidget {
  final String studentId;

  const TargetPage({super.key, required this.studentId});

  @override
  State<TargetPage> createState() => _TargetPageState();
}

class _TargetPageState extends State<TargetPage> with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> targets = [];
  bool isLoading = true;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _fetchTargets();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchTargets() async {
    setState(() {
      isLoading = true;
    });
    try {
      targets = await DataHelper.getTargetsData(widget.studentId);
      setState(() {
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

  double get totalProgress {
    if (targets.isEmpty) return 0;
    final tamamlanan = targets.where((t) => t['tamamlandi'] == true).length;
    return tamamlanan / targets.length;
  }

  List<Map<String, dynamic>> get yapilacaklar {
    final now = DateTime.now();
    return targets.where((t) {
      if (t['tamamlandi'] == true) return false;
      try {
        final targetDate = DateTime.parse(t['tarih']);
        return targetDate.isAfter(now) || targetDate.isAtSameMomentAs(now);
      } catch (e) {
        return false; // Geçersiz tarih formatı varsa bu hedefi dahil etme
      }
    }).toList();
  }

  List<Map<String, dynamic>> get gecikenHedefler {
    final now = DateTime.now();
    return targets.where((t) {
      if (t['tamamlandi'] == true) return false;
      try {
        final targetDate = DateTime.parse(t['tarih']);
        return targetDate.isBefore(now);
      } catch (e) {
        return false; // Geçersiz tarih formatı varsa bu hedefi dahil etme
      }
    }).toList();
  }

  List<Map<String, dynamic>> get tamamlanan {
    return targets.where((t) {
      return t['tamamlandi'] == true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hedeflerim'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Constants.primaryColor,
          unselectedLabelColor: Constants.primaryWhiteTone,
          indicatorColor: Constants.primaryColor,
          tabs: const [
            Tab(text: 'Yapılacaklar'),
            Tab(text: 'Yapılmayan'),
            Tab(text: 'Tamamlanan'),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : TabBarView(
                      controller: _tabController,
                      children: [
                        // Yapılacaklar
                        yapilacaklar.isEmpty
                            ? Center(
                                child: Text(
                                  'Henüz yapılacak hedefiniz yok',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              )
                            : ListView.builder(
                                itemCount: yapilacaklar.length,
                                itemBuilder: (context, index) {
                                  return TargetCard(
                                    target: yapilacaklar[index],
                                    studentId: widget.studentId,
                                    onChanged: () {
                                      setState(() {
                                        _fetchTargets();
                                      });
                                    },
                                    isLate: false,
                                  );
                                },
                              ),
                        // Yapılmayan (Geciken Hedefler)
                        gecikenHedefler.isEmpty
                            ? Center(
                                child: Text(
                                  'Geciken hedefiniz yok',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              )
                            : ListView.builder(
                                itemCount: gecikenHedefler.length,
                                itemBuilder: (context, index) {
                                  return TargetCard(
                                    target: gecikenHedefler[index],
                                    studentId: widget.studentId,
                                    onChanged: () {
                                      setState(() {
                                        _fetchTargets();
                                      });
                                    },
                                    isLate: true,
                                  );
                                },
                              ),
                        // Tamamlanan
                        tamamlanan.isEmpty
                            ? Center(
                                child: Text(
                                  'Tamamlanan hedefiniz yok',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              )
                            : ListView.builder(
                                itemCount: tamamlanan.length,
                                itemBuilder: (context, index) {
                                  return TargetCard(
                                    target: tamamlanan[index],
                                    studentId: widget.studentId,
                                    onChanged: () {
                                      setState(() {
                                        _fetchTargets();
                                      });
                                    },
                                    isLate: false,
                                  );
                                },
                              ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}