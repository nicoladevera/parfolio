import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RecordingTipsBox extends StatelessWidget {
  const RecordingTipsBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB), // Amber 50
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFDE68A)), // Amber 200
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb_outline_rounded, color: const Color(0xFF3F6212), size: 20), // Lime 800
              const SizedBox(width: 8),
              Text(
                'Helpful Tips',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF3F6212), // Lime 800
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildTip('Aim for under 10 minutes.'),
          const SizedBox(height: 4),
          _buildTip('Include Problem, Action, Result — any order works!'),
          const SizedBox(height: 4),
          _buildTip('Don\'t worry about perfection.'),
        ],
      ),
    );
  }

  Widget _buildTip(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('• ', style: TextStyle(color: Color(0xFF3F6212), height: 1.4)), // Lime 800
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.inter(
              color: const Color(0xFF3F6212), // Lime 800
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
