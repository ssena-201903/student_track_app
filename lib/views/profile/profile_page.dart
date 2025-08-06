import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:student_track/constants/constants.dart';
import 'package:student_track/widgets/custom_text.dart';
import 'package:student_track/models/model_user.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late ModelUser currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = ModelUser.sample(); // İleride veritabanından çekilecek
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CustomText(
              text: "Profilim",
              color: Constants.primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 50,
              backgroundColor: Constants.primaryColor,
              child: const Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 16),

            // Alanlar
            _buildEditableTile(title: "İsim", value: currentUser.name),
            _buildEditableTile(title: "Okul", value: currentUser.school),
            _buildStaticTile(title: "Sınıf", value: currentUser.grade),
            _buildEditableTile(title: "Yaş", value: currentUser.age),
            _buildEditableTile(title: "Telefon", value: currentUser.phone),
            _buildStaticTile(title: "E-posta", value: currentUser.email),
          ],
        ),
      ),
    );
  }

  /// Düzenlenebilir alanlar için
  Widget _buildEditableTile({required String title, required String value}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: _getIconForField(title),
        title: Text(title),
        subtitle: Text(value),
        trailing: IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () {
            _showEditDialog(title, value);
          },
        ),
      ),
    );
  }

  /// Sadece gösterim için olanlar
  Widget _buildStaticTile({required String title, required String value}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: _getIconForField(title),
        title: Text(title),
        subtitle: Text(value),
      ),
    );
  }

  Icon _getIconForField(String fieldName) {
    switch (fieldName.toLowerCase()) {
      case "isim":
        return const Icon(Icons.person);
      case "okul":
        return const Icon(Icons.school);
      case "sınıf":
        return const Icon(Icons.class_);
      case "yaş":
        return const Icon(Icons.cake);
      case "telefon":
        return const Icon(Icons.phone);
      case "e-posta":
        return const Icon(Icons.email);
      default:
        return const Icon(Icons.info_outline);
    }
  }

  void _showEditDialog(String title, String currentValue) {
    final controller = TextEditingController(text: currentValue);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("$title Güncelle"),
          content: title == "Telefon"
              ? IntlPhoneField(
                  initialValue: currentValue,
                  decoration: const InputDecoration(
                    labelText: 'Telefon Numarası',
                    border: OutlineInputBorder(),
                  ),
                  initialCountryCode: 'TR',
                  onChanged: (phone) {
                    controller.text = phone.completeNumber;
                  },
                )
              : TextField(
                  controller: controller,
                  decoration: InputDecoration(hintText: "$title giriniz"),
                ),
          actions: [
            TextButton(
              child: const Text("İptal"),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: const Text("Kaydet"),
              onPressed: () {
                setState(() {
                  switch (title) {
                    case "İsim":
                      currentUser.name = controller.text;
                      break;
                    case "Okul":
                      currentUser.school = controller.text;
                      break;
                    case "Yaş":
                      currentUser.age = controller.text;
                      break;
                    case "Telefon":
                      currentUser.phone = controller.text;
                      break;
                  }
                });
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
