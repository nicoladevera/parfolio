import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/story_model.dart';
import '../core/theme.dart';

class StoryDetailScreen extends StatelessWidget {
  final StoryModel story;
  final Function(String) onDelete;

  const StoryDetailScreen({
    Key? key,
    required this.story,
    required this.onDelete,
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
            child: Text('Delete', style: TextStyle(color: Colors.red)),
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
        iconTheme: IconThemeData(color: AppColors.textMain),
        actions: [
          IconButton(
            icon: Icon(Icons.edit_outlined, color: AppColors.textMain),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Edit coming soon!')),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.delete_outline, color: Colors.red),
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
                final color = AppColors.tagColors[tag] ?? AppColors.primary;
                return Chip(
                  label: Text(tag),
                  backgroundColor: color.withOpacity(0.1),
                  labelStyle: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                  side: BorderSide.none,
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
                      color: AppColors.primary,
                    ),
              ),
              SizedBox(height: 16),
              _buildInsightCard(context, 'Strength', story.coaching!.strength, Colors.green),
              _buildInsightCard(context, 'Gap', story.coaching!.gap, Colors.orange),
              _buildInsightCard(context, 'Suggestion', story.coaching!.suggestion, AppColors.primary),
            ],
            
            SizedBox(height: 48),
            ExpansionTile(
              title: Text('Raw Transcript', 
                  style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textMuted)),
              children: [
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    story.rawTranscript,
                    style: TextStyle(color: AppColors.textMuted, height: 1.5, fontStyle: FontStyle.italic),
                  ),
                ),
              ],
            ),
            SizedBox(height: 48),
            Center(
              child: Text(
                'Created on ${DateFormat('MMMM d, yyyy').format(story.createdAt)}',
                style: TextStyle(color: AppColors.textMuted),
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
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.textMuted,
              letterSpacing: 1,
            ),
          ),
          SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              fontSize: 16,
              height: 1.6,
              color: AppColors.textMain,
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
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: color,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  content,
                  style: TextStyle(color: AppColors.textMain),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
