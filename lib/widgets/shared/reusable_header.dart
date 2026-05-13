import 'package:flutter/material.dart';
import '../../app_theme.dart';

class ReusableHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onBackTap;

  const ReusableHeader({
    super.key,
    required this.title,
    this.onBackTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () {
            // Run custom logic if provided, then pop
            onBackTap?.call();
            Navigator.pop(context);
          },
          icon: CircleAvatar(
            radius: AppTheme.lg,
            backgroundColor: AppTheme.deepBlue.withOpacity(0.6),
            child: Icon(
              Icons.arrow_back_outlined,
              size: AppTheme.xl,
              color: AppTheme.textOnMediumBlue,
            ),
          ),
        ),

        const SizedBox(width: AppTheme.sm),

        Text(
          title,
          style: AppTheme.h1SemiboldOnMediumBlue,
        ),
      ],
    );
  }
}