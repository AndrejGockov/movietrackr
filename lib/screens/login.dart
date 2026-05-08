import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../widgets/shared/app_bar/app_bar.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var _isPasswordVisible = true;
  String errorMessage = '';
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  void login() async {
    try{
      await authService.value.login(
        email: emailController.text,
        password: passwordController.text,
      );
    }on FirebaseAuthException catch(e){
      print(e);
      errorMessage = e.message ?? 'There was an error signing in, please try again.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),

      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 50),

            // Email
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: "Email",
                hintText: "Enter Email",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: Icon(Icons.email, color: Colors.red.shade400),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red.shade400),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              // validator: (value) {
              //   if (value == null || value.isEmpty) {
              //     return 'Please enter your email';
              //   } else if (!isValidEmail(value)) {
              //     return 'Email not valid!';
              //   }
              //   return null;
              // },
            ),

            const SizedBox(height: 20),

            // Password
            TextFormField(
              controller: passwordController,
              obscureText: _isPasswordVisible,
              decoration: InputDecoration(
                labelText: "Password",
                hintText: "Enter Password",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: Icon(Icons.lock, color: Colors.red.shade400),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red.shade400),
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: Colors.red.shade400,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                } else if (value.length < 6) {
                  return 'Password should not have less than 6 characters.';
                }
                return null;
              },
            ),

            // Register Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade400,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                icon: const Icon(Icons.check_circle_outline),
                label: const Text("Register", style: TextStyle(fontSize: 16)),
                onPressed: () async {
                  // if (_formKey.currentState?.validate() ?? false) {
                  login();
                  // } else {
                  //   ScaffoldMessenger.of(context).showSnackBar(
                  //     const SnackBar(content: Text('Please fill input')),
                  //   );
                  // }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
