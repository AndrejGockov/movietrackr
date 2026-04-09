import 'package:flutter/material.dart';
import 'package:movietrackr/models/movie_cover.dart';

import '../../../app_theme.dart';
import 'shared/movie_row.dart';

class MovieHorizontalSection extends StatelessWidget {
  final String rowTitle;
  final List<MovieCover> movies;

  final String path;

  const MovieHorizontalSection({
    super.key,
    required this.rowTitle,
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
                Text(rowTitle, style: AppTheme.h2SemiboldOnMediumBlue),

                // See All link
                GestureDetector(
                  onTap: () async {
                    Navigator.pushNamed(
                      context,
                      "/see_more",
                      arguments: {
                        'title': rowTitle,
                        'path': path,
                      },
                    );
                  },
                  // child: Text(
                  //   "See All",
                  //   style: AppTheme.h5SemiboldOnMediumBlue,
                  // ),
                  child: CircleAvatar(
                    radius: AppTheme.md,
                    backgroundColor: AppTheme.deepBlue.withOpacity(0.6),
                    child: Icon(
                      Icons.arrow_forward_outlined,
                      size: AppTheme.lg,
                      color: AppTheme.textOnMediumBlue,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Movies list
          MovieRow(movies: movies),
        ],
      ),
    );
  }
}
