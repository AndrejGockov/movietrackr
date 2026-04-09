import 'package:flutter/material.dart';

import 'package:movietrackr/app_theme.dart';
import 'package:movietrackr/models/movie_cover.dart';

class MovieCoverCard extends StatelessWidget {
  final MovieCover movieCover;

  const MovieCoverCard({super.key, required this.movieCover});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () async {
          // final movie = await TheMovieDB_Service().findMovieById(movieCover.id);
          Navigator.pushNamed(context, "/movie", arguments: movieCover.id);//movieCover.id);
        },
        child: Card(
          color: AppTheme.mediumBlue.withOpacity(0.8),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(AppTheme.sm),
                      topRight: Radius.circular(AppTheme.sm),
                    ),
                    child: Image.network(
                      movieCover.display(),
                      height: 200,
                      width: 150,
                      // width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return SizedBox(
                          height: 200,
                          width: 150,
                          child: const Center(
                            child: Icon(
                                Icons.broken_image,
                                color: AppTheme.textOnMediumBlue),
                          ),
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return SizedBox(
                          height: 200,
                          width: 150,
                          child: const Center(
                            child: CircularProgressIndicator(
                                color: AppTheme.textOnMediumBlue
                            ),
                          ),
                        );
                      },
                    )
                ),

                Padding(
                  padding: AppTheme.paddingSm,
                  child: Text(
                    movieCover.title.length <= 10
                        ? movieCover.title
                        : '${movieCover.title.substring(0, 10).replaceAll(RegExp(r'\s+$'), '')}...',

                    style: AppTheme.h4SemiboldOnMediumBlue,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ]
          ),
        )
    );
  }
}