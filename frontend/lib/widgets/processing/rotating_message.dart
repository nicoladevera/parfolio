import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/colors.dart';
import '../../core/spacing.dart';

class RotatingMessage extends StatefulWidget {
  final int currentStage;

  const RotatingMessage({
    super.key,
    required this.currentStage,
  });

  @override
  State<RotatingMessage> createState() => _RotatingMessageState();
}

class _RotatingMessageState extends State<RotatingMessage> {
  late Timer _timer;
  int _messageIndex = 0;

  final Map<int, List<String>> _messages = {
    0: [
      "Listening to your story...",
      "Converting speech to text...",
      "Capturing every detail...",
    ],
    1: [
      "Analyzing your narrative...",
      "Identifying the Problem, Action, and Result...",
      "Crafting your story arc...",
    ],
    2: [
      "Discovering your superpowers...",
      "Identifying behavioral competencies...",
      "Matching your skills...",
    ],
    3: [
      "Generating personalized insights...",
      "Preparing coaching feedback...",
      "Almost there...",
    ],
  };

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void didUpdateWidget(RotatingMessage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentStage != widget.currentStage) {
      setState(() {
        _messageIndex = 0;
      });
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (mounted) {
        setState(() {
          final stageMessages = _messages[widget.currentStage] ?? [];
          if (stageMessages.isNotEmpty) {
            _messageIndex = (_messageIndex + 1) % stageMessages.length;
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final stageMessages = _messages[widget.currentStage] ?? ["Processing..."];
    final currentMessage = stageMessages[_messageIndex % stageMessages.length];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        child: Text(
          currentMessage,
          key: ValueKey<String>(currentMessage),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.gray700,
                height: 1.5,
              ),
        ),
      ),
    );
  }
}
