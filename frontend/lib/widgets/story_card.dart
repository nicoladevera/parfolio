import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/story_model.dart';
import '../core/colors.dart';
import '../core/spacing.dart';

class StoryCard extends StatelessWidget {
  final StoryModel story;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback? onEdit;

  const StoryCard({
    Key? key,
    required this.story,
    required this.onTap,
    required this.onDelete,
    this.onEdit,
  }) : super(key: key);

  /// Truncates text to approximately maxChars, ending at a word boundary
  String _truncate(String text, {int maxChars = 100}) {
    if (text.length <= maxChars) return text;
    final truncated = text.substring(0, maxChars);
    final lastSpace = truncated.lastIndexOf(' ');
    if (lastSpace > maxChars * 0.7) {
      return '${truncated.substring(0, lastSpace)}...';
    }
    return '${truncated.trim()}...';
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 600;

    return Card(
      margin: EdgeInsets.symmetric(vertical: Spacing.sm),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: EdgeInsets.all(Spacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Title, Tags, Date, Menu
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                story.title,
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                            if (isWide) ...[
                              SizedBox(width: Spacing.md),
                              Text(
                                DateFormat('MMM d, yyyy').format(story.createdAt),
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                                    ),
                              ),
                            ],
                          ],
                        ),
                        if (story.tags.isNotEmpty) ...[
                          SizedBox(height: Spacing.sm),
                          Wrap(
                            spacing: Spacing.sm,
                            runSpacing: Spacing.sm,
                            children: story.tags.map((tag) {
                              final color = Theme.of(context).colorScheme.tagColors[tag] ??
                                  Theme.of(context).colorScheme.primary;
                              return Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: Spacing.md,
                                  vertical: Spacing.xs,
                                ),
                                decoration: BoxDecoration(
                                  color: color.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  tag,
                                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                        color: color,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: Icon(
                      Icons.more_horiz,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    onSelected: (value) {
                      if (value == 'delete') onDelete();
                      if (value == 'edit' && onEdit != null) onEdit!();
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(
                              Icons.edit_outlined,
                              color: Theme.of(context).colorScheme.onSurface,
                              size: 20,
                            ),
                            SizedBox(width: Spacing.sm),
                            Text('Edit Story'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(
                              Icons.delete_outline,
                              color: Theme.of(context).colorScheme.error,
                              size: 20,
                            ),
                            SizedBox(width: Spacing.sm),
                            Text(
                              'Delete',
                              style: TextStyle(color: Theme.of(context).colorScheme.error),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // P/A/R Preview Section
              SizedBox(height: Spacing.base),
              Divider(
                color: Theme.of(context).colorScheme.outlineVariant,
                height: 1,
              ),
              SizedBox(height: Spacing.base),
              
              if (isWide)
                _buildWideParPreview(context)
              else
                _buildNarrowParPreview(context),

              // Mobile date at bottom
              if (!isWide) ...[
                SizedBox(height: Spacing.md),
                Text(
                  DateFormat('MMM d, yyyy').format(story.createdAt),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Wide layout: 3 columns for Problem, Action, Result
  Widget _buildWideParPreview(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _buildParColumn(context, 'PROBLEM', story.problem),
        ),
        SizedBox(width: Spacing.base),
        Expanded(
          child: _buildParColumn(context, 'ACTION', story.action),
        ),
        SizedBox(width: Spacing.base),
        Expanded(
          child: _buildParColumn(context, 'RESULT', story.result),
        ),
      ],
    );
  }

  /// Single column for desktop layout
  Widget _buildParColumn(BuildContext context, String label, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                letterSpacing: 1.5,
              ),
        ),
        SizedBox(height: Spacing.xs),
        Text(
          _truncate(content),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                height: 1.5,
              ),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  /// Narrow layout: Stacked with P:/A:/R: labels
  Widget _buildNarrowParPreview(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildParRow(context, 'P', story.problem),
        SizedBox(height: Spacing.sm),
        _buildParRow(context, 'A', story.action),
        SizedBox(height: Spacing.sm),
        _buildParRow(context, 'R', story.result),
      ],
    );
  }

  /// Single row for mobile layout with P:/A:/R: prefix
  Widget _buildParRow(BuildContext context, String prefix, String content) {
    return RichText(
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
              height: 1.5,
            ),
        children: [
          TextSpan(
            text: '$prefix: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          TextSpan(text: _truncate(content, maxChars: 80)),
        ],
      ),
    );
  }
}
