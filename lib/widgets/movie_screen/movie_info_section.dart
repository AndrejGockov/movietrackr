import 'package:flutter/material.dart';

import '../../app_theme.dart';

class InfoSection extends StatelessWidget {
  final String year;
  final String runtime;
  final String genre;

  const InfoSection({
    super.key,
    required this.year,
    required this.runtime,
    required this.genre,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            Icon(
              Icons.calendar_month_outlined,
              size: AppTheme.lg,
              color: AppTheme.textOnMediumBlue,
            ),
            const SizedBox(height: AppTheme.sm),
            Text(
                year,
                style: AppTheme.h5SemiboldOnMediumBlue
            ),
          ],
        ),

        Column(
          children: [
            Icon(
              Icons.access_time_outlined,
              size: AppTheme.lg,
              color: AppTheme.textOnMediumBlue,
            ),
            const SizedBox(height: AppTheme.sm),
            Text("${runtime} minutes", style: AppTheme.h5SemiboldOnMediumBlue),
          ],
        ),

        Column(
          children: [
            Icon(
              Icons.local_movies_rounded,
              size: AppTheme.lg,
              color: AppTheme.textOnMediumBlue,
            ),
            const SizedBox(height: AppTheme.sm),
            Text(genre, style: AppTheme.h5SemiboldOnMediumBlue),
          ],
        ),
      ],
    );
  }
}