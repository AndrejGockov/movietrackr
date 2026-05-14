import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../../models/movie.dart';
import '../../services/auth_service.dart';
import '../../services/movies_service.dart';
import '../../services/review_service.dart';
import '../../widgets/profile/profile_movie_card.dart';
import '../../widgets/shared/loading_screen.dart';
import '../widgets/shared/pagination/pagination.dart';
import '../widgets/shared/reusable_header.dart';

class ProfileWatchLaterPage extends StatefulWidget {
  const ProfileWatchLaterPage({super.key});

  @override
  State<ProfileWatchLaterPage> createState() => _ProfileWatchLaterPageState();
}

class _ProfileWatchLaterPageState extends State<ProfileWatchLaterPage> {
  List<Movie> allMovies = [];
  List<Movie> pagedMovies = [];
  bool loading = true;
  int currentPage = 1;
  final int itemsPerPage = 20;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadData();
  }

  Future<void> _loadData() async {
    final uid = authService.value.user?.uid ?? '';
    try {
      final ids = await ReviewService().watchLaterStream(uid).first;
      allMovies = await Future.wait(
        ids.map((id) => TheMovieDBService().findMovieById(id)),
      );
      if (mounted) _updatePage();
    } catch (e) {
      if (mounted) setState(() => loading = false);
    }
  }

  void _updatePage() {
    setState(() {
      int start = (currentPage - 1) * itemsPerPage;
      int end = start + itemsPerPage;
      pagedMovies = allMovies.sublist(start, end > allMovies.length ? allMovies.length : end);
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBlue,
      body: loading ? const LoadingScreen() : Column(
        children: [
          const SizedBox(height: AppTheme.xxl),
          const Padding(
            padding: AppTheme.paddingMd,
            child: ReusableHeader(title: "Watch Later"),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(AppTheme.lg),
              itemCount: pagedMovies.length,
              itemBuilder: (context, i) => ProfileMovieCard(movie: pagedMovies[i]),
            ),
          ),
          PaginationControls(
            currentPage: currentPage,
            totalPages: allMovies.length,
            onPageChanged: (newPage) {
              setState(() {
                currentPage = newPage;
                _updatePage();
              });
            },
          ),
          const SizedBox(height: AppTheme.xl),
        ],
      ),
    );
  }
}