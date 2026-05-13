import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../app_theme.dart';
import '../../models/review.dart';
import '../shared/section_separator.dart';

class ReviewItem extends StatelessWidget {
  final Review review;
  final DateFormat dateFormatter;

  const ReviewItem({
    super.key,
    required this.review,
    required this.dateFormatter,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  review.username,
                  style: AppTheme.h3SemiboldOnMediumBlue,
                ),
                SizedBox(width: AppTheme.sm),
                Text(
                  dateFormatter.format(review.timestamp),
                  style: AppTheme.h6SemiboldOnMediumBlue,
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  "${review.rating.toStringAsFixed(1)} / 10.0",
                  style: AppTheme.h5SemiboldOnMediumBlue.copyWith(
                    color: AppTheme.primaryYellow,
                  ),
                ),
                SizedBox(width: AppTheme.sm),
                Icon(
                  Icons.star,
                  color: AppTheme.primaryYellow,
                  size: AppTheme.lg,
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: AppTheme.md),
        Text(review.content, style: AppTheme.h6SemiboldOnMediumBlue),
        SizedBox(height: AppTheme.sm),
        SectionSeparator(),
        SizedBox(height: AppTheme.md),
      ],
    );
  }
}