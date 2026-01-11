import 'package:flutter/material.dart';
import '../models/story_model.dart';
import 'story_card.dart';

class StoriesList extends StatelessWidget {
  final List<StoryModel> stories;
  final bool isLoading;
  final Function(StoryModel) onStoryTap;
  final Function(String) onStoryDelete;

  const StoriesList({
    Key? key,
    required this.stories,
    required this.isLoading,
    required this.onStoryTap,
    required this.onStoryDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(color: Theme.of(context).colorScheme.primary),
      );
    }

    if (stories.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 48),
          child: Column(
            children: [
              Icon(Icons.notes, size: 48, color: Theme.of(context).colorScheme.outline),
              SizedBox(height: 16),
              Text(
                'No stories yet',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              SizedBox(height: 8),
              Text(
                'Record your first story above to get started',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      physics: NeverScrollableScrollPhysics(), // Scroll handled by parent
      shrinkWrap: true,
      itemCount: stories.length,
      itemBuilder: (context, index) {
        final story = stories[index];
        return StoryCard(
          story: story,
          onTap: () => onStoryTap(story),
          onDelete: () => onStoryDelete(story.id),
        );
      },
    );
  }
}

