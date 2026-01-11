import 'package:flutter/material.dart';
import '../core/theme.dart';

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
          final color = tag == 'All' 
              ? AppColors.primary 
              : (AppColors.tagColors[tag] ?? AppColors.primary);

          return FilterChip(
            label: Text(tag),
            selected: isSelected,
            onSelected: (_) => onTagSelected(tag),
            backgroundColor: Colors.transparent,
            selectedColor: color.withOpacity(0.1),
            checkmarkColor: color,
            side: BorderSide(
              color: isSelected ? color : Colors.grey.shade300,
            ),
            labelStyle: TextStyle(
              color: isSelected ? color : AppColors.textMain,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
            padding: EdgeInsets.symmetric(horizontal: 4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            showCheckmark: false,
          );
        },
      ),
    );
  }
}
