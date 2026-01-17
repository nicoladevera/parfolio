import 'dart:io' show File, SocketException;
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:convert';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import '../models/ai_models.dart';
import 'auth_service.dart';

/// Service for AI processing of audio recordings
///
/// Handles uploading audio files to Firebase Storage and calling the
/// backend AI processing endpoints to transcribe, structure, tag, and
/// generate coaching insights.
class AIService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  /// Get Firebase ID token for authentication
  Future<String?> _getIdToken() async {
    return await _firebaseAuth.currentUser?.getIdToken();
  }

  /// Upload audio file to Firebase Storage
  ///
  /// Uploads the audio file to the path: users/{userId}/audio/{storyId}.{ext}
  /// Returns the download URL for the uploaded file.
  ///
  /// Throws an exception if:
  /// - File cannot be read
  /// - Upload times out (60 seconds)
  /// - Upload fails
  Future<String> _uploadAudioToStorage({
    required String userId,
    required String storyId,
    required String audioFilePath,
  }) async {
    try {
      // Determine file extension from path
      final extension = audioFilePath.split('.').last.toLowerCase();
      final validExtensions = ['wav', 'm4a', 'aac', 'mp3'];
      final ext = validExtensions.contains(extension) ? extension : 'wav';

      // Retrieve bytes based on platform
      final Uint8List bytes;
      if (kIsWeb) {
        // On Web, audioFilePath is a blob URL from the 'record' package
        final response = await http.get(Uri.parse(audioFilePath));
        if (response.statusCode != 200) {
          throw Exception('Failed to fetch audio from blob URL: ${response.statusCode}');
        }
        bytes = response.bodyBytes;
      } else {
        // On Mobile/Desktop, audioFilePath is a local file path
        final File audioFile = File(audioFilePath);
        if (!await audioFile.exists()) {
          throw Exception('Audio file not found at: $audioFilePath');
        }
        bytes = await audioFile.readAsBytes();
      }

      // Create Firebase Storage reference
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('users')
          .child(userId)
          .child('audio')
          .child('$storyId.$ext');

      // Upload with metadata
      final uploadTask = storageRef.putData(
        bytes,
        SettableMetadata(contentType: 'audio/$ext'),
      );

      // Wait for upload with timeout
      final snapshot = await uploadTask.timeout(
        const Duration(seconds: 60),
        onTimeout: () {
          throw TimeoutException('Upload timed out after 60 seconds');
        },
      );

      // Get download URL
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } on SocketException {
      throw Exception('Network error. Please check your connection.');
    } on TimeoutException {
      throw Exception('Upload is taking too long. Please try again.');
    } catch (e) {
      throw Exception('Failed to upload audio: $e');
    }
  }

  /// Process audio recording through AI pipeline
  ///
  /// This method orchestrates the full AI processing flow:
  /// 1. Generates a unique story ID
  /// 2. Uploads audio file to Firebase Storage
  /// 3. Calls the /ai/process endpoint to transcribe, structure, tag, and coach
  /// 4. Returns the processed story data along with the audio URL
  ///
  /// Returns [ProcessingResult] containing both the AI-processed story data
  /// and the audio URL needed to save the story.
  ///
  /// Throws an exception if:
  /// - User is not authenticated
  /// - Audio upload fails
  /// - AI processing fails
  /// - Network error occurs
  Future<ProcessingResult> processRecording({
    required String userId,
    required String audioFilePath,
  }) async {
    try {
      // Step 1: Generate unique story ID
      final storyId = const Uuid().v4();

      // Step 2: Upload audio to Firebase Storage
      final audioUrl = await _uploadAudioToStorage(
        userId: userId,
        storyId: storyId,
        audioFilePath: audioFilePath,
      );

      // Step 3: Get authentication token
      final token = await _getIdToken();
      if (token == null) {
        throw Exception('User not authenticated. Please log in again.');
      }

      // Step 4: Build request payload
      final requestBody = ProcessRequest(
        audioUrl: audioUrl,
        storyId: storyId,
        userId: userId,
      ).toJson();

      // Step 5: Call AI processing endpoint
      final response = await http.post(
        Uri.parse('${AuthService.baseUrl}/ai/process'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      ).timeout(
        const Duration(seconds: 120), // AI processing can take up to 2 minutes
        onTimeout: () {
          throw TimeoutException('AI processing timed out. Please try again.');
        },
      );

      // Step 6: Handle response
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final aiResult = ProcessedStoryResponse.fromJson(responseData);

        // Return both the AI result and the audio URL
        return ProcessingResult(
          aiResult: aiResult,
          audioUrl: audioUrl,
        );
      } else {
        // Try to parse error detail from backend
        try {
          final error = jsonDecode(response.body);
          final detail = error['detail'] ?? 'AI processing failed';
          throw Exception(detail);
        } catch (_) {
          throw Exception(
              'AI processing failed with status: ${response.statusCode}');
        }
      }
    } on SocketException {
      throw Exception('Network error. Please check your connection and try again.');
    } on TimeoutException catch (e) {
      throw Exception(e.message ?? 'Request timed out. Please try again.');
    } catch (e) {
      // Re-throw with context if not already handled
      if (e is Exception) {
        rethrow;
      }
      throw Exception('AI processing failed: $e');
    }
  }

  /// Get the audio URL for a story ID (useful for retrieving uploaded audio)
  ///
  /// This is a helper method to get the download URL for an already uploaded
  /// audio file without re-uploading.
  Future<String?> getAudioUrl({
    required String userId,
    required String storyId,
  }) async {
    try {
      // Try common audio extensions
      final extensions = ['wav', 'm4a', 'aac', 'mp3'];

      for (final ext in extensions) {
        try {
          final storageRef = FirebaseStorage.instance
              .ref()
              .child('users')
              .child(userId)
              .child('audio')
              .child('$storyId.$ext');

          final url = await storageRef.getDownloadURL();
          return url;
        } catch (_) {
          // Continue to next extension
          continue;
        }
      }

      return null; // No audio file found
    } catch (e) {
      return null;
    }
  }
}
