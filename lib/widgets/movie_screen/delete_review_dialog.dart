import 'package:flutter/material.dart';
import '../../../app_theme.dart';

class DeleteReviewDialog extends StatelessWidget {
  const DeleteReviewDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppTheme.darkBlue,
      title: Text(
        "Delete Review",
        style: AppTheme.h2SemiboldOnMediumBlue,
      ),
      content: Text(
        "Are you sure you want to delete your review?",
        style: AppTheme.h5SemiboldOnMediumBlue,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(
            "Cancel",
            style: AppTheme.h4SemiboldOnMediumBlue,
          ),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(
            "Delete",
            style: AppTheme.h4SemiboldPrimaryRed,
          ),
        ),
      ],
    );
  }
}