import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../../models/movie.dart';

class GenreStats extends StatefulWidget {
  final List<Movie> movies;

  const GenreStats({super.key, required this.movies});

  @override
  State<GenreStats> createState() => _GenreStatsState();
}

class _GenreStatsState extends State<GenreStats> {
  bool isExpanded = false;
  final int showNMovies = 5;

  List<MapEntry<String, int>> _getSortedStats() {
    final counts = <String, int>{};
    widget.movies.forEach(
      (m) =>
          m.genres.forEach((g) => counts[g.name] = (counts[g.name] ?? 0) + 1),
    );

    return counts.entries.toList()..sort(
      (a, b) => (b.value != a.value)
          ? b.value.compareTo(a.value)
          : a.key.toLowerCase().compareTo(b.key.toLowerCase()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final allStats = _getSortedStats();
    if (allStats.isEmpty) return const SizedBox.shrink();

    final displayedStats = isExpanded
        ? allStats
        : allStats.take(showNMovies).toList();
    final hasMore = allStats.length > showNMovies;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Genres", style: AppTheme.h3SemiboldOnMediumBlue),
        const SizedBox(height: AppTheme.sm),

        Wrap(
          spacing: AppTheme.sm,
          runSpacing: AppTheme.sm,
          children: [
            ...displayedStats.map(
              (entry) => Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.md,
                  vertical: AppTheme.xs,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.deepBlue.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(AppTheme.xs),
                ),
                child: Text(
                  "${entry.key} x${entry.value}",
                  style: AppTheme.h5SemiboldOnMediumBlue,
                ),
              ),
            ),

            if (hasMore)
              GestureDetector(
                onTap: () => setState(() => isExpanded = !isExpanded),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.md,
                    vertical: AppTheme.xs,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.deepBlue.withOpacity(0.2),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isExpanded ? Icons.remove : Icons.add,
                        size: AppTheme.md,
                        color: AppTheme.textOnMediumBlue,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        isExpanded ? "Show less" : "Show more",
                        style: AppTheme.h5SemiboldOnMediumBlue,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
