import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/story_model.dart';
import '../core/colors.dart';
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.onSurface),
        actions: [
          IconButton(
            icon: Icon(Icons.edit_outlined, color: Theme.of(context).colorScheme.onSurface),
            onPressed: () {
              if (onEdit != null) {
                onEdit!();
              } else {
                // Default behavior: navigate to edit screen
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
            icon: Icon(Icons.delete_outline, color: Theme.of(context).colorScheme.error),
            onPressed: () => _confirmDelete(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              story.title,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                  ),
            ),
            SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: story.tags.map((tag) {
                // Use extension for tag colors
                final color = Theme.of(context).colorScheme.tagColors[tag] ?? Theme.of(context).colorScheme.primary;
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    tag,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 32),
            _buildSection(context, 'Problem', story.problem),
            _buildSection(context, 'Action', story.action),
            _buildSection(context, 'Result', story.result),
            
            if (story.coaching != null) ...[
              SizedBox(height: 24),
              Divider(),
              SizedBox(height: 24),
              Text(
                'Coaching Insights',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
              SizedBox(height: 16),
              _buildInsightCard(context, 'Strength', story.coaching!.strength.overview, Theme.of(context).colorScheme.success),
              _buildInsightCard(context, 'Gap', story.coaching!.gap.overview, Theme.of(context).colorScheme.warning),
              _buildInsightCard(context, 'Suggestion', story.coaching!.suggestion.overview, Theme.of(context).colorScheme.info),
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
  
  Widget _buildInsightCard(BuildContext context, String title, String content, Color color) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.lightbulb_outline, size: 20, color: color),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  content,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

