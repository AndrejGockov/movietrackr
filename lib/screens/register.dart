import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:movietrackr/screens/login.dart';

import '../app_theme.dart';
import '../services/auth_service.dart';
import '../widgets/shared/app_bar/app_bar.dart';
import '../widgets/shared/textformfield_input_decoration.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = true;
  String errorMessage = '';

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void register() async {
    setState(() => errorMessage = '');

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    try {
      await authService.value.register(
        username: usernameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message ?? 'Registration failed. Please try again.';
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
                Text(
                  "Join MovieTrackr",
                  style: AppTheme.h1SemiboldOnMediumBlue,
                ),
                const SizedBox(height: AppTheme.md),
                Text(
                  "Where every seat has a voice",
                  style: AppTheme.h5SemiboldOnMediumBlue,
                ),
                const SizedBox(height: AppTheme.xl),

                // Username Field
                TextFormField(
                  controller: usernameController,
                  style: AppTheme.h5SemiboldOnMediumBlue,
                  decoration: inputDecoration("Username", Icons.person),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty)
                      return 'Please enter a username';
                    return null;
                  },
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
                      return 'Please create a password';
                    else if (value.length < 6)
                      return 'Password must be at least 6 characters long';

                    return null;
                  },
                ),

                // Only shows global errors
                if (errorMessage.isNotEmpty) ...[
                  const SizedBox(height: AppTheme.lg),
                  Text(
                    errorMessage,
                    style: AppTheme.h6SemiboldPrimaryRed,
                    textAlign: TextAlign.center,
                  ),
                ],

                const SizedBox(height: AppTheme.xxl),

                // Register Button
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
                    onPressed: register,
                    child: Text(
                      "Create new account",
                      style: AppTheme.h4SemiboldOnMediumBlue,
                    ),
                  ),
                ),

                const SizedBox(height: AppTheme.lg),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account? ",
                      style: AppTheme.h5SemiboldOnMediumBlue,
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Log in",
                            style: AppTheme.h5SemiboldLinkSecondary,
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Login(),
                                  ),
                                );
                              },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
