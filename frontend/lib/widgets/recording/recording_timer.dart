import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RecordingTimer extends StatelessWidget {
  final Duration duration;

  const RecordingTimer({required this.duration, Key? key}) : super(key: key);

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(d.inMinutes.remainder(60));
    final seconds = twoDigits(d.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _formatDuration(duration),
      style: GoogleFonts.inter(
        fontSize: 48,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF111827), // Gray 900
        fontFeatures: [const FontFeature.tabularFigures()],
      ),
    );
  }
}
