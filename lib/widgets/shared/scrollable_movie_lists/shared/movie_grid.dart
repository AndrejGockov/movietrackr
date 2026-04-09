import 'package:flutter/material.dart';
import 'package:movietrackr/models/movie_cover.dart';

import '../../../../app_theme.dart';
import 'movie_cover_card.dart';

class MovieGrid extends StatelessWidget {
  final List<MovieCover>movies;

  const MovieGrid({super.key, required this.movies});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: AppTheme.paddingSm,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 4.0,
        childAspectRatio:
        150 / 210,
        // 150 / 240, // Adjust based on child's width/height
      ),

      itemCount: movies.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              "/",
              arguments: movies[index].id,
            );
          },

          child: FittedBox(
            fit: BoxFit.contain,
            alignment: Alignment.topCenter,
            child: MovieCoverCard(movieCover: movies[index]),
          ),
        );
      },
    );
  }
}
