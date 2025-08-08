class ModelUser {
  String name;
  String school;
  String grade;
  String phone;
  String email;
  String weeklyStudy;

  ModelUser({
    required this.name,
    required this.school,
    required this.grade,
    required this.phone,
    required this.email,
    required this.weeklyStudy,
  });

  // JSON'a dönüştürme
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'school': school,
      'grade': grade,
      'phone': phone,
      'email': email,
      'weeklyStudy': weeklyStudy,
    };
  }

  // JSON'dan dönüştürme
  factory ModelUser.fromJson(Map<String, dynamic> json) {
    return ModelUser(
      name: json['name'] ?? '',
      school: json['school'] ?? '',
      grade: json['grade'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      weeklyStudy: json['weeklyStudy'] ?? '',
    );
  }

  // örnek kullanıcı 
  factory ModelUser.sample() {
    return ModelUser(
      name: 'Safiye Yılmaz',
      school: 'İstanbul Lisesi',
      grade: 'yks',
      phone: '+90 555 123 45 67',
      email: 'safiye@example.com',
      weeklyStudy: '20',
    );
  }
}
