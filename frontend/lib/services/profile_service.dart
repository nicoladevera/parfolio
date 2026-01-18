import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class ProfileService {
  // Use 10.0.2.2 for Android emulator, localhost for iOS/Web
  static const String baseUrl = 'http://localhost:8000';
  
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<UserModel> getProfile() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) throw Exception('No user logged in');

      final token = await user.getIdToken();
      
      final response = await http.get(
        Uri.parse('$baseUrl/profile'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to fetch profile: ${response.body}');
      }

      return UserModel.fromJson(jsonDecode(response.body));
    } catch (e) {
      throw Exception('Get profile failed: $e');
    }
  }

  Future<UserModel> updateProfile({
    String? currentRole,
    String? targetRole,
    String? currentIndustry,
    String? targetIndustry,
    CareerStage? careerStage,
    List<TransitionType>? transitionTypes,
    String? profilePhotoUrl,
    String? currentCompany,
    List<String>? targetCompanies,
    CompanySize? currentCompanySize,
    CompanySize? targetCompanySize,
  }) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) throw Exception('No user logged in');

      final token = await user.getIdToken();
      
      final Map<String, dynamic> body = {};
      if (currentRole != null) body['current_role'] = currentRole;
      if (targetRole != null) body['target_role'] = targetRole;
      if (currentIndustry != null) body['current_industry'] = currentIndustry;
      if (targetIndustry != null) body['target_industry'] = targetIndustry;
      if (careerStage != null) body['career_stage'] = careerStage.toString().split('.').last;
      if (transitionTypes != null && transitionTypes.isNotEmpty) {
        body['transition_types'] = transitionTypes.map((t) => t.toString().split('.').last).toList();
      }
      if (profilePhotoUrl != null) body['profile_photo_url'] = profilePhotoUrl;
      if (currentCompany != null) body['current_company'] = currentCompany;
      if (targetCompanies != null && targetCompanies.isNotEmpty) {
        body['target_companies'] = targetCompanies;
      }
      if (currentCompanySize != null) body['current_company_size'] = currentCompanySize.toString().split('.').last;
      if (targetCompanySize != null) body['target_company_size'] = targetCompanySize.toString().split('.').last;

      final response = await http.put(
        Uri.parse('$baseUrl/profile'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update profile: ${response.body}');
      }

      return UserModel.fromJson(jsonDecode(response.body));
    } catch (e) {
      throw Exception('Update profile failed: $e');
    }
  }
}
