import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

class TagService {
  static const List<String> fallbackTags = [
    'Leadership',
    'Ownership',
    'Impact',
    'Communication',
    'Conflict',
    'Strategic Thinking',
    'Execution',
    'Adaptability',
    'Failure',
    'Innovation',
  ];

  Future<List<String>> getTags() async {
    try {
      final response = await http.get(
        Uri.parse('${AuthService.baseUrl}/tags'),
        headers: {
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.cast<String>();
      }
      return fallbackTags;
    } catch (e) {
      print('Error fetching tags: $e. Using fallback.');
      return fallbackTags;
    }
  }
}
