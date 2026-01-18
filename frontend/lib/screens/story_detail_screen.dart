import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/story_model.dart';
import '../core/colors.dart';
import '../widgets/review/coaching_display.dart';
import 'story_review_screen.dart';

class StoryDetailScreen extends StatelessWidget {
  final StoryModel story;
  final Function(String) onDelete;
  final VoidCallback? onEdit;

  const StoryDetailScreen({
    Key? key,
    required this.story,
    required this.onDelete,
    this.onEdit,
  }) : super(key: key);

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Story'),
        content: Text('Are you sure you want to delete "${story.title}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              onDelete(story.id);
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Return to dashboard
            },
            child: Text('Delete', style: TextStyle(color: Theme.of(context).colorScheme.error)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 1),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(
                color: colorScheme.outlineVariant.withOpacity(0.5),
                width: 1,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            scrolledUnderElevation: 0,
            title: Text(
              'Story Detail',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.edit_outlined, color: colorScheme.onSurface),
                onPressed: () {
                  if (onEdit != null) {
                    onEdit!();
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => StoryReviewScreen(
                          storyId: story.id,
                          isEditMode: true,
                        ),
                      ),
                    );
                  }
                },
              ),
              IconButton(
                icon: Icon(Icons.delete_outline, color: colorScheme.error),
                onPressed: () => _confirmDelete(context),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              story.title,
              style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                  ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: story.tags.map((tag) {
                final color = colorScheme.tagColors[tag] ?? colorScheme.primary;
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    tag,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
            _buildSection(context, 'Problem', story.problem),
            _buildSection(context, 'Action', story.action),
            _buildSection(context, 'Result', story.result),
            
            if (story.coaching != null) ...[
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 24),
              Text(
                'COACHING INSIGHTS',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colorScheme.gray600,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 16),
              CoachingDisplay(coaching: story.coaching),
            ],
            
            SizedBox(height: 48),
            ExpansionTile(
              title: Text('Raw Transcript', 
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant
                  )),
              children: [
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    story.rawTranscript,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontStyle: FontStyle.italic
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 48),
            Center(
              child: Text(
                'Created on ${DateFormat('MMMM d, yyyy').format(story.createdAt)}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String content) {
    return Padding(
      padding: EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              letterSpacing: 1.5,
            ),
          ),
          SizedBox(height: 8),
          Text(
            content,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

