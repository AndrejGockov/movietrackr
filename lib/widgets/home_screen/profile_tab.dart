import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../../models/movie.dart';
import '../../services/auth_service.dart';
import '../../services/movies_service.dart';
import '../../services/review_service.dart';
import '../profile/genre_stats.dart';
import '../profile/profile_header.dart';
import '../profile/profile_movie_card.dart';
import '../profile/profile_movies_section.dart';
import '../profile/review_stats.dart';
import '../shared/loading_screen.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  Map<Movie, double> reviewedMovies = {};
  List<Movie> watchLaterMovies = [];
  String bio = "";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _setupListeners();
  }

  void _setupListeners() {
    final uid = authService.value.user?.uid ?? '';
    if (uid.isEmpty) return;

    // Listen to Watch Later updates
    ReviewService().watchLaterStream(uid).listen((ids) async {
      final hydrated = await Future.wait(
          ids.map((id) => TheMovieDBService().findMovieById(id))
      );
      if (mounted) setState(() => watchLaterMovies = hydrated);
    });

    // Listen to Review updates
    ReviewService().reviewsStream(uid).listen((rawReviews) async {
      final hydrated = await Future.wait(
          rawReviews.keys.map((id) => TheMovieDBService().findMovieById(id))
      );
      if (mounted) {
        setState(() {
          reviewedMovies = {for (var m in hydrated) m: rawReviews[m.id] ?? 0.0};
          isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const LoadingScreen();

    return Scaffold(
      backgroundColor: AppTheme.darkBlue,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(AppTheme.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: AppTheme.xxl),

                  ValueListenableBuilder(
                    valueListenable: authService,
                    builder: (context, service, child) {
                      return ProfileHeader(
                        name: service.user?.displayName ?? "User",
                        email: service.user?.email ?? "email",
                        memberSince: service.user?.metadata.creationTime,
                        bio: bio,
                      );
                    },
                  ),

                  SizedBox(height: AppTheme.xl),

                  ReviewStats(ratings: reviewedMovies.values.toList()),

                  SizedBox(height: AppTheme.md),

                  GenreStats(movies: reviewedMovies.keys.toList()),

                  SizedBox(height: AppTheme.xxl),

                  ProfileMoviesSection(
                    title: "Ratings",
                    path: "reviews",
                    items: reviewedMovies.entries.toList(),
                    builder: (entry) => ProfileMovieCard(movie: entry.key, userRating: entry.value),
                  ),

                  SizedBox(height: AppTheme.xl),

                  ProfileMoviesSection(
                    title: "Watch Later",
                    path: "watch_later",
                    items: watchLaterMovies,
                    builder: (movie) => ProfileMovieCard(movie: movie),
                  ),

                  SizedBox(height: AppTheme.sm),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
