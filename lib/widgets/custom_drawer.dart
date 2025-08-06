// custom_drawer.dart
import 'package:flutter/material.dart';
import 'package:student_track/constants/constants.dart';
import 'package:student_track/widgets/custom_text.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Constants.primaryWhiteTone,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
            color: Constants.primaryColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: 30,
                    color: Constants.primaryColor,
                  ),
                ),
                const SizedBox(height: 10),
                const CustomText(
                  text: "sena merdin",
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                ),
                const CustomText(
                  text: "sena@gmail.com",
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                  fontSize: 12,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ListTile(
            leading: Icon(Icons.description),
            title: Text('Denemelerim'),
          ),
          ListTile(leading: Icon(Icons.book), title: Text('Kitaplarım')),
          ListTile(leading: Icon(Icons.push_pin), title: Text('Konularım')),
          ListTile(
            leading: Icon(Icons.bar_chart),
            title: Text('İlerleme Grafiğim'),
          ),
          ListTile(
            leading: Icon(Icons.logout_rounded),
            title: Text('Çıkış Yap'),
          ),
        ],
      ),
    );
  }
}
