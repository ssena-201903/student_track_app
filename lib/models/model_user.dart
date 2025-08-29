class ModelUser {
  final String id;
  final String name;
  final String school;
  final String grade;
  final String phone;
  final String email;
  final String weeklyStudy;

  ModelUser({
    required this.id,
    required this.name,
    required this.school,
    required this.grade,
    required this.phone,
    required this.email,
    required this.weeklyStudy,
  });

  // Varsayılan kullanıcı (Firestore'dan veri çekilemediğinde)
  factory ModelUser.sample() {
    return ModelUser(
      id: "0",
      name: "Misafir Kullanıcı",
      school: "Bilinmiyor",
      grade: "0",
      phone: "Bilinmiyor",
      email: "misafir@example.com",
      weeklyStudy: "0",
    );
  }

  ModelUser copyWith({
    String? id,
    String? name,
    String? school,
    String? grade,
    String? phone,
    String? email,
    String? weeklyStudy,
  }) {
    return ModelUser(
      id: id ?? this.id,
      name: name ?? this.name,
      school: school ?? this.school,
      grade: grade ?? this.grade,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      weeklyStudy: weeklyStudy ?? this.weeklyStudy,
    );
  }

  factory ModelUser.fromFirestore(Map<String, dynamic> data, String id) {
    return ModelUser(
      id: id,
      name: data['name'] ?? 'Bilinmiyor',
      school: data['school'] ?? 'Bilinmiyor',
      grade: data['course'] ?? '0',
      phone: data['phone'] ?? 'Bilinmiyor',
      email: data['email'] ?? 'Bilinmiyor',
      weeklyStudy: data['weeklyStudyTime'] ?? '0',
    );
  }
}