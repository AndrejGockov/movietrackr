import 'package:flutter/material.dart';
import 'package:movietrackr/widgets/shared/scrollable_movie_lists/shared/movie_grid.dart';

import '../../../app_theme.dart';
import '../../../models/movie_cover.dart';

class MovieVerticalSection extends StatelessWidget {
  final String gridTitle;
  final List<MovieCover> movies;

  final String path;

  const MovieVerticalSection({
    super.key,
    required this.gridTitle,
    required this.movies,
    required this.path,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppTheme.paddingXs,
      child: Column(
        children: [
          Padding(
            padding: AppTheme.paddingSm,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Title
                Text(gridTitle, style: AppTheme.h2SemiboldOnMediumBlue),
              ],
            ),
          ),

          MovieGrid(movies: movies),

          // See All link
          // GestureDetector(
          //   onTap: () {
          //     Navigator.pushNamed(context, "/", arguments: []);
          //   },
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       Text(
          //         "See More",
          //         style: AppTheme.h4SemiboldOnMediumBlue,
          //       ),
          //
          //       SizedBox(
          //         width: 5,
          //       ),
          //
          //       Icon(
          //         Icons.keyboard_double_arrow_down,
          //         size: AppTheme.lg,
          //         color: AppTheme.textOnMediumBlue,
          //       ),
          //     ],
          //   )
          // )
          ElevatedButton(
            onPressed: () async {
              Navigator.pushNamed(
                context,
                "/see_more",
                arguments: {
                  'title': gridTitle,
                  'path': path,
                },
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.deepBlue.withOpacity(0.6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTheme.md),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("See More", style: AppTheme.h4SemiboldOnMediumBlue),
                const SizedBox(width: AppTheme.sm),
                Icon(
                  Icons.keyboard_double_arrow_down,
                  size: AppTheme.lg,
                  color: AppTheme.textOnMediumBlue,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
