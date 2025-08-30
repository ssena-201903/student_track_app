import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student_track/constants/constants.dart';
import 'package:student_track/providers/user_provider.dart';
import 'package:student_track/views/exams/exam_page.dart';
import 'package:student_track/views/home/student_books_page.dart';
import 'package:student_track/views/subjects/courses_page.dart';
import 'package:student_track/widgets/custom_text.dart';
import 'package:student_track/features/auth/data/auth_repository.dart';

class CustomDrawer extends ConsumerWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider);

    return Drawer(
      backgroundColor: Constants.primaryWhiteTone,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
            color: Constants.primaryColor,
            child: userAsync.when(
              data: (user) => Column(
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
                  CustomText(
                    text: user.name,
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                  ),
                  CustomText(
                    text: user.email,
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                    fontSize: 12,
                  ),
                ],
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(child: Text('Hata: $error')),
            ),
          ),
          const SizedBox(height: 20),
          ListTile(
            leading: Icon(Icons.description),
            title: Text('Denemelerim'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => ExamPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.book), 
            title: Text('Kitaplarım'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => StudentBooksPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.push_pin), 
            title: Text('Konularım'),
            onTap: () {
              Navigator.pop(context);
              userAsync.when(
                data: (user) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CoursesPage(studentId: user.id),
                    ),
                  );
                },
                loading: () => {},
                error: (error, _) => ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Kullanıcı yüklenemedi: $error')),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.bar_chart),
            title: Text('İlerleme Grafiğim'),
          ),
          ListTile(
            leading: Icon(Icons.logout_rounded),
            title: Text('Çıkış Yap'),
            onTap: () async {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Çıkış yapılıyor...')),
              );
              await ref.read(authRepositoryProvider).signOut();
              // AuthWrapper otomatik yönlendirme yapacak
            },
          ),
        ],
      ),
    );
  }
}