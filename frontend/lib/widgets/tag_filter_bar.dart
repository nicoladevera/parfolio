import 'package:flutter/material.dart';

class TagFilterBar extends StatelessWidget {
  final String selectedTag;
  final Function(String) onTagSelected;

  const TagFilterBar({
    Key? key,
    required this.selectedTag,
    required this.onTagSelected,
  }) : super(key: key);

  final List<String> _tags = const [
    'All',
    'Leadership',
    'Communication',
    'Impact',
    'Problem-Solving',
    'Collaboration',
    'Strategic Thinking',
    'Innovation',
    'Adaptability',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _tags.length,
        separatorBuilder: (context, index) => SizedBox(width: 8),
        itemBuilder: (context, index) {
          final tag = _tags[index];
          final isSelected = selectedTag == tag;
          
          return FilterChip(
            label: Text(
              tag,
              overflow: TextOverflow.visible,
              softWrap: false,
            ),
            selected: isSelected,
            onSelected: (_) => onTagSelected(tag),
            // Unselected: Gray 100
            // Selected: Lime 100 (primaryContainer)
            backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest, 
            selectedColor: Theme.of(context).colorScheme.primaryContainer, 
            checkmarkColor: Theme.of(context).colorScheme.primary, // Lime 700ish
            side: isSelected
              ? BorderSide(color: Theme.of(context).colorScheme.primary, width: 2)
              : BorderSide.none,
            labelStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: isSelected 
                ? Theme.of(context).colorScheme.onPrimaryContainer // Strong text for selected
                : Theme.of(context).colorScheme.onSurfaceVariant, // Gray 600 for unselected
              fontWeight: FontWeight.w600,
            ),
            padding: EdgeInsets.symmetric(horizontal: 4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(999),
            ),
            showCheckmark: false,
          );
        },
      ),
    );
  }
}


