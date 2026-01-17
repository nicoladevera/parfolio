import 'package:flutter/material.dart';
import '../../core/colors.dart';
import '../../core/spacing.dart';

class StageProgressIndicator extends StatefulWidget {
  final int currentStage;
  final List<String> stageLabels;

  const StageProgressIndicator({
    super.key,
    required this.currentStage,
    required this.stageLabels,
  });

  @override
  State<StageProgressIndicator> createState() => _StageProgressIndicatorState();
}

class _StageProgressIndicatorState extends State<StageProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              // Connecting Lines
              Positioned(
                left: 20,
                right: 20,
                child: Row(
                  children: List.generate(
                    widget.stageLabels.length - 1,
                    (index) => Expanded(
                      child: Container(
                        height: 2,
                        color: index < widget.currentStage
                            ? colorScheme.lime500
                            : colorScheme.gray300,
                      ),
                    ),
                  ),
                ),
              ),
              // Stage Dots
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  widget.stageLabels.length,
                  (index) => _buildStageDot(index, colorScheme),
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.sm),
          // Stage Labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              widget.stageLabels.length,
              (index) => Expanded(
                child: Text(
                  widget.stageLabels[index],
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: index <= widget.currentStage
                            ? colorScheme.gray900
                            : colorScheme.gray600,
                        fontWeight: index == widget.currentStage
                            ? FontWeight.w700
                            : FontWeight.w600,
                      ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStageDot(int index, ColorScheme colorScheme) {
    final isCompleted = index < widget.currentStage;
    final isCurrent = index == widget.currentStage;

    return Stack(
      alignment: Alignment.center,
      children: [
        if (isCurrent)
          ScaleTransition(
            scale: _pulseAnimation,
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorScheme.lime300.withOpacity(0.4),
              ),
            ),
          ),
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCompleted || isCurrent ? colorScheme.lime500 : Colors.white,
            border: isCompleted || isCurrent
                ? null
                : Border.all(color: colorScheme.gray300, width: 2),
          ),
          child: isCompleted
              ? const Icon(
                  Icons.check,
                  size: 14,
                  color: Colors.white,
                )
              : null,
        ),
      ],
    );
  }
}
