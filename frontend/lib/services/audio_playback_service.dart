import 'package:just_audio/just_audio.dart';
import 'package:flutter/foundation.dart';

class AudioPlaybackService {
  final AudioPlayer _audioPlayer = AudioPlayer();

  // Streams for UI updates
  Stream<Duration> get positionStream => _audioPlayer.positionStream;
  Stream<Duration?> get durationStream => _audioPlayer.durationStream;
  Stream<PlayerState> get playerStateStream => _audioPlayer.playerStateStream;
  
  // Set audio source from file path or URL
  Future<void> setSource(String path) async {
    try {
      if (kIsWeb) {
        // Handle blob URLs for web or standard URLs
        await _audioPlayer.setUrl(path);
      } else {
        // Handle local files for mobile
        await _audioPlayer.setFilePath(path);
      }
    } catch (e) {
      debugPrint('Error setting audio source: $e');
      rethrow;
    }
  }

  // Play audio
  Future<void> play() async {
    await _audioPlayer.play();
  }

  // Pause audio
  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  // Stop audio and reset position
  Future<void> stop() async {
    await _audioPlayer.stop();
    await _audioPlayer.seek(Duration.zero);
  }

  // Seek to specific position
  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  // Dispose player resources
  void dispose() {
    _audioPlayer.dispose();
  }
}
