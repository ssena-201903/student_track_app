import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:student_track/models/model_exam.dart';
import 'package:student_track/models/model_subject.dart';
import 'package:student_track/constants/constants.dart';

class ExamPage extends StatefulWidget {
  const ExamPage({super.key});

  @override
  State<ExamPage> createState() => _ExamPageState();
}

class _ExamPageState extends State<ExamPage> with TickerProviderStateMixin {
  late TabController _tabController;
  final List<Trial> _exams = [
    // Örnek veriler
    Trial(
      id: "1",
      title: "Deneme Sınavı 1",
      publisher: "Okyanus Yayınları",
      category: "TYT",
      date: DateTime.now().subtract(const Duration(days: 7)),
      subjects: {
        "Matematik": SubjectStat(correct: 25, wrong: 5, blank: 10),
        "Türkçe": SubjectStat(correct: 30, wrong: 8, blank: 2),
        "Fen Bilimleri": SubjectStat(correct: 15, wrong: 3, blank: 2),
      },
      note: "İlk denemem, matematik konularını tekrar etmeliyim.",
    ),
    Trial(
      id: "2",
      title: "Deneme Sınavı 2",
      publisher: "Karekök Yayınları",
      category: "AYT",
      date: DateTime.now().subtract(const Duration(days: 3)),
      subjects: {
        "Matematik": SubjectStat(correct: 28, wrong: 7, blank: 5),
        "Fizik": SubjectStat(correct: 10, wrong: 4, blank: 0),
        "Kimya": SubjectStat(correct: 8, wrong: 5, blank: 1),
      },
      note: "Fizik konularında gelişme var.",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Denemelerim"),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "TYT"),
            Tab(text: "AYT"),
            Tab(text: "Tümü"),
          ],
        ),
      ),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildExamList("TYT"),
                _buildExamList("AYT"),
                _buildExamList("Tümü"),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToAddExam(),
        icon: const Icon(Icons.add),
        label: const Text("Sınav Ekle"),
      ),
    );
  }

  Widget _buildHeader() {
    final tytCount = _exams.where((e) => e.category == "TYT").length;
    final aytCount = _exams.where((e) => e.category == "AYT").length;

    // Ortalama net hesaplama
    double tytAvgNet = 0;
    double aytAvgNet = 0;

    if (tytCount > 0) {
      final tytExams = _exams.where((e) => e.category == "TYT");
      tytAvgNet =
          tytExams.map((e) => _calculateTotalNet(e)).reduce((a, b) => a + b) /
          tytCount;
    }

    if (aytCount > 0) {
      final aytExams = _exams.where((e) => e.category == "AYT");
      aytAvgNet =
          aytExams.map((e) => _calculateTotalNet(e)).reduce((a, b) => a + b) /
          aytCount;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              _statCard("TYT", tytCount, tytAvgNet),
              const SizedBox(width: 12),
              _statCard("AYT", aytCount, aytAvgNet),
              const SizedBox(width: 12),
              _statCard("Toplam", _exams.length, null),
            ],
          ),
          const SizedBox(height: 16),
          Divider(),
        ],
      ),
    );
  }

  Widget _statCard(String title, int count, double? averageNet) => Expanded(
    child: SizedBox(
      height: 90,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    radius: 10,
                    backgroundColor: Constants.primaryColor,
                    child: Text(
                      "$count",
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              if (averageNet != null) ...[
                const SizedBox(height: 4),
                Text(
                  "Ort Net: ${averageNet.toStringAsFixed(1)}",
                  style: TextStyle(fontSize: 14, color: Constants.primaryColor),
                ),
              ],
            ],
          ),
        ),
      ),
    ),
  );

  Widget _buildExamList(String filter) {
    final list = filter == "Tümü"
        ? _exams
        : _exams.where((e) => e.category == filter).toList();

    if (list.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.quiz_outlined,
              size: 64,
              color: Constants.lightPrimaryTone,
            ),
            const SizedBox(height: 16),
            Text(
              "Henüz ${filter == "Tümü" ? "" : filter} sınav eklenmedi",
              style: TextStyle(fontSize: 18, color: Constants.lightPrimaryTone),
            ),
            const SizedBox(height: 8),
            const Text("Yeni sınav eklemek için + butonuna tıklayın"),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: list.length,
      itemBuilder: (context, i) {
        final exam = list[i];
        return _buildExamCard(exam);
      },
    );
  }

  Widget _buildExamCard(Trial exam) {
    final totalNet = _calculateTotalNet(exam);
    final totalQuestions = exam.subjects.values
        .map((s) => s.correct + s.wrong + s.blank)
        .reduce((a, b) => a + b);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: Constants.primaryColor,
          child: Text(
            totalNet.toStringAsFixed(1),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
        title: Text(
          exam.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${exam.publisher} • ${DateFormat("dd.MM.yyyy").format(exam.date)}",
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Constants.lightPrimaryTone,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Constants.primaryColor),
                  ),
                  child: Text(
                    exam.category,
                    style: TextStyle(
                      color: Constants.primaryColor,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  "$totalQuestions soru",
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Ders Bazında Sonuçlar:",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 12),
                ...exam.subjects.entries.map(
                  (entry) => _buildSubjectRow(entry),
                ),
                const Divider(height: 24),
                if (exam.note.isNotEmpty) ...[
                  const Text(
                    "Notlar:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    exam.note,
                    style: const TextStyle(fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 16),
                ],
                Row(
                  children: [
                    // Expanded(
                    //   child: ElevatedButton.icon(
                    //     onPressed: () => _showProgressChart(exam),
                    //     icon: const Icon(Icons.show_chart),
                    //     label: const Text("İlerleme Grafiği"),
                    //   ),
                    // ),
                    // const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _editExam(exam),
                        icon: const Icon(Icons.edit),
                        label: const Text("Düzenle"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectRow(MapEntry<String, SubjectStat> entry) {
    final subject = entry.key;
    final stat = entry.value;
    final net = _calculateSubjectNet(stat);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              subject,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Expanded(
                  child: _buildStatChip(
                    "D",
                    stat.correct,
                    Constants.primaryColor,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildStatChip(
                    "Y",
                    stat.wrong,
                    Constants.primaryColor,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildStatChip(
                    "B",
                    stat.blank,
                    Constants.primaryColor,
                  ),
                ),
                const SizedBox(width: 10),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              "${net.toStringAsFixed(1)} Net",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Constants.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(String label, int value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Constants.lightPrimaryTone,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color, width: 1),
      ),
      child: Text(
        "$label:$value",
        style: TextStyle(
          fontSize: 10,
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  double _calculateTotalNet(Trial exam) {
    double totalNet = 0;
    exam.subjects.values.forEach((stat) {
      totalNet += _calculateSubjectNet(stat);
    });
    return totalNet;
  }

  double _calculateSubjectNet(SubjectStat stat) {
    // Net = Doğru - (Yanlış / 4)
    return stat.correct - (stat.wrong / 4);
  }

  void _navigateToAddExam() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddExamPage()),
    );

    if (result != null && result is Trial) {
      setState(() {
        _exams.add(result);
      });
    }
  }

  void _editExam(Trial exam) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddExamPage(examToEdit: exam)),
    ).then((result) {
      if (result != null && result is Trial) {
        setState(() {
          final index = _exams.indexWhere((e) => e.id == exam.id);
          if (index != -1) {
            _exams[index] = result;
          }
        });
      }
    });
  }
}

// Ayrı sayfa olarak sınav ekleme
class AddExamPage extends StatefulWidget {
  final Trial? examToEdit;

  const AddExamPage({super.key, this.examToEdit});

  @override
  State<AddExamPage> createState() => _AddExamPageState();
}

class _AddExamPageState extends State<AddExamPage> {
  final _formKey = GlobalKey<FormState>();
  late String title;
  late String publisher;
  late String category;
  late DateTime selectedDate;
  late String note;

  final Map<String, Map<String, TextEditingController>> dersControllers = {
    "Matematik": {
      "dogru": TextEditingController(),
      "yanlis": TextEditingController(),
      "bos": TextEditingController(),
    },
    "Türkçe": {
      "dogru": TextEditingController(),
      "yanlis": TextEditingController(),
      "bos": TextEditingController(),
    },
    "Fen Bilimleri": {
      "dogru": TextEditingController(),
      "yanlis": TextEditingController(),
      "bos": TextEditingController(),
    },
    "Sosyal Bilimler": {
      "dogru": TextEditingController(),
      "yanlis": TextEditingController(),
      "bos": TextEditingController(),
    },
  };

  @override
  void initState() {
    super.initState();
    if (widget.examToEdit != null) {
      final exam = widget.examToEdit!;
      title = exam.title;
      publisher = exam.publisher;
      category = exam.category;
      selectedDate = exam.date;
      note = exam.note;

      // Mevcut verileri form alanlarına yükle
      exam.subjects.forEach((subject, stat) {
        if (dersControllers.containsKey(subject)) {
          dersControllers[subject]!["dogru"]!.text = stat.correct.toString();
          dersControllers[subject]!["yanlis"]!.text = stat.wrong.toString();
          dersControllers[subject]!["bos"]!.text = stat.blank.toString();
        }
      });
    } else {
      title = "";
      publisher = "";
      category = "TYT";
      selectedDate = DateTime.now();
      note = "";
    }
  }

  @override
  void dispose() {
    dersControllers.values.forEach((controllers) {
      controllers.values.forEach((controller) => controller.dispose());
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.examToEdit != null ? "Sınavı Düzenle" : "Yeni Sınav Ekle",
        ),
        actions: [
          TextButton(
            onPressed: _saveExam,
            child: const Text("Kaydet", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBasicInfoSection(),
              const SizedBox(height: 24),
              _buildSubjectsSection(),
              const SizedBox(height: 24),
              _buildNotesSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBasicInfoSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Temel Bilgiler",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: title,
              decoration: const InputDecoration(
                labelText: "Deneme Adı",
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value?.isEmpty == true ? "Zorunlu alan" : null,
              onSaved: (value) => title = value ?? "",
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: publisher,
              decoration: const InputDecoration(
                labelText: "Yayınevi",
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value?.isEmpty == true ? "Zorunlu alan" : null,
              onSaved: (value) => publisher = value ?? "",
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: category,
              decoration: const InputDecoration(
                labelText: "Kategori",
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: "TYT", child: Text("TYT")),
                DropdownMenuItem(value: "AYT", child: Text("AYT")),
              ],
              onChanged: (value) => setState(() => category = value!),
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: _selectDate,
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: "Sınav Tarihi",
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                child: Text(DateFormat("dd.MM.yyyy").format(selectedDate)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubjectsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Ders Sonuçları",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...dersControllers.entries.map(
              (entry) => _buildSubjectInputs(entry),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubjectInputs(
    MapEntry<String, Map<String, TextEditingController>> entry,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            entry.key,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: entry.value["dogru"],
                  decoration: const InputDecoration(
                    labelText: "Doğru",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  controller: entry.value["yanlis"],
                  decoration: const InputDecoration(
                    labelText: "Yanlış",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  controller: entry.value["bos"],
                  decoration: const InputDecoration(
                    labelText: "Boş",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNotesSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Notlar",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: note,
              decoration: const InputDecoration(
                labelText: "Sınav hakkında notlarınız",
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              maxLines: 4,
              onSaved: (value) => note = value ?? "",
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  void _saveExam() {
    if (_formKey.currentState?.validate() == true) {
      _formKey.currentState!.save();

      final subjects = <String, SubjectStat>{};
      dersControllers.forEach((ders, ctrls) {
        final dogru = int.tryParse(ctrls["dogru"]!.text) ?? 0;
        final yanlis = int.tryParse(ctrls["yanlis"]!.text) ?? 0;
        final bos = int.tryParse(ctrls["bos"]!.text) ?? 0;

        if (dogru > 0 || yanlis > 0 || bos > 0) {
          subjects[ders] = SubjectStat(
            correct: dogru,
            wrong: yanlis,
            blank: bos,
          );
        }
      });

      final trial = Trial(
        id:
            widget.examToEdit?.id ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        publisher: publisher,
        category: category,
        date: selectedDate,
        subjects: subjects,
        note: note,
      );

      Navigator.pop(context, trial);
    }
  }
}
