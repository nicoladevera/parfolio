import 'package:flutter/material.dart';
import '../../core/colors.dart';
import '../../core/spacing.dart';
import '../../models/story_model.dart';

class CoachingDisplay extends StatelessWidget {
  final CoachingModel? coaching;

  const CoachingDisplay({
    super.key,
    this.coaching,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (coaching == null) {
      return Container(
        padding: const EdgeInsets.all(Spacing.lg),
        decoration: BoxDecoration(
          color: colorScheme.warningBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colorScheme.warning.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: colorScheme.warning),
            const SizedBox(width: Spacing.md),
            Expanded(
              child: Text(
                'Coaching insights couldn\'t be generated for this story. Try refining your narrative for better results.',
                style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.warning),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInsightItem(
          context,
          title: 'STRENGTH',
          insight: coaching!.strength,
          bgColor: colorScheme.lime50,
          borderColor: colorScheme.lime200.withOpacity(0.5),
          icon: Icons.check_circle_outline,
          iconColor: colorScheme.lime600,
        ),
        _buildInsightItem(
          context,
          title: 'GAP',
          insight: coaching!.gap,
          bgColor: colorScheme.warningBg,
          borderColor: colorScheme.warning.withOpacity(0.2),
          icon: Icons.lightbulb_outline,
          iconColor: colorScheme.warning,
        ),
        _buildInsightItem(
          context,
          title: 'SUGGESTION',
          insight: coaching!.suggestion,
          bgColor: colorScheme.tealBg,
          borderColor: colorScheme.teal.withOpacity(0.2),
          icon: Icons.auto_awesome_outlined,
          iconColor: colorScheme.teal,
        ),
      ],
    );
  }

  Widget _buildInsightItem(
    BuildContext context, {
    required String title,
    required CoachingInsightModel insight,
    required Color bgColor,
    required Color borderColor,
    required IconData icon,
    required Color iconColor,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: Spacing.base),
      padding: const EdgeInsets.all(Spacing.lg),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: iconColor),
              const SizedBox(width: Spacing.sm),
              Text(
                title,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: iconColor,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.md),
          Text(
            insight.overview,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.gray900,
            ),
          ),
          const SizedBox(height: Spacing.sm),
          Text(
            insight.detail,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.gray700,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
