import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text("Merhaba Safiye!"),
                const SizedBox(width: 10),
                Icon(Icons.waving_hand),
              ],
            ),
            Text(
              "Bugün harika bir gün olacak!",
              style: TextStyle(fontSize: 14, color: Colors.black38),
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: List.generate(
                4,
                (index) => AnaKartWidget(index: index),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AnaKartWidget extends StatelessWidget {
  final int index;

  const AnaKartWidget({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (MediaQuery.of(context).size.width - 48) / 2, // 2 kart yan yana
      height: 120,
      decoration: BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          'Kart ${index + 1}',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
