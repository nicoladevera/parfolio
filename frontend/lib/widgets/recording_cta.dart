import 'package:flutter/material.dart';
import '../core/shadows.dart';

class RecordingCTA extends StatelessWidget {
  final VoidCallback? onRecordPressed;
  final bool isNarrow;

  const RecordingCTA({
    Key? key,
    this.onRecordPressed,
    this.isNarrow = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // Hide subtext if it would likely wrap to 3 lines (on screens < 500px)
    final hideSubtext = isNarrow && screenWidth < 500;
    // Use column layout only for extremely narrow screens (< 340px)
    final useColumnLayout = isNarrow && screenWidth < 340;
    
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        // Both Mobile and Desktop: Lime 50
        color: const Color(0xFFF7FEE7),
        borderRadius: BorderRadius.circular(24),
        boxShadow: Shadows.md,
        border: isNarrow ? null : Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      padding: EdgeInsets.all(isNarrow ? 16 : 32),
      child: isNarrow 
        // Mobile: Adaptive layout based on width
        ? (useColumnLayout
            // Very narrow: Column layout
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF65A30D), // Lime 500
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.mic_none_rounded, color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Record a New Story',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (!hideSubtext) ...[
                    const SizedBox(height: 12),
                    Text(
                      'Turn your work experience into interview gold.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.black.withOpacity(0.7),
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: onRecordPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF65A30D),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      child: const Text('Start Recording', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    ),
                  ),
                ],
              )
            // Standard mobile: Row layout
            : Row(
                children: [
                  // Icon container
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF65A30D), // Lime 500
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.mic_none_rounded, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 12),
                  // Text - Matching desktop content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Record a New Story',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.black, // Pure black for readability
                            fontSize: 16,
                          ),
                        ),
                        if (!hideSubtext)
                          Text(
                            'Turn your work experience into interview gold.',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.black.withOpacity(0.7),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Button
                  ElevatedButton(
                    onPressed: onRecordPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF65A30D),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    child: const Text('Start Recording', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  ),
                ],
              )
          )
        // Desktop: Left-aligned Column layout that fills height
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start, // Left align content
            children: [
              Text(
                'Record a New Story',
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Turn your work experience into interview gold.',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.black.withOpacity(0.7),
                  fontSize: 16,
                  height: 1.4,
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: onRecordPressed,
                icon: Icon(Icons.mic_none_rounded, size: 20, color: Colors.white),
                label: Text(
                  'Start Recording',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF65A30D),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ],
          ),
    );
  }
}
