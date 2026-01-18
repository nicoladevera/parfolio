import 'package:flutter/material.dart';
import '../../core/colors.dart';
import '../../core/spacing.dart';

class EditablePARSection extends StatefulWidget {
  final String label;
  final String content;
  final bool editable;
  final ValueChanged<String> onChanged;

  const EditablePARSection({
    super.key,
    required this.label,
    required this.content,
    this.editable = true,
    required this.onChanged,
  });

  @override
  State<EditablePARSection> createState() => _EditablePARSectionState();
}

class _EditablePARSectionState extends State<EditablePARSection> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.content);
  }

  @override
  void didUpdateWidget(EditablePARSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.content != widget.content) {
      _controller.text = widget.content;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: Spacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.gray200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(Spacing.lg, Spacing.md, Spacing.md, 0),
            child: Text(
              widget.label.toUpperCase(),
              style: theme.textTheme.labelSmall?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(Spacing.lg, Spacing.xs, Spacing.lg, Spacing.lg),
            child: TextFormField(
              controller: _controller,
              maxLines: null,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.gray700,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                hintText: 'Add ${widget.label.toLowerCase()}...',
                hintStyle: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.gray400,
                ),
              ),
              onChanged: widget.onChanged,
              readOnly: !widget.editable,
            ),
          ),
        ],
      ),
    );
  }
}
