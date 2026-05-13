import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../../models/movie.dart';

class ProfileMovieCard extends StatelessWidget {
  final Movie movie;
  final double? userRating;

  const ProfileMovieCard({super.key, required this.movie, this.userRating});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/movie', arguments: movie.id),
      child: Container(
        margin: const EdgeInsets.only(bottom: AppTheme.md),
        padding: const EdgeInsets.all(AppTheme.sm),
        decoration: BoxDecoration(
          color: AppTheme.deepBlue.withOpacity(0.5),
          borderRadius: BorderRadius.circular(AppTheme.sm),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppTheme.xs),
              child: Image.network(
                movie.display(movie.poster_path),
                width: 90,
                height: 130,
                fit: BoxFit.cover,
                errorBuilder: (c, e, s) =>
                    const Icon(Icons.broken_image, size: 90),
              ),
            ),
            const SizedBox(width: AppTheme.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      movie.title.length <= 40
                          ? movie.title
                          : '${movie.title.substring(0, 40).replaceAll(RegExp(r'\s+$'), '')}...',
                      style: AppTheme.h3SemiboldOnMediumBlue
                  ),

                  SizedBox(height: AppTheme.xs),

                  Text(
                    movie.genres.map((g) => g.name).join(", "),
                    style: AppTheme.h6SemiboldOnMediumBlue.copyWith(
                      color: AppTheme.lightBlue,
                    ),
                  ),

                  SizedBox(height: AppTheme.sm),

                  Text(
                    movie.overview.length <= 40
                    ? movie.overview
                    : '${movie.overview.substring(0, 40).replaceAll(RegExp(r'\s+$'), '')}...',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: AppTheme.h6SemiboldOnMediumBlue.copyWith(
                      color: Colors.white70,
                    ),
                  ),

                  if (userRating != null) ...[
                    const SizedBox(height: AppTheme.sm),
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: AppTheme.primaryYellow,
                          size: AppTheme.md,
                        ),
                        const SizedBox(width: AppTheme.xs),
                        Text(
                          "${userRating?.toStringAsFixed(1)} / 10.0",
                          style: AppTheme.h5SemiboldOnMediumBlue.copyWith(
                            color: AppTheme.primaryYellow,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
