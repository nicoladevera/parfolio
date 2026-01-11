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
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(24),
        boxShadow: Shadows.lg, // Use shared shadow definition
      ),
      child: Column(
        children: [
          Icon(
            Icons.mic_none_rounded,
            size: 48,
            color: Colors.white,
          ),
          SizedBox(height: 16),
          Text(
            'Record a New Story',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
          ),
          SizedBox(height: 8),
          Text(
            'Share your work experience and we\'ll turn it\ninto a structured PAR narrative.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 16,
              height: 1.5,
            ),
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: onRecordPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Theme.of(context).colorScheme.primary,
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Text(
              'Start Recording',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

