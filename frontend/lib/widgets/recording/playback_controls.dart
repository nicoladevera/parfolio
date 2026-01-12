import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PlaybackControls extends StatelessWidget {
  final bool isPlaying;
  final Duration position;
  final Duration duration;
  final VoidCallback onPlayPause;
  final ValueChanged<Duration> onSeek;

  const PlaybackControls({
    required this.isPlaying,
    required this.position,
    required this.duration,
    required this.onPlayPause,
    required this.onSeek,
    Key? key,
  }) : super(key: key);

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(d.inMinutes.remainder(60));
    final seconds = twoDigits(d.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 8.0,
            activeTrackColor: Theme.of(context).colorScheme.primary,
            inactiveTrackColor: const Color(0xFFDCFCE7), // Lime 100
            thumbColor: Theme.of(context).colorScheme.primary,
            overlayColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8.0),
            trackShape: const RoundedRectSliderTrackShape(),
          ),
          child: Slider(
            value: position.inMilliseconds.toDouble().clamp(0, duration.inMilliseconds.toDouble()),
            max: duration.inMilliseconds.toDouble() > 0 ? duration.inMilliseconds.toDouble() : 1.0,
            onChanged: (value) {
              onSeek(Duration(milliseconds: value.toInt()));
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_formatDuration(position), style: GoogleFonts.inter(fontSize: 12, color: Colors.grey[600])),
              Text(_formatDuration(duration), style: GoogleFonts.inter(fontSize: 12, color: Colors.grey[600])),
            ],
          ),
        ),
        const SizedBox(height: 16),
        IconButton(
          onPressed: onPlayPause,
          icon: Icon(isPlaying ? Icons.pause_circle_filled_rounded : Icons.play_circle_filled_rounded),
          iconSize: 64,
          color: Theme.of(context).colorScheme.primary,
        ),
      ],
    );
  }
}
