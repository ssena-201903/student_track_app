import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:student_track/constants/constants.dart';

class PomodoroPage extends StatefulWidget {
  const PomodoroPage({super.key});

  @override
  State<PomodoroPage> createState() => _PomodoroPageState();
}

class _PomodoroPageState extends State<PomodoroPage> {
  // Audio player for sound effects
  late final AudioPlayer _audioPlayer;

  int selectedPomodoroDuration = 25;
  Duration workDuration = const Duration(minutes: 25);
  Duration breakDuration = const Duration(minutes: 5);

  Duration remainingTime = const Duration(minutes: 25);
  Duration totalWorkTime = Duration.zero;

  bool isRunning = false;
  bool isCompleted = false;
  bool isOnBreak = false;

  Timer? timer;

  List<String> completedPomodoros = [];
  int pomodoroRound = 1;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    timer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  // future to play sound in loop
  Future<void> _playAlertSound(String path) async {
    try {
      await _audioPlayer.setReleaseMode(ReleaseMode.loop);
      await _audioPlayer.play(AssetSource(path));
    } catch (e) {
      debugPrint("Error playing sound: $e");
    }
  }

  void _toggleTimer() {
    if (isRunning || isOnBreak) return; // Durdurma engeli
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (remainingTime.inSeconds > 0) {
          remainingTime -= const Duration(seconds: 1);
        } else {
          timer.cancel();
          isRunning = false;

          if (!isOnBreak) {
            // Pomodoro bitti
            totalWorkTime += workDuration;
            isCompleted = true;
            _showBreakDialog();
          } else {
            // Ara bitti
            isOnBreak = false;
            _showResumeDialog();
          }
        }
      });
    });

    setState(() {
      isRunning = true;
    });
  }

  void _showBreakDialog() {
    // önce ses çal
    _playAlertSound("sounds/goodresult.mp3");
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Pomodoro tamamlandı"),
        content: const Text("Ara vermek ister misin?"),
        actions: [
          TextButton(
            onPressed: () async {
              await _audioPlayer.stop(); // Ses durdur
              Navigator.of(context).pop();
              startBreak();
            },
            child: const Text("Ara Ver (5 dk)"),
          ),

          TextButton(
            onPressed: () async {
              await _audioPlayer.stop();
              Navigator.of(context).pop();
              setState(() {
                completedPomodoros.add(
                  "${pomodoroRound++}. Tur: ${workDuration.inMinutes} dk",
                );
                resetTimer();
              });
            },
            child: const Text("Bitir"),
          ),
        ],
      ),
    );
  }

  void _showResumeDialog() {
    // önce ses çal
    _playAlertSound("sounds/warning.mp3");
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Ara bitti"),
        content: const Text("Hazırsan ikinci yarıya başlayabilirsin."),
        actions: [
          TextButton(
            onPressed: () async {
              await _audioPlayer.stop(); // Ses durdur
              Navigator.of(context).pop();
              setState(() {
                remainingTime = workDuration;
                completedPomodoros.add(
                  "${pomodoroRound++}. Tur: ${workDuration.inMinutes * 2} dk",
                );
                startTimer();
              });
            },
            child: const Text("Tamam"),
          ),
          TextButton(
            onPressed: () async {
              await _audioPlayer.stop(); // Ses durdur
              Navigator.of(context).pop();
              setState(() {
                completedPomodoros.add(
                  "${pomodoroRound++}. Tur: ${workDuration.inMinutes} dk",
                );
                resetTimer();
              });
            },
            child: const Text("İptal"),
          ),
        ],
      ),
    );
  }

  void startBreak() {
    setState(() {
      isOnBreak = true;
      remainingTime = breakDuration;
      isCompleted = false;
    });
    startTimer();
  }

  void resetTimer() {
    timer?.cancel();
    setState(() {
      remainingTime = workDuration;
      isRunning = false;
      isCompleted = false;
      isOnBreak = false;
    });
  }

  String _formatMinutes(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  String _formatDurationReadable(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    return "$hours saat $minutes dk";
  }

  @override
  Widget build(BuildContext context) {
    String formattedMinutes = _formatMinutes(remainingTime);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pomodoro"),
        actions: [
          TextButton.icon(
            onPressed: resetTimer,
            icon: const Icon(Icons.refresh, color: Colors.white),
            label: const Text(
              "Yeniden Başlat",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned(
            top: 20,
            right: 20,
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Bugünkü Çalışma Süresi: ",
                    style: TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                  TextSpan(
                    text: _formatDurationReadable(totalWorkTime),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Constants.primaryBlackTone,
                    ),
                  ),
                ],
              ),
            ),
          ),

          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Dropdown sadece pomodoro ve ara sırasında değil
                  if (!isRunning && !isOnBreak)
                    DropdownButton<int>(
                      value: selectedPomodoroDuration,
                      items: const [
                        DropdownMenuItem(value: 25, child: Text("25 Dakika")),
                        DropdownMenuItem(value: 30, child: Text("30 Dakika")),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            selectedPomodoroDuration = value;
                            workDuration = Duration(minutes: value);
                            remainingTime = workDuration;
                          });
                        }
                      },
                    ),

                  const SizedBox(height: 24),

                  // Üstte süre ve kalan metni, sadece aktifken
                  if (isRunning)
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            isOnBreak ? "Ara bitmesine " : "Ara vermene ",
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            formattedMinutes,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const Text(
                            " kaldı",
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 24),

                  // Büyük zaman sayacı
                  Text(
                    formattedMinutes,
                    style: const TextStyle(
                      fontSize: 64,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 40),

                  if (!isRunning)
                    ElevatedButton(
                      onPressed: (isRunning || isOnBreak) ? null : _toggleTimer,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                      ),
                      child: const Text(
                        "Başlat",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),

                  const SizedBox(height: 40),

                  // if (completedPomodoros.isNotEmpty)
                  //   Container(
                  //     width: double.infinity,
                  //     padding: const EdgeInsets.all(16),
                  //     decoration: BoxDecoration(
                  //       color: Color.fromARGB(255, 200, 229, 243),
                  //       borderRadius: BorderRadius.circular(8),
                  //     ),
                  //     child: Column(
                  //       crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: [
                  //         CustomText(
                  //           text: "Bugünkü Pomodorolarınız:",
                  //           color: Constants.primaryBlackTone,
                  //           fontWeight: FontWeight.w600,
                  //           fontSize: 16,
                  //         ),
                  //         ...completedPomodoros.map((e) => Text(e)).toList(),
                  //       ],
                  //     ),
                  //   ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
