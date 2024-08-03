class UserModel {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String password;
  final String dateOfBirth;
  final String role; 

  UserModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.password,
    required this.dateOfBirth,
    required this.role,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'email': email,
      'dateOfBirth': dateOfBirth,
      'role': role,
    };
  }
}