import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class StudentBooksPage extends StatefulWidget {
  const StudentBooksPage({super.key});

  @override
  State<StudentBooksPage> createState() => _StudentBooksPageState();
}

class _StudentBooksPageState extends State<StudentBooksPage> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Oturum açılmadı. Lütfen giriş yapın.')),
      );
    }

    final String uid = user.uid;
    final docRef = FirebaseFirestore.instance.collection('students').doc(uid); 

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kitaplarım'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: docRef.get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Hata: ${snapshot.error}'));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Doküman bulunamadı.'));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>?;
          final Map<String, dynamic> courseBooks = data?['courseBooks'] ?? {};

          if (courseBooks.isEmpty) {
            return const Center(child: Text('Kitap bulunamadı.'));
          }

          return ListView(
            children: courseBooks.keys.map((subject) {
              final List<dynamic> books = courseBooks[subject] ?? [];
              return ExpansionTile(
                title: Text(subject),
                children: books.map((book) {
                  return ListTile(
                    title: Text(book.toString()),
                  );
                }).toList(),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}