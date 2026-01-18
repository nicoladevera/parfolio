import 'package:flutter/material.dart';
import '../models/user_model.dart';

class WelcomeHeader extends StatelessWidget {
  final UserModel? user;
  final int storyCount;

  const WelcomeHeader({
    Key? key,
    required this.user,
    required this.storyCount,
  }) : super(key: key);

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  String get _displayName {
    // Try displayName first (which already has firstName fallback from UserModel)
    if (user?.displayName != null && user!.displayName!.isNotEmpty) {
      final firstName = user!.displayName!.split(' ').first;
      if (firstName.isNotEmpty) {
        return firstName[0].toUpperCase() + firstName.substring(1);
      }
      return firstName;
    }
    // Direct fallback to firstName field
    if (user?.firstName != null && user!.firstName!.isNotEmpty) {
      final name = user!.firstName!;
      return name[0].toUpperCase() + name.substring(1);
    }
    return '';
  }

  String get _subtitle {
    if (storyCount == 0) {
      return 'Ready to capture your first career story?';
    }
    final storyText = storyCount == 1 ? 'story' : 'stories';
    return 'You have $storyCount $storyText ready for your interviews.';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _displayName.isEmpty
              ? '$_greeting!'
              : '$_greeting, $_displayName!',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
        ),
        SizedBox(height: 12),
        Text(
          _subtitle,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      ],
    );
  }
}

