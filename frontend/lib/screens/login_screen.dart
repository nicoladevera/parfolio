import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../widgets/auth/polka_dot_rectangle.dart';
import '../widgets/auth/wavy_line_decoration.dart';
import '../widgets/auth/sunburst_decoration.dart';
import '../widgets/auth/ripple_decoration.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _obscurePassword = true;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isLoading = true);
    try {
      await Provider.of<AuthService>(context, listen: false).login(
        _emailController.text.trim(),
        _passwordController.text,
      );
      // Navigation is handled by auth state changes in main.dart
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceAll('Exception: ', '')),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final showDecorations = screenWidth > 600; // Hide on mobile

    return Scaffold(
      backgroundColor: const Color(0xFFF7FEE7), // Lime 50 background
      body: Stack(
        children: [
          // Decorative background elements (only on tablet+)
          if (showDecorations) ...[
            // Top-left: Polka dot rectangle with wavy line
            Positioned(
              top: 80,
              left: 40,
              child: PolkaDotRectangle(
                bgColor: const Color(0xFFFEF3C7), // Amber 100
                dotColor: const Color(0xFFD97706), // Amber 600
                width: 100,
                height: 120,
                rotation: -8,
              ),
            ),
            Positioned(
              top: 220,
              left: 20,
              child: WavyLineDecoration(
                color: const Color(0xFFD1D5DB), // Gray 300
                width: 100,
                height: 50,
              ),
            ),

            // Top-right: Person at laptop illustration
            Positioned(
              top: 60,
              right: 60,
              child: SunburstDecoration(
                color: const Color(0xFFA3E635), // Lime 300
                size: 160,
              ),
            ),

            // Bottom-left: Document icon
            Positioned(
              bottom: 100,
              left: 50,
              child: RippleDecoration(
                color: const Color(0xFFD1D5DB), // Gray 300
                size: 120,
              ),
            ),

            // Bottom-right: Polka dot rectangle
            Positioned(
              bottom: 80,
              right: 40,
              child: PolkaDotRectangle(
                bgColor: const Color(0xFFDCFCE7), // Lime 100
                dotColor: const Color(0xFF3F6212), // Lime 700
                width: 90,
                height: 100,
                rotation: 5,
              ),
            ),

            // Additional wavy line bottom-right
            Positioned(
              bottom: 200,
              right: 20,
              child: WavyLineDecoration(
                color: const Color(0xFFA3E635), // Lime 300
                width: 120,
                height: 60,
              ),
            ),
          ],

          // Centered form card (on top of decorations)
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(MediaQuery.of(context).size.width > 600 ? 40.0 : 24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                      // PARfolio Logo/Branding
                      Center(
                        child: Image.asset(
                          'assets/logos/parfolio-wordmark-nav.png',
                          height: 24,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Welcome Heading
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 48,
                          ),
                          children: [
                            const TextSpan(text: 'Welcome\n'),
                            TextSpan(
                              text: 'Back!',
                              style: const TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Subtitle
                      Text(
                        'Ready to ace your next interview?',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: const Color(0xFF4B5563), // Gray 600
                        ),
                      ),
                      const SizedBox(height: 40),
                          TextFormField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              prefixIcon: Icon(Icons.email_outlined),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (val) => val!.isEmpty ? 'Please enter email' : null,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _passwordController,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              prefixIcon: const Icon(Icons.lock_outline),
                              helperText: 'At least 6 characters',
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                            ),
                            obscureText: _obscurePassword,
                            validator: (val) => val!.length < 6 ? 'Password too short' : null,
                          ),
                          const SizedBox(height: 32),
                          ElevatedButton(
                            onPressed: _isLoading ? null : _login,
                            child: _isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text('Login'),
                          ),
                          if (AuthService.isGoogleAuthEnabled) ...[
                            const SizedBox(height: 24),
    
                            // Visual Divider for "OR"
                            Row(
                              children: [
                                const Expanded(child: Divider(color: Color(0xFFD1D5DB))), // Gray 300
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: Text(
                                    'OR',
                                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                      color: const Color(0xFF9CA3AF), // Gray 400
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                ),
                                const Expanded(child: Divider(color: Color(0xFFD1D5DB))),
                              ],
                            ),
                            const SizedBox(height: 24),
    
                            // Google Sign In Button
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: OutlinedButton(
                                onPressed: _isLoading ? null : () async {
                                  setState(() => _isLoading = true);
                                  try {
                                    await Provider.of<AuthService>(context, listen: false).signInWithGoogle();
                                    // Navigation handled by auth wrapper
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("Google Sign In failed: $e")),
                                    );
                                  } finally {
                                    if (mounted) setState(() => _isLoading = false);
                                  }
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.login),
                                    const SizedBox(width: 12),
                                    Text(
                                      "Continue with Google",
                                      style: Theme.of(context).textTheme.labelLarge,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],

                          const SizedBox(height: 24),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => RegisterScreen()),
                              );
                            },
                            child: Text.rich(
                              TextSpan(
                                text: "Don't have an account? ",
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                                children: [
                                  TextSpan(
                                    text: "Sign up",
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

