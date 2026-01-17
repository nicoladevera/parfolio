import 'dart:async';
import 'package:flutter/material.dart';
import '../core/colors.dart';
import '../core/spacing.dart';
import '../services/ai_service.dart';
import '../services/story_service.dart';
import '../widgets/processing/stage_progress_indicator.dart';
import '../widgets/processing/rotating_message.dart';
import 'story_review_screen.dart';

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

class _ProcessingScreenState extends State<ProcessingScreen>
    with TickerProviderStateMixin {
  final AIService _aiService = AIService();
  final StoryService _storyService = StoryService();

  late AnimationController _pulseController;
  int _currentStage = 0;
  int _elapsedSeconds = 0;
  Timer? _stageTimer;
  bool _isProcessing = true;
  String? _error;

  final List<String> _stageLabels = [
    'Transcribing',
    'Structuring',
    'Tagging',
    'Coaching',
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    )..repeat(reverse: true);

    _startTimers();
    _processAudio();
  }

  void _startTimers() {
    _stageTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _elapsedSeconds++;
          // Time-based stage progression logic
          if (_elapsedSeconds < 8) {
            _currentStage = 0;
          } else if (_elapsedSeconds < 15) {
            _currentStage = 1;
          } else if (_elapsedSeconds < 22) {
            _currentStage = 2;
          } else {
            _currentStage = 3;
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _stageTimer?.cancel();
    super.dispose();
  }

  Future<void> _processAudio() async {
    try {
      final processingResult = await _aiService.processRecording(
        userId: widget.userId,
        audioFilePath: widget.audioFilePath,
      );

      // Warnings are now persisted and shown on the review screen

      final story = await _storyService.createStory(
        aiData: processingResult.aiResult,
        audioUrl: processingResult.audioUrl,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Story "${story.title}" created successfully!'),
            backgroundColor: Theme.of(context).colorScheme.success,
            duration: const Duration(seconds: 3),
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => StoryReviewScreen(storyId: story.id),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isProcessing = false;
        });
        _stageTimer?.cancel();
      }
    }
  }

  void _showWarningSnackbar(List<String> warnings) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Processed with ${warnings.length} warning(s)'),
        backgroundColor: Theme.of(context).colorScheme.warning,
        action: SnackBarAction(
          label: 'Details',
          textColor: Colors.white,
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Processing Warnings'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: warnings.map((w) => Text('• $w')).toList(),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _retry() {
    setState(() {
      _isProcessing = true;
      _error = null;
      _currentStage = 0;
      _elapsedSeconds = 0;
    });
    _startTimers();
    _processAudio();
  }

  String _getTimeEstimate() {
    if (_elapsedSeconds < 30) {
      return 'Usually takes 15-30 seconds';
    } else if (_elapsedSeconds < 60) {
      return 'Taking a bit longer...';
    } else {
      return 'Still working, please wait...';
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Generating Story'),
        automaticallyImplyLeading: !_isProcessing,
        backgroundColor: Colors.white,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: colorScheme.gray200,
            height: 1.0,
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: _error != null ? _buildErrorState(colorScheme) : _buildProcessingState(colorScheme),
        ),
      ),
    );
  }

  Widget _buildProcessingState(ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.all(Spacing.lg),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildPulsingCircles(colorScheme),
          const SizedBox(height: Spacing.xl),
          StageProgressIndicator(
            currentStage: _currentStage,
            stageLabels: _stageLabels,
          ),
          const SizedBox(height: Spacing.lg),
          RotatingMessage(currentStage: _currentStage),
          const SizedBox(height: Spacing.base),
          Text(
            _getTimeEstimate(),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.gray400,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildPulsingCircles(ColorScheme colorScheme) {
    return SizedBox(
      height: 160,
      width: 160,
      child: Stack(
        alignment: Alignment.center,
        children: [
          _buildPulsingCircle(colorScheme.lime50, 120, 0),
          _buildPulsingCircle(colorScheme.lime300, 80, 200),
          _buildPulsingCircle(colorScheme.lime500, 40, 400),
        ],
      ),
    );
  }

  Widget _buildPulsingCircle(Color color, double size, int delayMs) {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        // Simple staggered opacity pulse
        final t = (_pulseController.value + (delayMs / 700)) % 1.0;
        final opacity = 0.6 + (0.4 * (1.0 - (t - 0.5).abs() * 2));
        
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withOpacity(opacity.clamp(0.0, 1.0)),
          ),
        );
      },
    );
  }

  Widget _buildErrorState(ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.all(Spacing.lg),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: colorScheme.error,
          ),
          const SizedBox(height: Spacing.lg),
          Text(
            'Processing Failed',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: colorScheme.error,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: Spacing.base),
          Text(
            _error ?? 'An unknown error occurred',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.gray700,
                ),
          ),
          const SizedBox(height: Spacing.xl),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _retry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                ),
                child: const Text('Try Again'),
              ),
              const SizedBox(width: Spacing.base),
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  foregroundColor: colorScheme.gray700,
                  side: BorderSide(color: colorScheme.gray300),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                ),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
