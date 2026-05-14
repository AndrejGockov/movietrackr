import 'package:flutter/material.dart';
import '../../../app_theme.dart';

class PaginationControls extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final Function(int) onPageChanged;

  const PaginationControls({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (totalPages <= 1) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppTheme.md,
        vertical: AppTheme.sm,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.md,
        vertical: AppTheme.xs,
      ),
      decoration: BoxDecoration(
        color: AppTheme.deepBlue,
        borderRadius: BorderRadius.circular(AppTheme.sm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // First page button
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: currentPage > 1 ? () => onPageChanged(1) : null,
            icon: Icon(
              Icons.keyboard_double_arrow_left,
              size: AppTheme.xl,
              color: currentPage > 1
                  ? AppTheme.textOnMediumBlue
                  : AppTheme.textOnMediumBlue.withOpacity(0.3),
            ),
          ),

          // Previous page button
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: currentPage > 1 ? () => onPageChanged(currentPage - 1) : null,
            icon: Icon(
              Icons.keyboard_arrow_left,
              size: AppTheme.xl,
              color: currentPage > 1
                  ? AppTheme.textOnMediumBlue
                  : AppTheme.textOnMediumBlue.withOpacity(0.3),
            ),
          ),

          // Current page display
          Container(
            margin: const EdgeInsets.symmetric(horizontal: AppTheme.xs),
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.md,
              vertical: AppTheme.xs,
            ),
            child: Text(
              currentPage.toString(),
              style: AppTheme.h3SemiboldOnMediumBlue,
            ),
          ),

          // Next page button
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: currentPage < totalPages ? () => onPageChanged(currentPage + 1) : null,
            icon: Icon(
              Icons.keyboard_arrow_right,
              size: AppTheme.xl,
              color: currentPage < totalPages
                  ? AppTheme.textOnMediumBlue
                  : AppTheme.textOnMediumBlue.withOpacity(0.3),
            ),
          ),

          // Last page button
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: currentPage < totalPages ? () => onPageChanged(totalPages) : null,
            icon: Icon(
              Icons.keyboard_double_arrow_right,
              size: AppTheme.xl,
              color: currentPage < totalPages
                  ? AppTheme.textOnMediumBlue
                  : AppTheme.textOnMediumBlue.withOpacity(0.3),
            ),
          ),
        ],
      ),
    );
  }
}