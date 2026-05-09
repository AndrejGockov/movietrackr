import 'package:flutter/material.dart';
import '../../app_theme.dart';

InputDecoration inputDecoration(String label, IconData icon) {
  return InputDecoration(
    hintText: label,
    hintStyle: AppTheme.h4SemiboldOnMediumBlue,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    prefixIcon: Icon(icon, color: AppTheme.lightBlue),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: AppTheme.lightBlue),
      borderRadius: BorderRadius.circular(AppTheme.md),
    ),
    errorStyle: AppTheme.h6SemiboldPrimaryRed,
  );
}