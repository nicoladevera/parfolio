import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/story_model.dart';
import '../core/shadows.dart';
import '../core/colors.dart';
import '../core/spacing.dart';

class StoryCard extends StatefulWidget {
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

  @override
  State<StoryCard> createState() => _StoryCardState();
}

class _StoryCardState extends State<StoryCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 600;

    return Container(
      margin: EdgeInsets.symmetric(vertical: Spacing.sm),
      decoration: BoxDecoration(
        color: _isHovered ? const Color(0xFFF9FAFB) : Colors.white, // Very light gray on hover
        borderRadius: BorderRadius.circular(16),
        boxShadow: Shadows.md,
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant,
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: widget.onTap,
        onHover: (hovering) {
          setState(() {
            _isHovered = hovering;
          });
        },
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
                                widget.story.title,
                                style: GoogleFonts.libreBaskerville(
                                  textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ),
                            ),
                            if (isWide) ...[
                              SizedBox(width: Spacing.md),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    DateFormat('MMM d, yyyy').format(widget.story.createdAt),
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                                        ),
                                  ),
                                  _buildPopupMenu(context),
                                ],
                              ),
                            ],
                          ],
                        ),
                        if (widget.story.tags.isNotEmpty) ...[
                          SizedBox(height: Spacing.sm),
                          Wrap(
                            spacing: Spacing.sm,
                            runSpacing: Spacing.sm,
                            children: widget.story.tags.map((tag) {
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
                  if (!isWide) _buildPopupMenu(context),
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
                  DateFormat('MMM d, yyyy').format(widget.story.createdAt),
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
          child: _buildParColumn(context, 'PROBLEM', widget.story.problem),
        ),
        SizedBox(width: Spacing.base),
        Expanded(
          child: _buildParColumn(context, 'ACTION', widget.story.action),
        ),
        SizedBox(width: Spacing.base),
        Expanded(
          child: _buildParColumn(context, 'RESULT', widget.story.result),
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
                color: Theme.of(context).colorScheme.primary,
                letterSpacing: 1.5,
              ),
        ),
        SizedBox(height: Spacing.xs),
        Text(
          content,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                height: 1.5,
              ),
        ),
      ],
    );
  }

  Widget _buildPopupMenu(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(
        Icons.more_horiz,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      onSelected: (value) {
        if (value == 'delete') widget.onDelete();
        if (value == 'edit' && widget.onEdit != null) widget.onEdit!();
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
    );
  }

  /// Narrow layout: Stacked with P:/A:/R: labels
  Widget _buildNarrowParPreview(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildParRow(context, 'P', widget.story.problem),
        SizedBox(height: Spacing.sm),
        _buildParRow(context, 'A', widget.story.action),
        SizedBox(height: Spacing.sm),
        _buildParRow(context, 'R', widget.story.result),
      ],
    );
  }

  /// Single row for mobile layout with P:/A:/R: prefix
  Widget _buildParRow(BuildContext context, String prefix, String content) {
    return RichText(
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
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          TextSpan(text: content),
        ],
      ),
    );
  }
}
