enum CareerStage {
  early_career,      // 0-3 years
  mid_career,        // 4-10 years
  senior_leadership,
}

enum TransitionType {
  same_role_new_company,
  role_change,        // e.g., IC → Manager
  industry_change,
  company_type_shift,  // Big Tech → Startup
}

class UserModel {
  final String id;
  final String email;
  final String? displayName;
  final String? firstName;
  final String? lastName;
  final String? currentRole;
  final String? targetRole;
  final String? currentIndustry;
  final String? targetIndustry;
  final CareerStage? careerStage;
  final List<TransitionType> transitionTypes;
  final String? profilePhotoUrl;
  final String? createdAt;

  UserModel({
    required this.id,
    required this.email,
    this.displayName,
    this.firstName,
    this.lastName,
    this.currentRole,
    this.targetRole,
    this.currentIndustry,
    this.targetIndustry,
    this.careerStage,
    this.transitionTypes = const [],
    this.profilePhotoUrl,
    this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final firstName = json['first_name'] as String?;
    final lastName = json['last_name'] as String?;
    final displayName = json['display_name'] as String?;
    
    CareerStage? careerStage;
    if (json['career_stage'] != null) {
      careerStage = CareerStage.values.firstWhere(
        (e) => e.toString().split('.').last == json['career_stage'],
        orElse: () => CareerStage.early_career,
      );
    }

    List<TransitionType> transitionTypes = [];
    if (json['transition_types'] != null && json['transition_types'] is List) {
      transitionTypes = (json['transition_types'] as List).map((t) {
        return TransitionType.values.firstWhere(
          (e) => e.toString().split('.').last == t,
          orElse: () => TransitionType.same_role_new_company,
        );
      }).toList();
    }
    
    return UserModel(
      id: json['user_id'] ?? '',
      email: json['email'] ?? '',
      displayName: displayName ?? firstName,
      firstName: firstName,
      lastName: lastName,
      currentRole: json['current_role'],
      targetRole: json['target_role'],
      currentIndustry: json['current_industry'],
      targetIndustry: json['target_industry'],
      careerStage: careerStage,
      transitionTypes: transitionTypes,
      profilePhotoUrl: json['profile_photo_url'],
      createdAt: json['created_at'],
    );
  }
}
