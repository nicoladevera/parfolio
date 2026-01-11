import 'package:flutter/material.dart';
import '../core/shadows.dart'; // Add this import

class RecordingCTA extends StatelessWidget {
  final VoidCallback onRecordPressed;

  const RecordingCTA({
    Key? key,
    required this.onRecordPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 600;
        
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFF7FEE7), // Lime 50 (Light background)
            borderRadius: BorderRadius.circular(24),
            boxShadow: Shadows.lg,
          ),
          padding: EdgeInsets.all(isNarrow ? 20 : 24),
          child: isNarrow 
            // Mobile: Text on top, images below in a row
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Center-aligned text content
                  Text(
                    'Record a New Story',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith( 
                      color: const Color(0xFF365314), // Lime 900
                      fontWeight: FontWeight.bold,
                      fontSize: 22, 
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Turn your work experience into interview gold.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFF365314).withOpacity(0.8), // Lime 900 reduced opacity
                      fontSize: 15,
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: onRecordPressed,
                    icon: Icon(Icons.mic_none_rounded, size: 20, color: Colors.white),
                    label: Text('Start Recording'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary, // Dark Lime Button
                      foregroundColor: Colors.white, // White Text/Icon
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                  ),
                  SizedBox(height: 16),
                  // Both images side by side, smaller and symmetrical
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/feature_voice_to_par_v3.png',
                        height: 90,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(width: 16),
                      Image.asset(
                        'assets/feature_smart_tagging_v3.png',
                        height: 90,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                ],
              )
            // Desktop: Left image, center text, right image
            : Row(
                children: [
                  // Left image
                  Expanded(
                    flex: 1,
                    child: Image.asset(
                      'assets/feature_voice_to_par_v3.png',
                      height: 160,
                      fit: BoxFit.contain,
                    ),
                  ),
                  // Center text content
                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Record a New Story',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith( 
                            color: const Color(0xFF365314), // Lime 900
                            fontWeight: FontWeight.bold,
                            fontSize: 24, 
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Turn your work experience into interview gold.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: const Color(0xFF365314).withOpacity(0.8), // Lime 900 reduced opacity
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
                            backgroundColor: Theme.of(context).colorScheme.primary, // Dark Lime Button
                            foregroundColor: Colors.white, // White Text/Icon
                            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Right image
                  Expanded(
                    flex: 1,
                    child: Image.asset(
                      'assets/feature_smart_tagging_v3.png',
                      height: 160,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
        );
      }
    );
  }
}
