class UserModel {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String dateOfBirth;
  final String role;
  final String address;

  UserModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.dateOfBirth,
    required this.role,
    required this.address,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'email': email,
      'dateOfBirth': dateOfBirth,
      'role': role,
      'address': address,
    };
  }
}