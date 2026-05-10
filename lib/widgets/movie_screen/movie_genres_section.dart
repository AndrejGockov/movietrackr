import 'package:flutter/cupertino.dart';
import 'package:movietrackr/widgets/shared/section_separator.dart';

import '../../app_theme.dart';
import '../../models/genre.dart';

class MovieGenres extends StatelessWidget {
  final List<Genre> genres;

  const MovieGenres({super.key, required this.genres});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Genres", style: AppTheme.h3SemiboldOnMediumBlue),

        SectionSeparator(),

        Wrap(
          spacing: AppTheme.sm,
          runSpacing: AppTheme.sm,
          children: genres.map((genre) {
            return Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.md,
                vertical: AppTheme.xs,
              ),
              decoration: BoxDecoration(
                color: AppTheme.deepBlue.withOpacity(0.6),
                borderRadius: BorderRadius.circular(AppTheme.xs),
              ),
              child: Text(genre.name, style: AppTheme.h5SemiboldOnMediumBlue),
            );
          }).toList(),
        ),

        SizedBox(height: AppTheme.xl),
      ],
    );
  }
}