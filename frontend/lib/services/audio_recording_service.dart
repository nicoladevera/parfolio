import 'package:record/record.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart';

class AudioRecordingService {
  final AudioRecorder _audioRecorder = AudioRecorder();
  
  // Initialize and check permissions
  Future<bool> hasPermission() async {
    if (kIsWeb) {
      return await _audioRecorder.hasPermission();
    }
    
    final status = await Permission.microphone.request();
    return status == PermissionStatus.granted;
  }

  // Start recording
  Future<void> start() async {
    try {
      if (await hasPermission()) {
        const config = RecordConfig(encoder: AudioEncoder.aacLc);
        
        // Start recording to file
        // For web, path is ignored and blob is created
        await _audioRecorder.start(config, path: '');
      }
    } catch (e) {
      debugPrint('Error starting recording: $e');
      rethrow;
    }
  }

  // Stop recording and return path
  Future<String?> stop() async {
    final path = await _audioRecorder.stop();
    return path;
  }

  // Pause recording
  Future<void> pause() async {
    await _audioRecorder.pause();
  }

  // Resume recording
  Future<void> resume() async {
    await _audioRecorder.resume();
  }

  Stream<Amplitude>? _amplitudeStream;

  // Get amplitude stream for visualization
  Stream<Amplitude> getAmplitudeStream() {
    _amplitudeStream ??= _audioRecorder
        .onAmplitudeChanged(const Duration(milliseconds: 160))
        .asBroadcastStream();
    return _amplitudeStream!;
  }

  // Check if recording
  Future<bool> isRecording() async {
    return await _audioRecorder.isRecording();
  }

  // Dispose recorder resources
  void dispose() {
    _amplitudeStream = null;
    _audioRecorder.dispose();
  }
}
