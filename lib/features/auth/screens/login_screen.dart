import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../widgets/auth_text_field.dart';
import 'signup_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 40),

              const Icon(Icons.palette, color: primaryPurple, size: 48),
              const SizedBox(height: 16),

              const Text(
                'Login',
                style: TextStyle(
                  color: textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 32),

              const AuthTextField(hint: 'Enter your email'),
              const SizedBox(height: 16),
              const AuthTextField(hint: 'Enter your password', obscure: true),

              const SizedBox(height: 8),

              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(color: textSecondary, fontSize: 12),
                ),
              ),

              const SizedBox(height: 24),

              _primaryButton('Log In'),

              const SizedBox(height: 24),

              Text('or sign in with', style: TextStyle(color: textSecondary)),

              const SizedBox(height: 16),

              _socialButton('Continue with Google'),
              const SizedBox(height: 12),
              _appleButton(),

              const Spacer(),

              // Text.rich(
              //   TextSpan(
              //     text: "Don't have an account? ",
              //     style: TextStyle(color: textSecondary),
              //     children: const [
              //       TextSpan(
              //         text: 'Sign Up',
              //         style: TextStyle(color: primaryPurple),
              //       ),
              //     ],
              //   ),
              // ),
              Text.rich(
                TextSpan(
                  text: "Don't have an account? ",
                  style: TextStyle(color: textSecondary),
                  children: [
                    WidgetSpan(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SignUpScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                            color: primaryPurple,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _primaryButton(String text) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryPurple,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Text(text),
      ),
    );
  }

  Widget _socialButton(String text) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.white24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Text(text, style: const TextStyle(color: textPrimary)),
      ),
    );
  }

  Widget _appleButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: const Text(
          'Continue with Apple',
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
