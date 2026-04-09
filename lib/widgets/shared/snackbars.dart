import 'package:flutter/material.dart';
import '../../app_theme.dart';

class Snackbars {
  static void showErrorSnackbar(BuildContext context, String message) {
    snackbar(context, message, AppTheme.primaryRed);
  }

  static void showSuccessSnackbar(BuildContext context, String message) {
    snackbar(context, message, AppTheme.primaryGreen);
  }

  static void showInfoSnackbar(BuildContext context, String message) {
    snackbar(context, message, AppTheme.deepBlue);
  }

  static void snackbar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(
          top: AppTheme.sm,
          left: AppTheme.md,
          right: AppTheme.md,
        ),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.xs),
        ),
      ),
    );
  }
}