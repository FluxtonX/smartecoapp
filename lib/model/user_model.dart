import 'dart:math' as math;

class UserModel {
  final String id;
  final String phone;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? userType;
  final String? role;
  final String? referralCode;
  final String? avatarUrl;
  final int? ecoPoints;
  final String? ecoTier;
  final bool? isNewUser;

  String get displayFirstName {
    if (firstName != null && firstName!.isNotEmpty) return firstName!;
    const chars = 'abcdefghijklmnopqrstuvwxyz';
    final random = math.Random(id.hashCode); // Use id for consistent random name per user
    final name = List.generate(6, (index) => chars[random.nextInt(chars.length)]).join();
    return name[0].toUpperCase() + name.substring(1);
  }

  UserModel({
    required this.id,
    required this.phone,
    this.firstName,
    this.lastName,
    this.email,
    this.userType,
    this.role,
    this.referralCode,
    this.avatarUrl,
    this.ecoPoints,
    this.ecoTier,
    this.isNewUser,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      phone: json['phone'] ?? '',
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      userType: json['userType'],
      role: json['role'],
      referralCode: json['referralCode'],
      avatarUrl: json['avatarUrl'],
      ecoPoints: json['ecoPoints'],
      ecoTier: json['ecoTier'],
      isNewUser: json['isNewUser'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phone': phone,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'userType': userType,
      'role': role,
      'referralCode': referralCode,
      'avatarUrl': avatarUrl,
      'ecoPoints': ecoPoints,
      'ecoTier': ecoTier,
      'isNewUser': isNewUser,
    };
  }
}
