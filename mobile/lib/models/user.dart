import 'base_model.dart';

class UserModel extends BaseModel<UserModel> {
  UserModel({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.role,
    this.profileImageUrl,
    this.isActive = true,
  });

  final int? id;
  final String? name;
  final String? email;
  final String? phone;
  final String? role;
  final String? profileImageUrl;
  final bool isActive;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      role: json['role'] as String?,
      profileImageUrl: json['profile_image_url'] as String?,
      isActive: json['is_active'] as bool? ?? true,
    );
  }

  @override
  UserModel fromJson(Map<String, dynamic> json) {
    return UserModel.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
      'profile_image_url': profileImageUrl,
      'is_active': isActive,
    };
  }
}
