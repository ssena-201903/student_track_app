import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:student_track/constants/constants.dart';
import 'package:student_track/providers/user_provider.dart';
import 'package:student_track/widgets/custom_text.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profilim"),
      ),
      body: userAsync.when(
        data: (currentUser) => Padding(
          padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Constants.primaryColor,
                  child: const Icon(Icons.person, size: 50, color: Colors.white),
                ),
                const SizedBox(height: 16),
            
                // Alanlar
                _buildEditableTile(
                  title: "name",
                  value: currentUser.name,
                  onSave: (value) => ref.read(userProvider.notifier).updateField("name", value),
                ),
                _buildEditableTile(
                  title: "school",
                  value: currentUser.school,
                  onSave: (value) => ref.read(userProvider.notifier).updateField("school", value),
                ),
                _buildStaticTile(title: "course", value: currentUser.grade),
                _buildEditableTile(
                  title: "phone",
                  value: currentUser.phone,
                  onSave: (value) => ref.read(userProvider.notifier).updateField("phone", value),
                  isPhone: true,
                ),
                _buildStaticTile(title: "email", value: currentUser.email),
                _buildStaticTile(title: "weeklyStudy", value: currentUser.weeklyStudy),
              ],
            ),
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Hata: $error')),
      ),
    );
  }

  /// Düzenlenebilir alanlar için
  Widget _buildEditableTile({
    required String title,
    required String value,
    required void Function(String) onSave,
    bool isPhone = false,
  }) {
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
            _showEditDialog(title, value, isPhone, onSave);
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
      case "weeklyStudy":
        return [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(3),
        ];
      default:
        return [LengthLimitingTextInputFormatter(255)];
    }
  }

  void _showEditDialog(String title, String currentValue, bool isPhone, void Function(String) onSave) {
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
                  isPhone
                      ? IntlPhoneField(
                          initialValue: currentValue,
                          decoration: const InputDecoration(
                            labelText: 'Telefon Numarası',
                            border: OutlineInputBorder(),
                            counterText: '',
                          ),
                          initialCountryCode: 'TR',
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(14),
                          ],
                          onChanged: (phone) {
                            controller.text = phone.completeNumber;
                          },
                        )
                      : TextField(
                          controller: controller,
                          inputFormatters: _getInputFormatters(title),
                          decoration: InputDecoration(
                            labelText: getLocalizedTitle(title),
                            border: const OutlineInputBorder(),
                          ),
                          keyboardType: title == "weeklyStudy"
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
                          if (controller.text.isNotEmpty) {
                            onSave(controller.text);
                            Navigator.pop(context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("${getLocalizedTitle(title)} boş olamaz"),
                              ),
                            );
                          }
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