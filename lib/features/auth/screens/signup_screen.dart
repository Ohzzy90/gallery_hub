import 'package:flutter/material.dart';
import 'package:gallery_hub/auth/auth_server.dart';
import 'package:gallery_hub/tabs/home_page.dart';
import '../../../core/theme/app_colors.dart';
import 'login_screen.dart';


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      resizeToAvoidBottomInset: true,  // Adjust layout when keyboard appears
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SingleChildScrollView(  // Make content scrollable to avoid overflow
            child: Column(
              children: [
                const SizedBox(height: 40),

                // Logo with purple background and white icon
                Container(
                  height: 72,
                  width: 72,
                  decoration: BoxDecoration(
                    color: primaryPurple,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.palette,
                      color: Colors.white,
                      size: 36,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                const Text(
                  'Create Your Account',
                  style: TextStyle(
                    color: textPrimary,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 32),

                // Full Name
                _inputField(hint: 'Enter your full name', label: 'Full Name', controller: nameController),

                const SizedBox(height: 16),

                // Email
                _inputField(hint: 'Enter your email', label: 'Email',controller: emailController),

                const SizedBox(height: 16),

                // Password
                _inputField(
                  hint: 'Enter your password',
                  label: 'Password',
                  obscure: true,
                  controller: passwordController,
                ),

                const SizedBox(height: 24),

                // Sign Up Button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () async {
                      setState(() => _isLoading = true);
                      try {
                        await authServer.value.signUp(
                          email: emailController.text.trim(),
                          password: passwordController.text.trim(),
                          fullName: nameController.text,

                  ); if(!context.mounted) return;
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const HomePage()),
                        );
                  }
                      catch (e) {
                          // Handle sign-up error
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Sign Up Failed: $e')),
                        );
                      } finally {
              if (mounted) setState(() => _isLoading = false);
            }
    

                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryPurple,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: primaryPurple.withValues(alpha: 0.6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),

                    child : _isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    
                    : const Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Divider
                Row(
                  children: [
                    Expanded(child: Divider(color: Colors.white24)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'or sign up with',
                        style: TextStyle(color: textSecondary),
                      ),
                    ),
                    Expanded(child: Divider(color: Colors.white24)),
                  ],
                ),

                const SizedBox(height: 20),

                // Google Button
                _socialButton(text: 'Continue with Google',
                loading: _isLoading,
                 onPressed: () async {
                  setState(() => _isLoading = true);
                  try {
                    final userCredential = await authServer.value.signInWithGoogle();
                    if (userCredential != null) {
                      if(!context.mounted) return;
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const HomePage()),
                      );
                    }
                  } catch (e) {
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Google Sign-In Failed: $e')),
                    );
                  } finally {
            if (mounted) setState(() => _isLoading = false);
                  }
                }),

                const SizedBox(height: 12),

                // Apple Button
                _socialButton(text: 'Continue with Apple', filled: true,
                 onPressed: () {
                 
                },
                ),

                const SizedBox(height: 24),

                // Bottom Text
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an account? ',
                      style: TextStyle(color: textSecondary),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const LoginScreen()),
                        );
                      },
                      child: const Text(
                        'Log In',
                        style: TextStyle(
                          color: primaryPurple,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ================= Helpers =================

  static Widget _inputField({
    required String hint,
    required String label,
    required TextEditingController controller,
    bool obscure = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: textSecondary)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscure,
          style: const TextStyle(color: textPrimary),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.white38),
            filled: true,
            fillColor: Colors.white10,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  static Widget _socialButton({required String text, required VoidCallback onPressed, bool filled = false,
    bool loading = false,

  }) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: loading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: filled ? Colors.white : Colors.transparent,
          side: BorderSide(color: filled ? Colors.white : Colors.white24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: filled ? Colors.black : Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
