import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:just_audio/just_audio.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Services
import '../services/audio_recording_service.dart';
import '../services/audio_playback_service.dart';

// Screens
import 'processing_screen.dart';

// Widgets
import '../widgets/auth/polka_dot_rectangle.dart';
import '../widgets/auth/wavy_line_decoration.dart';
import '../widgets/auth/sunburst_decoration.dart';
import '../widgets/auth/ripple_decoration.dart';
import '../widgets/recording/pulsing_mic_button.dart';
import '../widgets/recording/recording_timer.dart';
import '../widgets/recording/playback_controls.dart';
import '../widgets/recording/recording_tips_box.dart';

enum RecordingState { idle, recording, paused, completed }

class RecordingScreen extends StatefulWidget {
  @override
  _RecordingScreenState createState() => _RecordingScreenState();
}

class _RecordingScreenState extends State<RecordingScreen> {
  final AudioRecordingService _recordingService = AudioRecordingService();
  final AudioPlaybackService _playbackService = AudioPlaybackService();

  RecordingState _state = RecordingState.idle;
  Duration _recordingDuration = Duration.zero;
  Timer? _timer;
  String? _recordedFilePath;

  // Playback state
  bool _isPlaying = false;
  Duration _playbackPosition = Duration.zero;
  Duration _playbackDuration = Duration.zero;
  StreamSubscription? _playerStateSubscription;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _durationSubscription;

  @override
  void initState() {
    super.initState();
    _initPlaybackListeners();
  }

  void _initPlaybackListeners() {
    _playerStateSubscription = _playbackService.playerStateStream.listen((state) {
      if (mounted) {
        setState(() {
          _isPlaying = state.playing;
          if (state.processingState == ProcessingState.completed) {
            _isPlaying = false;
            _playbackService.stop();
            _playbackPosition = Duration.zero;
          }
        });
      }
    });

    _positionSubscription = _playbackService.positionStream.listen((position) {
      if (mounted) setState(() => _playbackPosition = position);
    });

    _durationSubscription = _playbackService.durationStream.listen((duration) {
      if (mounted && duration != null) setState(() => _playbackDuration = duration);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _recordingService.dispose();
    _playbackService.dispose();
    _playerStateSubscription?.cancel();
    _positionSubscription?.cancel();
    _durationSubscription?.cancel();
    super.dispose();
  }

  // --- Recording Actions ---

  Future<void> _toggleRecording() async {
    try {
      if (_state == RecordingState.idle) {
        // Start recording
        if (await _recordingService.hasPermission()) {
          await _recordingService.start();
          _startTimer();
          setState(() => _state = RecordingState.recording);
        } else {
           if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Microphone permission required')));
        }
      } else if (_state == RecordingState.recording) {
        // Stop recording (via mic button tap) -> Or pause?
        // Design implies Mic button stops/pauses. Let's make it Stop for simplicity or Pause.
        // User requested Pause/Stop buttons. Mic button usually toggles record/stop or pause.
        // Let's make the main mic button strictly for Start (Idle)
        // If recording, tapping it could Stop or Pause.
        // Let's implement separate Pause/Stop buttons as per design plan.
        // So tapping mic button while recording might be disable or Stop.
        // Current design: "Mic button... Pulsing when recording".
        // Let's trigger Stop on tap for now, or just do nothing if we have dedicated buttons.
        // Actually, let's make it PAUSE if recording, RESUME if paused.
        _pauseRecording();
      } else if (_state == RecordingState.paused) {
        _resumeRecording();
      }
    } catch (e) {
      debugPrint('Error toggling recording: $e');
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _recordingDuration += const Duration(seconds: 1);
      });
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  Future<void> _pauseRecording() async {
    await _recordingService.pause();
    _stopTimer();
    setState(() => _state = RecordingState.paused);
  }

  Future<void> _resumeRecording() async {
    await _recordingService.resume();
    _startTimer();
    setState(() => _state = RecordingState.recording);
  }

  Future<void> _stopRecording() async {
    _stopTimer();
    final path = await _recordingService.stop();
    setState(() {
      _state = RecordingState.completed;
      _recordedFilePath = path;
    });
    
    if (path != null) {
      await _playbackService.setSource(path);
      // Initialize duration for playback display
      // Duration stream will update eventually
    }
  }

  // --- Playback Actions ---

  Future<void> _togglePlayback() async {
    if (_isPlaying) {
      await _playbackService.pause();
    } else {
      await _playbackService.play();
    }
  }

  Future<void> _seek(Duration position) async {
    await _playbackService.seek(position);
  }

  // --- Reset/Delete ---

  Future<void> _deleteRecording() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Recording?'),
        content: const Text('You are about to delete this recording. You can record again immediately.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      _playbackService.stop();
      setState(() {
        _state = RecordingState.idle;
        _recordingDuration = Duration.zero;
        _recordedFilePath = null;
        _playbackPosition = Duration.zero;
      });
    }
  }

  // --- Save / Navigation ---

  Future<void> _onWillPop() async {
    // Check if we need to warn user
    if (_state == RecordingState.idle) {
      Navigator.pop(context);
      return;
    }

    // Show dialog
    final action = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Discard Recording?'),
        content: const Text('You have an unsaved recording. Do you want to save it or discard it?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 'cancel'),
            child: const Text('Cancel Navigation'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'discard'),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Discard'),
          ),
          ElevatedButton(
             onPressed: () => Navigator.pop(context, 'save'),
             child: const Text('Save'),
          ),
        ],
      ),
    );

    if (action == 'discard') {
      // Allow pop by resetting state first
      setState(() => _state = RecordingState.idle);
      // Wait for rebuild then pop
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) Navigator.pop(context);
      });
    } else if (action == 'save') {
      _saveAndProcessing();
    }
  }

  Future<void> _saveAndProcessing() async {
    // Validate recording exists
    if (_recordedFilePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No recording found')),
      );
      return;
    }

    // Validate user is authenticated
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must be logged in')),
      );
      return;
    }

    // Show brief feedback
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Preparing your story...'),
        duration: Duration(seconds: 2),
      ),
    );

    // Navigate to ProcessingScreen (Phase 2)
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ProcessingScreen(
          audioFilePath: _recordedFilePath!,
          userId: userId,
        ),
      ),
    );
  }

  // --- UI Construction ---

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final showDecorations = screenWidth > 600;

    return PopScope(
      canPop: _state == RecordingState.idle,
      onPopInvoked: (didPop) {
        if (didPop) return;
        _onWillPop();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF7FEE7), // Lime 50
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF4B5563)),
            onPressed: () => _onWillPop(),
          ),
        ),
        body: Stack(
          children: [
            // --- Background Decorations ---
            if (showDecorations) ...[
               Positioned(
                top: 80,
                left: 40,
                child: PolkaDotRectangle(
                  bgColor: const Color(0xFFFEF3C7), // Amber 100
                  dotColor: const Color(0xFFD97706), // Amber 600
                  width: 100, height: 120, rotation: -8,
                ),
              ),
              Positioned(
                top: 220,
                left: 20,
                child: WavyLineDecoration(
                  color: const Color(0xFFD1D5DB), // Gray 300
                  width: 100, height: 50,
                ),
              ),
              Positioned(
                top: 60,
                right: 60,
                child: SunburstDecoration(
                  color: const Color(0xFFA3E635), // Lime 300
                  size: 160,
                ),
              ),
              Positioned(
                bottom: 100,
                left: 50,
                child: RippleDecoration(
                  color: const Color(0xFFD1D5DB), // Gray 300
                  size: 120,
                ),
              ),
              Positioned(
                bottom: 80,
                right: 40,
                child: PolkaDotRectangle(
                  bgColor: const Color(0xFFDCFCE7), // Lime 100
                  dotColor: const Color(0xFF3F6212), // Lime 700
                  width: 90, height: 100, rotation: 5,
                ),
              ),
              Positioned(
                bottom: 200,
                right: 20,
                child: WavyLineDecoration(
                  color: const Color(0xFFA3E635), // Lime 300
                  width: 120, height: 60,
                ),
              ),
            ],

            // --- Main Content ---
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 64),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Header
                          Text(
                            'Record Your Story',
                            style: GoogleFonts.libreBaskerville(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF111827),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Speak freely. We\'ll handle the rest.',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              color: const Color(0xFF4B5563), // Gray 600
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),



                          // Mic Button
                          if (_state != RecordingState.completed)
                            Column(
                              children: [
                                PulsingMicButton(
                                  isRecording: _state == RecordingState.recording,
                                  onTap: _toggleRecording,
                                  amplitudeStream: _recordingService.getAmplitudeStream(),
                                ),
                                if (_state == RecordingState.idle) ...[
                                    const SizedBox(height: 4),
                                  Text(
                                    'Tap to start recording',
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFF4D7C0F), // Darker lime (Lime 600)
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          
                          const SizedBox(height: 16),
                          
                          // Timer
                          if (_state != RecordingState.idle) ...[
                             RecordingTimer(duration: _recordingDuration),
                          ],
                          
                          const SizedBox(height: 24),

                          // Recording Controls
                          if (_state == RecordingState.recording || _state == RecordingState.paused)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                OutlinedButton.icon(
                                  onPressed: _state == RecordingState.recording ? _pauseRecording : _resumeRecording,
                                  icon: Icon(_state == RecordingState.recording ? Icons.pause : Icons.play_arrow),
                                  label: Text(_state == RecordingState.recording ? 'Pause' : 'Resume'),
                                ),
                                const SizedBox(width: 16),
                                ElevatedButton.icon(
                                  onPressed: _stopRecording,
                                  icon: const Icon(Icons.stop),
                                  label: const Text('Stop'),
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
                                ),
                              ],
                            ),

                          // Playback Controls
                          if (_state == RecordingState.completed)
                            PlaybackControls(
                              isPlaying: _isPlaying,
                              position: _playbackPosition,
                              duration: _playbackDuration > Duration.zero ? _playbackDuration : _recordingDuration,
                              onPlayPause: _togglePlayback,
                              onSeek: _seek,
                            ),

                          // Action Buttons for Completeds State
                          if (_state == RecordingState.completed) ...[
                             const SizedBox(height: 32),
                             Row(
                               children: [
                                 Expanded(
                                   child: OutlinedButton(
                                     onPressed: _deleteRecording,
                                     style: OutlinedButton.styleFrom(
                                       foregroundColor: Colors.red,
                                       side: const BorderSide(color: Colors.red),
                                     ),
                                     child: const Text('Delete'),
                                   ),
                                 ),
                                 const SizedBox(width: 16),
                                 Expanded(
                                   child: ElevatedButton(
                                     onPressed: _saveAndProcessing,
                                     child: const Text('Save & Process'),
                                   ),
                                 ),
                               ],
                             ),
                          ],
                        
                        
                          const SizedBox(height: 8),

                          // Tips (visible only when idle) - Moved to bottom
                          if (_state == RecordingState.idle)
                            const Padding(
                              padding: EdgeInsets.only(top: 4.0),
                              child: RecordingTipsBox(),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
