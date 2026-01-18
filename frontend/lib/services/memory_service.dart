import 'dart:convert';

import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import '../models/memory_model.dart';
import 'auth_service.dart';

class MemoryService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String?> _getIdToken() async {
    return await _firebaseAuth.currentUser?.getIdToken();
  }

  /// Upload a document to the memory bank
  /// Returns a map with the processing status or throws an error
  Future<Map<String, dynamic>> uploadDocument({
    required List<int> bytes,
    required String filename,
    String sourceType = 'resume',
  }) async {
    final token = await _getIdToken();
    if (token == null) throw Exception('User not authenticated');

    final uri = Uri.parse('${AuthService.baseUrl}/memory/upload');
    final request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..fields['user_id'] = _firebaseAuth.currentUser!.uid
      ..fields['source_type'] = sourceType
      ..files.add(http.MultipartFile.fromBytes(
        'file',
        bytes,
        filename: filename,
      ));

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to upload document: ${response.body}');
    }
  }

  /// Fetch all memory entries for the current user
  Future<List<MemoryEntry>> getMemories() async {
    final token = await _getIdToken();
    if (token == null) return [];

    final userId = _firebaseAuth.currentUser!.uid;
    final response = await http.get(
      Uri.parse('${AuthService.baseUrl}/memory/entries/$userId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => MemoryEntry.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch memories');
    }
  }

  /// Delete a specific memory entry
  Future<void> deleteMemory(String entryId) async {
    final token = await _getIdToken();
    if (token == null) throw Exception('User not authenticated');

    final userId = _firebaseAuth.currentUser!.uid;
    final response = await http.delete(
      Uri.parse('${AuthService.baseUrl}/memory/entries/$userId/$entryId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete memory entry');
    }
  }

  /// Poll for a new memory entry after upload
  /// [previousCount] is the number of entries before the new upload
  Future<MemoryEntry?> pollForNewEntry(int previousCount) async {
    int attempts = 0;
    const maxAttempts = 20; // 20 * 3s = 60s timeout

    while (attempts < maxAttempts) {
      await Future.delayed(const Duration(seconds: 3));
      try {
        final currentMemories = await getMemories();
        if (currentMemories.length > previousCount) {
          // Sort by creation date to get the newest (Backend should handle this but safety first)
          currentMemories.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          return currentMemories.first;
        }
      } catch (e) {
        print('Polling error: $e');
      }
      attempts++;
    }
    return null; // Timeout
  }
}
