import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/memory_model.dart';
import '../../core/shadows.dart';

class MemoryEntryCard extends StatelessWidget {
  final MemoryEntry entry;
  final VoidCallback onDelete;

  const MemoryEntryCard({
    super.key,
    required this.entry,
    required this.onDelete,
  });

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
                      _getIconForSource(entry.sourceType),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              entry.sourceFilename,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              '${_capitalize(entry.sourceType)} • ${DateFormat('MMM dd, yyyy').format(entry.createdAt)}',
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
                  onPressed: onDelete,
                  tooltip: 'Delete Memory',
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                entry.content,
                style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: 14,
                  height: 1.5,
                  fontStyle: FontStyle.italic,
                ),
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // Category badges are hidden in UI as per user request to reduce distraction,
            // but the data remains in the model for AI agent context.
            /*
            if (entry.category.isNotEmpty) ...[
              const SizedBox(height: 12),
              _buildCategoryBadge(context, entry.category),
            ],
            */
          ],
        ),
      ),
    );
  }

  Widget _getIconForSource(String type) {
    IconData iconData;
    Color color;

    switch (type.toLowerCase()) {
      case 'resume':
        iconData = Icons.description_outlined;
        color = const Color(0xFF65A30D); // Lime 500
        break;
      case 'linkedin':
        iconData = Icons.link_outlined;
        color = const Color(0xFFF59E0B); // Amber 500
        break;
      default:
        iconData = Icons.history_edu_outlined;
        color = const Color(0xFF4B5563); // Gray 600
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

  Widget _buildCategoryBadge(BuildContext context, String category) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        _capitalize(category),
        style: TextStyle(
          color: Theme.of(context).colorScheme.onPrimaryContainer,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
