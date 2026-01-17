import 'package:flutter/material.dart';
import '../services/ai_service.dart';
import '../services/story_service.dart';

/// Minimal Processing Screen for Phase 1
///
/// This is a simplified version that shows a loading indicator while processing.
/// Phase 2 will add:
/// - Stage-by-stage progress (transcribing → structuring → tagging → coaching)
/// - Rotating messages
/// - Time estimates
/// - Better error UI
class ProcessingScreen extends StatefulWidget {
  final String audioFilePath;
  final String userId;

  const ProcessingScreen({
    super.key,
    required this.audioFilePath,
    required this.userId,
  });

  @override
  State<ProcessingScreen> createState() => _ProcessingScreenState();
}

class _ProcessingScreenState extends State<ProcessingScreen> {
  final AIService _aiService = AIService();
  final StoryService _storyService = StoryService();

  bool _isProcessing = true;
  String? _error;
  String _currentStage = 'Preparing...';

  @override
  void initState() {
    super.initState();
    _processAudio();
  }

  /// Process the audio recording through the AI pipeline
  Future<void> _processAudio() async {
    try {
      // Step 1: Upload and process with AI
      setState(() => _currentStage = 'Processing your story...');

      final processingResult = await _aiService.processRecording(
        userId: widget.userId,
        audioFilePath: widget.audioFilePath,
      );

      // Step 2: Check for warnings (partial failures)
      if (processingResult.aiResult.warnings.isNotEmpty) {
        debugPrint('AI Processing Warnings: ${processingResult.aiResult.warnings}');
        // TODO Phase 2: Show warning dialog to user
        // For now, just log them
      }

      // Step 3: Create story in Firestore
      setState(() => _currentStage = 'Saving your story...');

      final story = await _storyService.createStory(
        aiData: processingResult.aiResult,
        audioUrl: processingResult.audioUrl,
      );

      // Step 4: Navigate to home on success
      if (mounted) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Story "${story.title}" created successfully!'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );

        // Navigate to home
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/home',
          (route) => false,
        );
      }
    } catch (e) {
      // Handle errors
      setState(() {
        _error = e.toString();
        _isProcessing = false;
      });
    }
  }

  /// Retry processing after an error
  void _retry() {
    setState(() {
      _isProcessing = true;
      _error = null;
      _currentStage = 'Preparing...';
    });
    _processAudio();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Processing'),
        // Don't allow back navigation while processing
        automaticallyImplyLeading: !_isProcessing,
      ),
      body: Center(
        child: _error != null
            ? _buildErrorState()
            : _buildLoadingState(),
      ),
    );
  }

  /// Build the loading state UI
  Widget _buildLoadingState() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 24),
          Text(
            _currentStage,
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'This usually takes 15-30 seconds',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          const Text(
            '⚡ AI is working its magic:\n'
            '• Transcribing your audio\n'
            '• Structuring into PAR format\n'
            '• Identifying competencies\n'
            '• Generating coaching insights',
            style: TextStyle(height: 1.6),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Build the error state UI
  Widget _buildErrorState() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red,
          ),
          const SizedBox(height: 24),
          Text(
            'Processing Failed',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.red,
                ),
          ),
          const SizedBox(height: 16),
          Text(
            _error ?? 'An unknown error occurred',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: _retry,
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              OutlinedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Go Back'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
