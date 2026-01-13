import 'package:flutter/material.dart';

class EmptyStateWidget extends StatelessWidget {
  final VoidCallback onGetStarted;

  const EmptyStateWidget({
    Key? key,
    required this.onGetStarted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Illustration
            // Using a container with shadow/decoration to make it pop like the inspiration if needed
            // But the asset itself is likely sufficient.
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 200),
              child: Image.asset(
                'assets/empty_state_v2.png',
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 2), // Tighter spacing for image-to-title
            
            // Text - Original wording restored
            Text(
              "Your career stories are waiting",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                    height: 1.3,
                  ),
            ),
            const SizedBox(height: 4), // Minimal spacing between lines
             Text(
              "Speak your experiences, we'll organize them for you",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 24), // Restored spacing before button

            // Button
            ElevatedButton(
              onPressed: onGetStarted,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF65A30D), // Lime 500
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                elevation: 2,
              ),
              child: const Text(
                'Get Started',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
