import 'package:flutter/material.dart';
import '../../core/colors.dart';
import '../../core/spacing.dart';

class TagEditor extends StatelessWidget {
  final List<String> tags;
  final bool editable;
  final Function(List<String>) onTagsChanged;

  static const List<String> allCompetencies = [
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

  const TagEditor({
    super.key,
    required this.tags,
    this.editable = true,
    required this.onTagsChanged,
  });

  void _removeTag(String tag) {
    if (!editable) return;
    final newTags = List<String>.from(tags)..remove(tag);
    onTagsChanged(newTags);
  }

  void _addTag(String tag) {
    if (!editable) return;
    if (tags.length >= 3) return;
    if (tags.contains(tag)) return;
    final newTags = List<String>.from(tags)..add(tag);
    onTagsChanged(newTags);
  }

  void _showTagPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(Spacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add Competency Tag',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: Spacing.sm),
              Text(
                'Select up to 3 behavioral competencies that best represent this story.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: Spacing.lg),
              Wrap(
                spacing: Spacing.sm,
                runSpacing: Spacing.sm,
                children: allCompetencies.map((tag) {
                  final isSelected = tags.contains(tag);
                  final canAdd = tags.length < 3;

                  return ActionChip(
                    label: Text(tag),
                    onPressed: isSelected || !canAdd ? null : () {
                      _addTag(tag);
                      Navigator.pop(context);
                    },
                    backgroundColor: isSelected ? Theme.of(context).colorScheme.primary.withOpacity(0.1) : null,
                    labelStyle: TextStyle(
                      color: isSelected ? Theme.of(context).colorScheme.primary : null,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: Spacing.xl),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'TAGS',
          style: theme.textTheme.labelSmall?.copyWith(
            color: colorScheme.gray600,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: Spacing.sm),
        Wrap(
          spacing: Spacing.sm,
          runSpacing: Spacing.sm,
          children: [
            ...tags.map((tag) => InputChip(
                  label: Text(tag),
                  onDeleted: editable ? () => _removeTag(tag) : null,
                  deleteIconColor: colorScheme.gray400,
                  backgroundColor: colorScheme.gray50,
                  side: BorderSide(color: colorScheme.gray200),
                  labelStyle: theme.textTheme.labelMedium?.copyWith(
                    color: colorScheme.gray700,
                  ),
                )),
            if (editable && tags.length < 3)
              ActionChip(
                avatar: Icon(Icons.add, size: 16, color: colorScheme.primary),
                label: Text(
                  'Add',
                  style: TextStyle(color: colorScheme.primary),
                ),
                onPressed: () => _showTagPicker(context),
                side: BorderSide(color: colorScheme.primary),
                backgroundColor: Colors.white,
              ),
          ],
        ),
      ],
    );
  }
}
