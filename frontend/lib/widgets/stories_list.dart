import 'package:flutter/material.dart';
import '../models/story_model.dart';
import 'story_card.dart';
import '../widgets/empty_state_widget.dart';

class StoriesList extends StatelessWidget {
  final List<StoryModel> stories;
  final bool isLoading;
  final Function(StoryModel) onStoryTap;
  final Function(String) onStoryDelete;
  final VoidCallback? onGetStarted;

  const StoriesList({
    Key? key,
    required this.stories,
    required this.isLoading,
    required this.onStoryTap,
    required this.onStoryDelete,
    this.onGetStarted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(color: Theme.of(context).colorScheme.primary),
      );
    }

    if (stories.isEmpty) {
      return EmptyStateWidget(
        onGetStarted: onGetStarted ?? () {},
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

