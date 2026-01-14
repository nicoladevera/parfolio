import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RecordingTipsBox extends StatelessWidget {
  const RecordingTipsBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB), // Gray 50 - much subtler
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)), // Gray 200
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb_outline_rounded, color: const Color(0xFF65A30D), size: 18), // Lime 600
              const SizedBox(width: 8),
              Text(
                'Helpful Tips',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF374151), // Gray 700
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildTip('Aim for under 10 minutes.'),
          const SizedBox(height: 8),
          _buildTip('Include Problem, Action, Result — in any order.'),
          const SizedBox(height: 8),
          _buildTip('Don\'t worry about perfection.'),
        ],
      ),
    );
  }

  Widget _buildTip(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 2.0),
          child: Icon(Icons.check_circle_outline_rounded, size: 14, color: Color(0xFF65A30D)), // Lime 600
        ), 
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.inter(
              color: const Color(0xFF4B5563), // Gray 600
              fontSize: 13,
              height: 1.4,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
