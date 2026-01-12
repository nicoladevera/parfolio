import 'package:flutter/material.dart';
import 'dart:math' as math;

class AudioWaveform extends StatefulWidget {
  final Stream<double>? amplitudeStream;
  final bool isRecording;

  const AudioWaveform({
    this.amplitudeStream,
    required this.isRecording,
    Key? key,
  }) : super(key: key);

  @override
  State<AudioWaveform> createState() => _AudioWaveformState();
}

class _AudioWaveformState extends State<AudioWaveform> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<double> _barHeights = List.filled(20, 0.1);
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 100))
      ..addListener(_updateBars);
      
    if (widget.isRecording) {
      _controller.repeat();
    }
  }

  void _updateBars() {
    if (widget.isRecording) {
      setState(() {
        for (int i = 0; i < _barHeights.length; i++) {
          // Simulate some movement even without real amplitude for responsiveness
          // In a real app with getAmplitudeStream, we'd use that value to scale these
          _barHeights[i] = 0.1 + _random.nextDouble() * 0.8; 
        }
      });
    } else {
       // Reset to flat line
       setState(() {
         _barHeights.fillRange(0, _barHeights.length, 0.1);
       });
    }
  }

  @override
  void didUpdateWidget(AudioWaveform oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isRecording && !oldWidget.isRecording) {
      _controller.repeat();
    } else if (!widget.isRecording && oldWidget.isRecording) {
      _controller.stop();
      _updateBars(); // Reset
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: 200,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: _barHeights.map((height) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            width: 4,
            height: 60 * height,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          );
        }).toList(),
      ),
    );
  }
}
