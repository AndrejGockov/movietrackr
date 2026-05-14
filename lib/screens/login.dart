import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:movietrackr/screens/main_screen.dart';
import 'package:movietrackr/screens/register.dart';

import '../app_theme.dart';
import '../services/auth_service.dart';
import '../widgets/shared/app_bar/app_bar.dart';
import '../widgets/shared/textformfield_input_decoration.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = true;
  String errorMessage = '';

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void login() async {
    setState(() => errorMessage = '');

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    try {
      await authService.value.login(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = 'Login failed. Please check your email and password.';
      });
    } catch (e) {
      setState(() {
        errorMessage = 'An unexpected error occurred. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBlue,
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: AppTheme.paddingLg,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: AppTheme.xxl),
                Text("Welcome Back", style: AppTheme.h1SemiboldOnMediumBlue),
                const SizedBox(height: AppTheme.md),
                Text(
                  "Log in to your account",
                  style: AppTheme.h5SemiboldOnMediumBlue,
                ),
                const SizedBox(height: AppTheme.xl),

                // Email Field
                TextFormField(
                  controller: emailController,
                  style: AppTheme.h5SemiboldOnMediumBlue,
                  keyboardType: TextInputType.emailAddress,
                  decoration: inputDecoration("Email", Icons.email),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty)
                      return 'Please enter your email';
                    else if (!authService.value.isValidEmail(value.trim()))
                      return 'Email is not valid';
                    return null;
                  },
                ),

                const SizedBox(height: AppTheme.xl),

                // Password Field
                TextFormField(
                  controller: passwordController,
                  style: AppTheme.h5SemiboldOnMediumBlue,
                  obscureText: _isPasswordVisible,
                  decoration: inputDecoration("Password", Icons.lock).copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: AppTheme.lightBlue,
                      ),
                      onPressed: () => setState(
                        () => _isPasswordVisible = !_isPasswordVisible,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Please enter your password';
                    return null;
                  },
                ),

                // Global Error Message
                if (errorMessage.isNotEmpty) ...[
                  const SizedBox(height: AppTheme.lg),
                  Text(
                    errorMessage,
                    style: AppTheme.h6SemiboldPrimaryRed,
                    textAlign: TextAlign.center,
                  ),
                ],

                const SizedBox(height: AppTheme.xl),

                // Login Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.deepBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppTheme.md),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: AppTheme.md,
                      ),
                    ),
                    onPressed: login,
                    child: Text(
                      "Log in",
                      style: AppTheme.h4SemiboldOnMediumBlue,
                    ),
                  ),
                ),

                const SizedBox(height: AppTheme.lg),

                // Sign Up
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: AppTheme.h5SemiboldOnMediumBlue,
                    ),

                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Sign up",
                            style: AppTheme.h5SemiboldLinkSecondary,
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  '/register',
                                  (route) => false,
                                );
                              },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppTheme.md),

                // Forgot Password
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Forgot password?",
                        style: AppTheme.h5SemiboldLinkSecondary,
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              '/register',
                              (route) => false,
                            );
                          },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
