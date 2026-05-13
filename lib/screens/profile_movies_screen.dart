import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../../models/movie.dart';
import '../../services/auth_service.dart';
import '../../services/movies_service.dart';
import '../../services/review_service.dart';
import '../../widgets/profile/profile_movie_card.dart';
import '../../widgets/shared/loading_screen.dart';
import '../widgets/shared/reusable_header.dart';

class ProfileMoviesScreen extends StatefulWidget {
  const ProfileMoviesScreen({super.key});

  @override
  State<ProfileMoviesScreen> createState() => _ProfileMoviesScreenState();
}

class _ProfileMoviesScreenState extends State<ProfileMoviesScreen> {
  List<Movie> allMovies = [];
  Map<int, double> ratings = {};
  List<Movie> pagedMovies = [];

  int currentPage = 1;
  int itemsPerPage = 20;
  int totalPages = 1;
  bool loading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadData();
  }

  Future<void> _loadData() async {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    final String path = args['path'];
    final uid = authService.value.user?.uid ?? '';

    try {
      if (path == "ratings") {
        // 1. Await the first event of the stream to get the actual Map
        final ratingsMap = await ReviewService().reviewsStream(uid).first;
        ratings = Map<int, double>.from(ratingsMap);

        // 2. Map the keys to a list of futures and wait for them
        allMovies = await Future.wait(
          ratings.keys.map((id) => TheMovieDBService().findMovieById(id)),
        );
      } else {
        // 3. Await the first event of the IDs stream
        final dynamic rawIds = await ReviewService()
            .watchLaterStream(uid)
            .first;
        final List<int> ids = List<int>.from(rawIds);

        // 4. Map and wait
        allMovies = await Future.wait(
          ids.map((id) => TheMovieDBService().findMovieById(id)),
        );
      }

      totalPages = (allMovies.length / itemsPerPage).ceil();
      _updatePage();
    } catch (e) {
      debugPrint("Error loading profile movies: $e");
      setState(() => loading = false);
    }
  }

  void _updatePage() {
    setState(() {
      int start = (currentPage - 1) * itemsPerPage;
      int end = start + itemsPerPage;
      pagedMovies = allMovies.sublist(
        start,
        end > allMovies.length ? allMovies.length : end,
      );
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;

    return Scaffold(
      backgroundColor: AppTheme.darkBlue,
      body: loading
          ? const LoadingScreen()
          : Column(
              children: [
                const SizedBox(height: AppTheme.xxl),

                ReusableHeader(title: args['title']),

                const SizedBox(height: AppTheme.sm),

                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(AppTheme.lg),
                    itemCount: pagedMovies.length,
                    itemBuilder: (context, i) => ProfileMovieCard(
                      movie: pagedMovies[i],
                      userRating: ratings[pagedMovies[i].id],
                    ),
                  ),
                ),
                _buildPaginationControls(),
                const SizedBox(height: AppTheme.xl),
              ],
            ),
    );
  }

  Widget _buildPaginationControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _pageButton(Icons.keyboard_double_arrow_left, () => 1, currentPage > 1),
        _pageButton(
          Icons.keyboard_arrow_left,
          () => currentPage - 1,
          currentPage > 1,
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: AppTheme.md),
          child: Text(
            currentPage.toString(),
            style: AppTheme.h3SemiboldOnMediumBlue,
          ),
        ),
        _pageButton(
          Icons.keyboard_arrow_right,
          () => currentPage + 1,
          currentPage < totalPages,
        ),
        _pageButton(
          Icons.keyboard_double_arrow_right,
          () => totalPages,
          currentPage < totalPages,
        ),
      ],
    );
  }

  Widget _pageButton(IconData icon, int Function() targetPage, bool enabled) {
    return IconButton(
      onPressed: enabled
          ? () {
              setState(() {
                currentPage = targetPage();
                _updatePage();
              });
            }
          : null,
      icon: Icon(
        icon,
        size: AppTheme.xl,
        color: enabled ? AppTheme.textOnMediumBlue : Colors.white24,
      ),
    );
  }
}
