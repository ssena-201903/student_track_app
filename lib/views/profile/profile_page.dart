import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
        padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
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
            _buildEditableTile(title: "name", value: currentUser.name),
            _buildEditableTile(title: "school", value: currentUser.school),
            _buildStaticTile(title: "course", value: currentUser.grade),
            _buildEditableTile(title: "phone", value: currentUser.phone),
            _buildStaticTile(title: "email", value: currentUser.email),
            _buildStaticTile(title: "weeklyStudy", value: currentUser.weeklyStudy),
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
        title: Text(getLocalizedTitle(title)),
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
        title: Text(getLocalizedTitle(title)),
        subtitle: Text(value),
      ),
    );
  }

  Icon _getIconForField(String fieldName) {
    switch (fieldName) {
      case "name":
        return const Icon(Icons.person);
      case "school":
        return const Icon(Icons.school);
      case "course":
        return const Icon(Icons.class_);
      case "phone":
        return const Icon(Icons.phone);
      case "email":
        return const Icon(Icons.email);
      case "weeklyStudy":
        return const Icon(Icons.schedule);
      default:
        return const Icon(Icons.info_outline);
    }
  }

  String getLocalizedTitle(String fieldKey) {
  switch (fieldKey) {
    case "name":
      return "Ad";
    case "school":
      return "Okul";
    case "course":
      return "Sınıf";
    case "phone":
      return "Telefon";
    case "email":
      return "E-posta";
    case "weeklyStudy":
      return "Haftalık Çalışma Saati";
    default:
      return fieldKey;
  }
}


  List<TextInputFormatter> _getInputFormatters(String title) {
    switch (title) {
      case "name":
        return [
          LengthLimitingTextInputFormatter(50),
          FilteringTextInputFormatter.allow(RegExp(r'[a-zA-ZçÇğĞıİöÖşŞüÜ\s]')),
        ];
      case "school":
        return [LengthLimitingTextInputFormatter(100)];
      default:
        return [LengthLimitingTextInputFormatter(255)];
    }
  }

  void _showEditDialog(String title, String currentValue) {
    final controller = TextEditingController(text: currentValue);

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(16),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            ),
            child: IntrinsicHeight(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomText(
                    text: "${getLocalizedTitle(title)} Güncelle",
                    color: Constants.primaryColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                  const SizedBox(height: 12),
                  title == "Telefon"
                      ? IntlPhoneField(
                          initialValue: currentValue,
                          decoration: const InputDecoration(
                            labelText: 'Telefon Numarası',
                            border: OutlineInputBorder(),
                            counterText: '', // Karakter sayacını gizle
                          ),
                          initialCountryCode: 'TR',
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(
                              14,
                            ), // Max 14 karakter
                          ],
                          onChanged: (phone) {
                            controller.text = phone.completeNumber;
                          },
                        )
                      : TextField(
                          controller: controller,
                          inputFormatters: _getInputFormatters(title),
                          decoration: InputDecoration(
                            hintText: "$title giriniz",
                            border: const OutlineInputBorder(),
                            counterText: title == "Yaş"
                                ? null
                                : '', // Yaş için sayacı göster
                          ),
                          keyboardType: title == "Yaş"
                              ? TextInputType.number
                              : TextInputType.text,
                        ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        child: const Text("İptal"),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        child: const Text("Kaydet"),
                        onPressed: () {
                          setState(() {
                            switch (title) {
                              case "name":
                                currentUser.name = controller.text;
                                break;
                              case "school":
                                currentUser.school = controller.text;
                                break;
                              case "weeklyStudy":
                                currentUser.weeklyStudy = controller.text;
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
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
