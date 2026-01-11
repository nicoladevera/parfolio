class UserModel {
  final String id;
  final String email;
  final String? displayName;
  final String? firstName;
  final String? createdAt;

  UserModel({
    required this.id,
    required this.email,
    this.displayName,
    this.firstName,
    this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final firstName = json['first_name'] as String?;
    final displayName = json['display_name'] as String?;
    
    return UserModel(
      id: json['user_id'] ?? '',
      email: json['email'] ?? '',
      displayName: displayName ?? firstName, // Fallback to first_name
      firstName: firstName,
      createdAt: json['created_at'],
    );
  }
}
