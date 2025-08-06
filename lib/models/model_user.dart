class ModelUser {
  String name;
  String school;
  String grade;
  String age;
  String phone;
  String email;

  ModelUser({
    required this.name,
    required this.school,
    required this.grade,
    required this.age,
    required this.phone,
    required this.email,
  });

  // JSON'a dönüştürme
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'school': school,
      'grade': grade,
      'age': age,
      'phone': phone,
      'email': email,
    };
  }

  // JSON'dan dönüştürme
  factory ModelUser.fromJson(Map<String, dynamic> json) {
    return ModelUser(
      name: json['name'] ?? '',
      school: json['school'] ?? '',
      grade: json['grade'] ?? '',
      age: json['age'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
    );
  }

  // örnek kullanıcı 
  factory ModelUser.sample() {
    return ModelUser(
      name: 'Safiye Yılmaz',
      school: 'İstanbul Lisesi',
      grade: '11. Sınıf',
      age: '16',
      phone: '+90 555 123 45 67',
      email: 'safiye@example.com',
    );
  }
}
