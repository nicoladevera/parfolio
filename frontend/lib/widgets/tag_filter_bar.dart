import 'package:flutter/material.dart';

class TagFilterBar extends StatelessWidget {
  final String selectedTag;
  final List<String> tags;
  final Function(String) onTagSelected;

  const TagFilterBar({
    Key? key,
    required this.selectedTag,
    required this.tags,
    required this.onTagSelected,
  }) : super(key: key);

  static const List<String> defaultTags = [
    'All',
    'Leadership',
    'Ownership',
    'Impact',
    'Communication',
    'Conflict',
    'Strategic Thinking',
    'Execution',
    'Adaptability',
    'Failure',
    'Innovation',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: tags.length,
        separatorBuilder: (context, index) => SizedBox(width: 8),
        itemBuilder: (context, index) {
          final tag = tags[index];
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
            selectedColor: const Color(0xFFECFCCB), // Light Lime (Landing Page Label)
            checkmarkColor: const Color(0xFF4D7C0F), // Dark Lime
            side: isSelected
              ? const BorderSide(color: Color(0xFF4D7C0F), width: 2) // Reverted to thicker border
              : BorderSide.none,
            labelStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: isSelected 
                ? const Color(0xFF4D7C0F) // Dark Lime (Landing Page Label)
                : Theme.of(context).colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12), // Increased padding for better spacing
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


