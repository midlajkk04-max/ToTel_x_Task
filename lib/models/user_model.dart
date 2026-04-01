class UserModel {
  final String id;
  final String name;
  final String phone;
  final String? imagePath;
  final int age;

  UserModel({
    required this.id,
    required this.name,
    required this.phone,
    this.imagePath,
    required this.age,
  });

  String get ageCategory => age > 60 ? 'Elder' : 'Younger';

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      imagePath: json['imagePath'],
      age: json['age'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'phone': phone,
        'imagePath': imagePath,
        'age': age,
      };
}