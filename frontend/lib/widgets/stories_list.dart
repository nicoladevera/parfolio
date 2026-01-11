import 'package:flutter/material.dart';
import '../models/story_model.dart';
import 'story_card.dart';

import '../widgets/auth/sunburst_decoration.dart'; // Add import

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
      return Container(
        height: 200,
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Stack(
          children: [
             // Decoration in whitespace (top-left of this section, not behind text)
             Positioned(
               top: 0,
               left: 20, 
               child: Opacity(
                 opacity: 0.5,
                 child: SunburstDecoration(
                   size: 120,
                   color: const Color(0xFFA3E635), // Lime 300
                 ),
               ),
             ),
             
             // Text centered
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Your career stories are waiting',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Speak your experiences, we\'ll organize them for you',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
          ],
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

