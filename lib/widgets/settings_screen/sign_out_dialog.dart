import 'package:flutter/material.dart';
import '../../app_theme.dart';

class SignOutDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const SignOutDialog({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppTheme.darkBlue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.md),
      ),
      title: Text(
        "Sign Out",
        style: AppTheme.h3SemiboldOnMediumBlue,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Are you sure you want to sign out of your account?",
            style: AppTheme.h5SemiboldOnMediumBlue,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cancel", style: AppTheme.h5SemiboldOnMediumBlue),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.deepBlue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.sm),
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
            onConfirm();
          },
          child: Text("Sign Out", style: AppTheme.h5SemiboldOnMediumBlue),
        ),
      ],
    );
  }
}