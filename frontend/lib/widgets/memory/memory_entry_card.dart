import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/memory_model.dart';
import '../../core/shadows.dart';

class MemoryEntryCard extends StatefulWidget {
  final MemoryEntry entry;
  final VoidCallback onDelete;

  const MemoryEntryCard({
    super.key,
    required this.entry,
    required this.onDelete,
  });

  @override
  State<MemoryEntryCard> createState() => _MemoryEntryCardState();
}

class _MemoryEntryCardState extends State<MemoryEntryCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: Shadows.sm,
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      _getIconForSource(widget.entry.sourceType),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.entry.sourceFilename,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              '${_capitalize(widget.entry.sourceType)} • ${DateFormat('MMM dd, yyyy').format(widget.entry.createdAt)}',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                  onPressed: widget.onDelete,
                  tooltip: 'Delete Memory',
                ),
              ],
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.entry.content,
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 14,
                        height: 1.5,
                      ),
                      maxLines: _isExpanded ? null : 4,
                      overflow: _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          _isExpanded ? 'Show less' : 'Show more',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Icon(
                          _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                          size: 16,
                          color: Colors.grey[500],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getIconForSource(String type) {
    IconData iconData;
    const color = Color(0xFF65A30D); // Lime 500 - Homogenized color

    switch (type.toLowerCase()) {
      case 'resume':
        iconData = Icons.description_outlined;
        break;
      case 'linkedin':
        iconData = Icons.link_outlined;
        break;
      case 'article':
        iconData = Icons.article_outlined;
        break;
      case 'transcript':
        iconData = Icons.record_voice_over_outlined;
        break;
      default:
        iconData = Icons.history_edu_outlined;
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(iconData, color: color, size: 20),
    );
  }

  String _capitalize(String s) => s.isEmpty ? '' : '${s[0].toUpperCase()}${s.substring(1)}';
}
