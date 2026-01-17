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
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.content);
  }

  @override
  void didUpdateWidget(EditablePARSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.content != widget.content && !_isEditing) {
      _controller.text = widget.content;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleEdit() {
    if (!widget.editable) return;
    setState(() {
      _isEditing = !_isEditing;
    });
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.label.toUpperCase(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                if (widget.editable)
                  IconButton(
                    icon: Icon(
                      _isEditing ? Icons.check_circle_outline : Icons.edit_outlined,
                      size: 20,
                      color: _isEditing ? colorScheme.primary : colorScheme.gray400,
                    ),
                    onPressed: _toggleEdit,
                    constraints: const BoxConstraints(),
                    padding: EdgeInsets.zero,
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(Spacing.lg, 0, Spacing.lg, Spacing.lg),
            child: _isEditing
                ? TextFormField(
                    controller: _controller,
                    maxLines: null,
                    autofocus: true,
                    style: theme.textTheme.bodyMedium,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                    onChanged: widget.onChanged,
                  )
                : Text(
                    _controller.text.isEmpty ? 'Tap to add ${widget.label.toLowerCase()}...' : _controller.text,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: _controller.text.isEmpty ? colorScheme.gray400 : colorScheme.gray700,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
