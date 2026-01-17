import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import '../models/story_model.dart';
import '../models/ai_models.dart';
import 'auth_service.dart'; // Import to access baseUrl

class StoryService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String?> _getIdToken() async {
    return await _firebaseAuth.currentUser?.getIdToken();
  }

  Future<List<StoryModel>> getStories({String? tag, String? status}) async {
    try {
      final token = await _getIdToken();
      if (token == null) throw Exception('User not authenticated');

      var uri = Uri.parse('${AuthService.baseUrl}/stories');
      final queryParams = <String, String>{};
      if (tag != null && tag != 'All') queryParams['tag'] = tag;
      if (status != null) queryParams['status'] = status;
      if (queryParams.isNotEmpty) {
        uri = uri.replace(queryParameters: queryParams);
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

  /// Create a new story from AI-processed data
  ///
  /// Takes the processed story data from the AI pipeline and creates a new
  /// story in Firestore with status 'draft'.
  ///
  /// Returns the created [StoryModel] with all fields populated including
  /// the server-generated story_id and timestamps.
  Future<StoryModel> createStory({
    required ProcessedStoryResponse aiData,
    required String audioUrl,
  }) async {
    try {
      final token = await _getIdToken();
      if (token == null) throw Exception('User not authenticated');

      // Build request payload mapping ProcessedStoryResponse to StoryCreate schema
      final requestBody = {
        'title': aiData.title,
        'problem': aiData.problem,
        'action': aiData.action,
        'result': aiData.result,
        'tags': aiData.tags.map((t) => t.tag).toList(), // Extract tag names only
        'raw_transcript': aiData.rawTranscript,
        'raw_transcript_url': aiData.rawTranscriptUrl,
        'audio_url': audioUrl,
        'status': 'draft', // Initial status
        'coaching': {
          'strength': {
            'overview': aiData.coaching.strength.overview,
            'detail': aiData.coaching.strength.detail,
          },
          'gap': {
            'overview': aiData.coaching.gap.overview,
            'detail': aiData.coaching.gap.detail,
          },
          'suggestion': {
            'overview': aiData.coaching.suggestion.overview,
            'detail': aiData.coaching.suggestion.detail,
          },
        },
      };

      final response = await http.post(
        Uri.parse('${AuthService.baseUrl}/stories'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return StoryModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to create story: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating story: $e');
    }
  }

  /// Update an existing story
  ///
  /// Allows partial updates to story fields. Commonly used for:
  /// - Editing PAR sections
  /// - Updating tags
  /// - Marking story as complete
  ///
  /// Example usage:
  /// ```dart
  /// await storyService.updateStory(storyId, {'status': 'complete'});
  /// await storyService.updateStory(storyId, {
  ///   'problem': editedProblem,
  ///   'action': editedAction,
  /// });
  /// ```
  Future<StoryModel> updateStory(
    String storyId,
    Map<String, dynamic> updates,
  ) async {
    try {
      final token = await _getIdToken();
      if (token == null) throw Exception('User not authenticated');

      final response = await http.put(
        Uri.parse('${AuthService.baseUrl}/stories/$storyId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(updates),
      );

      if (response.statusCode == 200) {
        return StoryModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to update story: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating story: $e');
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
