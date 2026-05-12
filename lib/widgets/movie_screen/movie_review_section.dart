import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../app_theme.dart';
import '../../models/review.dart';
import '../shared/loading_screen.dart';
import 'review_item.dart';

class MovieReviews extends StatelessWidget {
  final List<Review> reviews;
  final bool isLoadingMore;
  final bool hasMore;
  final VoidCallback onLoadMore;
  final DateFormat dateFormatter;

  const MovieReviews({
    super.key,
    required this.reviews,
    required this.isLoadingMore,
    required this.hasMore,
    required this.onLoadMore,
    required this.dateFormatter,
  });

  @override
  Widget build(BuildContext context) {
    if (reviews.isEmpty && isLoadingMore) {
      return const LoadingScreen();
    }

    if (reviews.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.md),
          child: Text(
            "No reviews yet.",
            style: AppTheme.h5SemiboldOnMediumBlue,
          ),
        ),
      );
    }

    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: reviews.length,
          itemBuilder: (context, index) => ReviewItem(
            review: reviews[index],
            dateFormatter: dateFormatter,
          ),
        ),
        if (hasMore)
          TextButton(
            onPressed: isLoadingMore ? null : onLoadMore,
            child: isLoadingMore
                ? const SizedBox(
              height: AppTheme.md,
              width: AppTheme.md,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppTheme.lightBlue,
              ),
            )
                : const Text(
              "Load more reviews",
              style: TextStyle(color: AppTheme.lightBlue),
            ),
          ),
      ],
    );
  }
}