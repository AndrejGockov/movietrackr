import 'package:flutter/material.dart';
import '../../app_theme.dart';

class EmptySection extends StatelessWidget {
  const EmptySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppTheme.md),
      child: Text(
        "Nothing here yet...",
        style: AppTheme.h6SemiboldOnMediumBlue,
      ),
    );
  }
}