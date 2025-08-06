// custom_drawer.dart
import 'package:flutter/material.dart';
import 'package:student_track/widgets/custom_text.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.indigo,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // sola hizalama
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 30, color: Colors.indigo),
                ),
                const SizedBox(height: 10),
                const CustomText(
                  text: "sena merdin",
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                  fontSize: 16,
                ),
              ],
            ),
          ),

          ListTile(leading: Icon(Icons.home), title: Text('Ana Sayfa')),
          ListTile(leading: Icon(Icons.analytics), title: Text('İstatistik')),
          ListTile(leading: Icon(Icons.person), title: Text('Profil')),
        ],
      ),
    );
  }
}
