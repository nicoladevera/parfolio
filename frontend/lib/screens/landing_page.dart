import 'package:flutter/material.dart';
import 'login_screen.dart';
import '../core/theme.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const _Navbar(),
            const _Hero(),
            const _Features(),
            const _Footer(),
          ],
        ),
      ),
    );
  }
}

class _Navbar extends StatelessWidget {
  const _Navbar();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 24),
      constraints: const BoxConstraints(maxWidth: 1200),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'PARfolio',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: AppColors.textMain,
            ),
          ),
          Row(
            children: [
              _NavLink(label: 'How it Works', onTap: () {}),
              _NavLink(label: 'Features', onTap: () {}),
              _NavLink(label: 'About', onTap: () {}),
              const SizedBox(width: 32),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ).copyWith(elevation: ButtonStyleButton.allOrNull(0)),
                child: const Text('Get Started', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NavLink extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _NavLink({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 32),
      child: InkWell(
        onTap: onTap,
        child: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            color: AppColors.textMain,
          ),
        ),
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.bgSoft, AppColors.bg],
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 60),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F0FE),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        '🎤 Voice-First Interview Prep',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    RichText(
                      text: TextSpan(
                        style: Theme.of(context).textTheme.displayLarge,
                        children: [
                          const TextSpan(text: 'Turn your work '),
                          TextSpan(
                            text: 'chaos',
                            style: AppTheme.scriptStyle.copyWith(fontSize: 56),
                          ),
                          const TextSpan(text: ' into interview '),
                          TextSpan(
                            text: 'gold',
                            style: AppTheme.scriptStyle.copyWith(
                              fontSize: 56,
                              color: AppColors.secondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Speak your messy thoughts. We structure them into clear Problem-Action-Result stories so you can interview with confidence.',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 32),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => LoginScreen()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          child: const Text('Start Recording →', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(width: 16),
                        OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            side: const BorderSide(color: Color(0xFFEEEEEE), width: 2),
                          ),
                          child: const Text('View Demo', style: TextStyle(fontSize: 18, color: AppColors.textMain, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Expanded(
                child: _HeroImage(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroImage extends StatelessWidget {
  const _HeroImage();

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Transform.rotate(
          angle: -0.035, // ~2 degrees
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F3F8),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: AppColors.primary.withOpacity(0.2), width: 2),
              boxShadow: [
                BoxShadow(
                  color: AppColors.secondary.withOpacity(0.6),
                  offset: const Offset(16, 16),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                'assets/hero_mockup.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Positioned(
          top: -20,
          right: 20,
          child: _FloatingBadge(label: '🌟 AI Structured'),
        ),
        Positioned(
          bottom: -20,
          left: -20,
          child: _FloatingBadge(label: '🎯 STAR Method'),
        ),
      ],
    );
  }
}

class _FloatingBadge extends StatelessWidget {
  final String label;
  const _FloatingBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 40,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
      ),
    );
  }
}

class _Features extends StatelessWidget {
  const _Features();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 60),
      child: Column(
        children: [
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: Theme.of(context).textTheme.headlineMedium,
              children: [
                const TextSpan(text: 'The best way to '),
                TextSpan(
                  text: 'prep',
                  style: AppTheme.scriptStyle.copyWith(fontSize: 40),
                ),
                const TextSpan(text: ' for your next role'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Forget the stress of blank pages. Just talk.',
            style: TextStyle(fontSize: 18, color: AppColors.textMuted),
          ),
          const SizedBox(height: 60),
          const Row(
            children: [
              Expanded(
                child: _FeatureCard(
                  icon: '🎙️',
                  title: 'Voice to PAR',
                  description: 'Ramble for 5 minutes. We extract the key details and format them into a perfect STAR/PAR answer.',
                  color: Color(0xFFF4F1FF),
                ),
              ),
              SizedBox(width: 32),
              Expanded(
                child: _FeatureCard(
                  icon: '🏷️',
                  title: 'Smart Tagging',
                  description: 'Organize your stories with auto-tags like "Leadership", "Conflict", and "Strategy".',
                  color: Color(0xFFFFF9E6),
                ),
              ),
              SizedBox(width: 32),
              Expanded(
                child: _FeatureCard(
                  icon: '📂',
                  title: 'Story Bank',
                  description: 'Build a searchable library of your career wins. Never forget a project detail again.',
                  color: Color(0xFFE6FAFA),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final String icon;
  final String title;
  final String description;
  final Color color;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(icon, style: const TextStyle(fontSize: 48)),
          const SizedBox(height: 24),
          Text(
            title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.textMain, letterSpacing: -0.48),
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: const TextStyle(fontSize: 16, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Center(
        child: Text(
          '© 2026 PARfolio. Nicely done.',
          style: TextStyle(color: AppColors.textMain.withOpacity(0.7), fontSize: 14),
        ),
      ),
    );
  }
}
