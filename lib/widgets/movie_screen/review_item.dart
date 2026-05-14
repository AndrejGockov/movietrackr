import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../app_theme.dart';
import '../../models/review.dart';
import '../shared/section_separator.dart';
import '../../services/auth_service.dart';

class ReviewItem extends StatelessWidget {
  final Review review;
  final DateFormat dateFormatter;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  const ReviewItem({
    super.key,
    required this.review,
    required this.dateFormatter,
    this.onDelete,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final String currentUid = authService.value.user?.uid ?? '';
    final bool isOwner = review.userId == currentUid;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(review.username, style: AppTheme.h3SemiboldOnMediumBlue),
                const SizedBox(width: AppTheme.sm),
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
                const SizedBox(width: AppTheme.sm),
                const Icon(
                  Icons.star,
                  color: AppTheme.primaryYellow,
                  size: AppTheme.lg,
                ),

                if (isOwner)
                  PopupMenuButton<String>(
                    icon: const Icon(
                      Icons.more_vert,
                      color: AppTheme.textOnMediumBlue,
                      size: AppTheme.lg,
                    ),
                    color: AppTheme.mediumBlue,
                    onSelected: (value) {
                      if (value == 'edit') onEdit?.call();
                      if (value == 'delete') onDelete?.call();
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            const Icon(
                              Icons.edit_outlined,
                              color: AppTheme.lightBlue,
                              size: AppTheme.lg,
                            ),
                            const SizedBox(width: AppTheme.sm),
                            Text(
                              'Edit',
                              style: AppTheme.h5SemiboldOnMediumBlue,
                            ),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            const Icon(
                              Icons.delete_outline,
                              color: AppTheme.primaryRed,
                              size: AppTheme.lg,
                            ),
                            const SizedBox(width: AppTheme.sm),
                            Text(
                              'Delete',
                              style: AppTheme.h5SemiboldPrimaryRed,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
        const SizedBox(height: AppTheme.md),
        Text(review.content, style: AppTheme.h6SemiboldOnMediumBlue),
        const SizedBox(height: AppTheme.sm),
        const SectionSeparator(),
        const SizedBox(height: AppTheme.md),
      ],
    );
  }
}
