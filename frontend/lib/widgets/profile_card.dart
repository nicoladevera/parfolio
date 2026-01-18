import 'package:flutter/material.dart';
import '../core/shadows.dart';
import '../models/user_model.dart';
import '../screens/user_profile_screen.dart';

class ProfileCard extends StatelessWidget {
  final UserModel? user;
  final VoidCallback? onEditPressed;
  final bool isMobile;

  const ProfileCard({
    Key? key,
    required this.user,
    this.onEditPressed,
    this.isMobile = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: isMobile ? null : BoxConstraints(minHeight: 212),
      decoration: BoxDecoration(
        // Mobile: Transparent/No background
        // Desktop: Lime 50 background
        color: isMobile ? Colors.transparent : Colors.white,
        borderRadius: BorderRadius.circular(20),
        // Desktop: Dark Lime border (Lime 500)
        border: isMobile ? null : Border.all(
          color: Colors.grey.withOpacity(0.2), // Subtle gray border like RecordingCTA
          width: 1,
        ),
        // Desktop: Shadow matching Navigation Bar
        boxShadow: isMobile ? [] : Shadows.md,
      ),
      padding: isMobile ? EdgeInsets.zero : const EdgeInsets.all(24),
      child: isMobile
          ? _buildMobileLayout(context)
          : _buildDesktopLayout(context),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildProfileImage(120), // Larger photo for desktop (120px)
        const SizedBox(width: 24),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildName(context, fontSize: 30), // Larger name (30px)
              const SizedBox(height: 6),
              _buildRole(context, fontSize: 18), // Larger role (18px)
              const SizedBox(height: 12),
              _buildEditButton(context), // Edit below name/role
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildProfileImage(120), // Larger photo for mobile (120px)
        const SizedBox(height: 20),
        _buildName(context, align: TextAlign.center, fontSize: 28), // Larger name
        const SizedBox(height: 6),
        _buildRole(context, align: TextAlign.center, fontSize: 18), // Larger role
        const SizedBox(height: 14),
        _buildEditButton(context),
      ],
    );
  }

  Widget _buildProfileImage(double size) {
    ImageProvider? imageProvider;
    if (user?.profilePhotoUrl != null && user!.profilePhotoUrl!.isNotEmpty) {
      imageProvider = NetworkImage(user!.profilePhotoUrl!);
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(
          color: const Color(0xFF65A30D), // Lime 500
          width: 3,
        ),
        // Specific subtle dark lime shadow on photo
        boxShadow: [
          BoxShadow(
             color: const Color(0xFF65A30D).withOpacity(0.2), // Lime 500
             blurRadius: 12,
             offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipOval(
        child: imageProvider != null
            ? Image(image: imageProvider, fit: BoxFit.cover)
            : Center(
                child: Text(
                  (user?.firstName?.isNotEmpty == true
                          ? user!.firstName![0]
                          : user?.displayName?.isNotEmpty == true
                              ? user!.displayName![0]
                              : '?')
                      .toUpperCase(),
                  style: TextStyle(
                    fontSize: size * 0.4,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF65A30D), // Lime 500
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildName(BuildContext context, {TextAlign align = TextAlign.left, double fontSize = 22}) {
    final name = (user?.firstName != null && user!.firstName!.isNotEmpty)
        ? '${user!.firstName} ${user!.lastName ?? ''}'.trim()
        : user?.displayName ?? 'Welcome';

    return Text(
      name,
      textAlign: align,
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: fontSize,
            color: const Color(0xFF365314), // Dark lime green (Lime 900)
            height: 1.2,
          ),
    );
  }

  Widget _buildRole(BuildContext context, {TextAlign align = TextAlign.left, double fontSize = 14}) {
    final role = user?.currentRole ?? 'No role added';
    
    return Text(
      role,
      textAlign: align,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: fontSize,
            color: const Color(0xFF365314), // Dark lime green (Lime 900)
          ),
    );
  }

  Widget _buildEditButton(BuildContext context) {
    return GestureDetector(
      onTap: onEditPressed ?? () {
         Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => UserProfileScreen()),
          );
      },
      child: Text(
        'Edit',
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: const Color(0xFF65A30D), // Lime 500
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.underline,
          decorationColor: const Color(0xFF65A30D),
        ),
      ),
    );
  }
}
