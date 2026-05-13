import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../shared/section_separator.dart';
import 'empty_section.dart';

class ProfileMoviesSection extends StatelessWidget {
  final String title;
  final List items;
  final String path;
  final Widget Function(dynamic) builder;

  const ProfileMoviesSection({
    super.key,
    required this.title,
    required this.items,
    required this.path,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    final displayItems = items.take(5).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title Header
        Row(
          children: [
            Text(title, style: AppTheme.h2SemiboldOnMediumBlue),
            const SizedBox(width: AppTheme.sm),
            Text(
              "(${items.length})",
              style: AppTheme.h4SemiboldOnMediumBlue.copyWith(
                color: AppTheme.lightBlue,
              ),
            ),
          ],
        ),
        const SectionSeparator(),
        const SizedBox(height: AppTheme.md),

        // Content
        if (items.isEmpty) const EmptySection(),
        ...displayItems.map((item) => builder(item)).toList(),

        // See More Button
        if (items.length > 5)
          Center(
            child: ElevatedButton(
              onPressed: () => Navigator.pushNamed(
                context,
                "/profile_movies",
                arguments: {
                  'title': title,
                  'path': path
                },
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.deepBlue.withOpacity(0.6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.md),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: AppTheme.md,
                  vertical: AppTheme.sm,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("See More", style: AppTheme.h4SemiboldOnMediumBlue),
                  SizedBox(width: AppTheme.sm),
                  Icon(
                    Icons.keyboard_double_arrow_down,
                    size: AppTheme.lg,
                    color: AppTheme.textOnMediumBlue,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
