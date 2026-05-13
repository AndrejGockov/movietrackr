import 'dart:math';
import 'package:flutter/material.dart';
import '../../app_theme.dart';

class ReviewStats extends StatelessWidget {
  final List<double> ratings;

  const ReviewStats({super.key, required this.ratings});

  @override
  Widget build(BuildContext context) {
    if (ratings.isEmpty) return const SizedBox.shrink();

    // Map the stats for easy looping
    final stats = [
      {'label': 'Average:', 'val': (ratings.reduce((a, b) => a + b) / ratings.length).toStringAsFixed(1), 'color': AppTheme.mediumBlue},
      {'label': 'Highest:', 'val': ratings.reduce(max).toStringAsFixed(1), 'color': AppTheme.lightBlue},
      {'label': 'Lowest:', 'val': ratings.reduce(min).toStringAsFixed(1), 'color': AppTheme.deepBlue},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Reviews", style: AppTheme.h3SemiboldOnMediumBlue),
        const SizedBox(height: AppTheme.sm),

        Wrap(
          direction: Axis.vertical,
          spacing: AppTheme.sm,
          children: stats.map((stat) => Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.md,
              vertical: AppTheme.xs,
            ),
            decoration: BoxDecoration(
              color: AppTheme.deepBlue.withOpacity(0.6),
              borderRadius: BorderRadius.circular(AppTheme.xs),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "${stat['label']} ${stat['val']}",
                  style: AppTheme.h5SemiboldOnMediumBlue,
                ),
                SizedBox(width: AppTheme.sm),
                Icon(
                  Icons.star,
                  size: AppTheme.md,
                  color: stat['color'] as Color,
                ),
              ],
            ),
          )).toList(),
        ),
      ],
    );
  }
}