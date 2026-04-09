import 'package:flutter/material.dart';
import 'package:movietrackr/models/movie_cover.dart';

import '../../app_theme.dart';
import '../../services/movies_service.dart';
import '../shared/scrollable_movie_lists/movie_horizontal_section.dart';
import '../shared/scrollable_movie_lists/movie_vertical_section.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  List<MovieCover> mostPopularMovies = [];
  List<MovieCover> upcomingMovies = [];
  List<MovieCover> trendingMovies = [];

  int pageIndex = 0;

  @override
  void initState() {
    super.initState();
    loadMovies();
  }

  Future<void> loadMovies() async {
    try {
      final List<MovieCover> loadPopularMovies = await TheMovieDBService()
          .getMoviesByType("movie/popular");
      final List<MovieCover> loadUpcomingMovies = await TheMovieDBService()
          .getMoviesByType("movie/upcoming");
      final List<MovieCover> loadTrendingMovies = await TheMovieDBService()
          .getMoviesByType("trending/movie/week");

      setState(() {
        mostPopularMovies = loadPopularMovies.take(6).toList();
        upcomingMovies = loadUpcomingMovies.take(6).toList();
        trendingMovies = loadTrendingMovies.take(6).toList();
      });
    } catch (e) {
      print(e);
    }
  }

  void handleTabChange(int index) {
    setState(() {
      pageIndex = index;
    });
    print(index);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Add if statement to show recommended movies to users
            SizedBox(height: AppTheme.md),
            MovieHorizontalSection(
              rowTitle: "Popular",
              movies: mostPopularMovies,
              path: "movie/popular",
            ),
            SizedBox(height: AppTheme.md),
            MovieHorizontalSection(
              rowTitle: "Upcoming",
              movies: upcomingMovies,
              path: "movie/upcoming",
            ),
            SizedBox(height: AppTheme.md),
            MovieVerticalSection(
              gridTitle: "Trending",
              movies: trendingMovies,
              path: "trending/movie/week",
            ),
            SizedBox(height: AppTheme.md),

            // TESTING CARD
            // MovieCoverCard(movieCover: mostPopularMovies[0]),
          ],
        ),
      ),
    );
  }
}
