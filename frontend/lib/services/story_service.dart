import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import '../models/story_model.dart';
import 'auth_service.dart'; // Import to access baseUrl

class StoryService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String?> _getIdToken() async {
    return await _firebaseAuth.currentUser?.getIdToken();
  }

  Future<List<StoryModel>> getStories({String? tag}) async {
    try {
      final token = await _getIdToken();
      if (token == null) throw Exception('User not authenticated');

      var uri = Uri.parse('${AuthService.baseUrl}/stories');
      if (tag != null && tag != 'All') {
        uri = uri.replace(queryParameters: {'tag': tag});
      }

      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => StoryModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load stories: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching stories: $e');
    }
  }

  Future<StoryModel> getStory(String id) async {
    try {
      final token = await _getIdToken();
      if (token == null) throw Exception('User not authenticated');

      final response = await http.get(
        Uri.parse('${AuthService.baseUrl}/stories/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return StoryModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load story: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching story: $e');
    }
  }

  Future<void> deleteStory(String id) async {
    try {
      final token = await _getIdToken();
      if (token == null) throw Exception('User not authenticated');

      final response = await http.delete(
        Uri.parse('${AuthService.baseUrl}/stories/$id'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to delete story: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error deleting story: $e');
    }
  }

  Future<void> startExport(String format) async {
    // For MVP, we'll trigger a browser download via URL opening
    // In a real app, might want to handle file download in Dart
    // Depending on backend implementation, this might just return a URL or file content
    
    // Placeholder implementation since we don't have url_launcher package in dependencies yet
    // In a production app, use url_launcher or universal_html for web downloads
    print('Export requested for format: $format');
    
    /* 
    // Example implementation with url_launcher (add to pubspec.yaml first)
    final token = await _getIdToken();
    final url = '${AuthService.baseUrl}/export/download?format=$format&token=$token';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
    */
  }
}
