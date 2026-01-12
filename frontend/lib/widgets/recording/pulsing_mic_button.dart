import 'dart:async';
import 'package:flutter/material.dart';
import 'package:record/record.dart';

class PulsingMicButton extends StatefulWidget {
  final bool isRecording;
  final VoidCallback onTap;
  final Stream<Amplitude>? amplitudeStream;

  const PulsingMicButton({
    required this.isRecording,
    required this.onTap,
    this.amplitudeStream,
    Key? key,
  }) : super(key: key);

  @override
  State<PulsingMicButton> createState() => _PulsingMicButtonState();
}

class _PulsingMicButtonState extends State<PulsingMicButton> with TickerProviderStateMixin {
  late final AnimationController _baseController;
  StreamSubscription<Amplitude>? _amplitudeSubscription;
  double _currentAmplitudeScale = 0.0;

  @override
  void initState() {
    super.initState();
    _baseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    
    if (widget.isRecording) {
      _baseController.repeat();
      _subscribeToAmplitude();
    }
  }

  void _subscribeToAmplitude() {
    _amplitudeSubscription?.cancel();
    _amplitudeSubscription = widget.amplitudeStream?.listen((amp) {
      if (mounted) {
        setState(() {
          // Typically dB ranges from -160 to 0.
          // We'll normalize -50dB to 0dB into a 0.0 to 1.0 range for vibration.
          double normalized = (amp.current + 50) / 50;
          _currentAmplitudeScale = normalized.clamp(0.0, 1.0);
        });
      }
    });
  }

  @override
  void didUpdateWidget(PulsingMicButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isRecording && !oldWidget.isRecording) {
      _baseController.repeat();
      _subscribeToAmplitude();
    } else if (!widget.isRecording && oldWidget.isRecording) {
      _baseController.reset();
      _amplitudeSubscription?.cancel();
      _amplitudeSubscription = null;
      _currentAmplitudeScale = 0.0;
    }
  }

  @override
  void dispose() {
    _baseController.dispose();
    _amplitudeSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: SizedBox(
          width: 160, // Reduced from 200
          height: 140, // Reduced from 200
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (widget.isRecording) ...[
                _buildPulseRing(primaryColor, 0.0),
                _buildPulseRing(primaryColor, 0.5),
              ],
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: primaryColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.4),
                      blurRadius: 12 + (_currentAmplitudeScale * 8),
                      spreadRadius: 2 + (_currentAmplitudeScale * 4),
                    ),
                  ],
                ),
                child: Icon(
                  widget.isRecording ? Icons.stop_rounded : Icons.mic_rounded,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPulseRing(Color color, double delay) {
    return AnimatedBuilder(
      animation: _baseController,
      builder: (context, child) {
        final baseValue = (_baseController.value + delay) % 1.0;
        
        // Combine base pulse (circular expansion) with audio vibration
        // Vibration adds a jittery scale factor on top of the smooth expansion
        final baseSize = 80 + (baseValue * 80);
        final vibrationSize = _currentAmplitudeScale * 20; 
        final size = baseSize + vibrationSize;
        
        final opacity = (1.0 - baseValue) * 0.4;

        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withOpacity(opacity),
          ),
        );
      },
    );
  }
}
