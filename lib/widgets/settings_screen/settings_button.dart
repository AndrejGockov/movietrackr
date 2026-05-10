import 'package:flutter/material.dart';
import '../../app_theme.dart';

class SettingsButton extends StatelessWidget {
  final String text;
  final TextStyle textStyle;
  final VoidCallback? onPressed;
  final Color backgroundColor;

  const SettingsButton({
    super.key,
    required this.text,
    required this.textStyle,
    required this.onPressed,
    this.backgroundColor = AppTheme.deepBlue,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.5,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.sm),
          ),
          padding: const EdgeInsets.symmetric(
            vertical: AppTheme.sm,
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: textStyle,
        ),
      ),
    );
  }
}