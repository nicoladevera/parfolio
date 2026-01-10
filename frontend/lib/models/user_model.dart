class UserModel {
  final String id;
  final String email;
  final String? displayName;
  final String? createdAt;

  UserModel({
    required this.id,
    required this.email,
    this.displayName,
    this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['user_id'] ?? '',
      email: json['email'] ?? '',
      displayName: json['display_name'],
      createdAt: json['created_at'],
    );
  }
}
