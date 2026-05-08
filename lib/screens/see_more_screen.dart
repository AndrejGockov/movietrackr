import 'package:flutter/material.dart';
import 'package:movietrackr/widgets/shared/loading_screen.dart';

import '../app_theme.dart';
import 'package:movietrackr/models/movie_cover.dart';
import '../widgets/shared/scrollable_movie_lists/shared/movie_grid.dart';

import 'package:movietrackr/services/movies_service.dart';

class SeeMorePage extends StatefulWidget {
  const SeeMorePage({super.key});

  @override
  State<SeeMorePage> createState() => _SeeMorePageState();
}

class _SeeMorePageState extends State<SeeMorePage> {
  late String title = '';
  late String path = '';
  late int currentPage = 1;
  late int totalPages = 500;

  late List<MovieCover> movies = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    title = args['title'] ?? '';
    path = args['path'] ?? '';
    loadMovies();
  }

  void loadMovies() async {
    try {
      final List<MovieCover> receiver = await TheMovieDBService().getPage(
        currentPage,
        path,
        '',
      );
      final getTotalPages = await TheMovieDBService().getTotalPages(
        1,
        path,
        '',
      );

      setState(() {
        movies = receiver;

        if(getTotalPages <= 500)
          totalPages = getTotalPages;
      });
      // print(totalPages);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (movies.isEmpty || path == '') return LoadingScreen();

    return Scaffold(
      backgroundColor: AppTheme.darkBlue,

      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: AppTheme.xxl),

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: CircleAvatar(
                    radius: AppTheme.lg,
                    backgroundColor: AppTheme.deepBlue.withOpacity(0.6),
                    child: Icon(
                      Icons.arrow_back_outlined,
                      size: AppTheme.xl,
                      color: AppTheme.textOnMediumBlue,
                    ),
                  ),
                ),

                const SizedBox(width: AppTheme.sm),

                Text("$title Movies", style: AppTheme.h1SemiboldOnMediumBlue),
              ],
            ),

            const SizedBox(height: AppTheme.sm),

            MovieGrid(movies: movies),

            const SizedBox(height: AppTheme.lg),

            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: AppTheme.md,
                vertical: AppTheme.sm,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.md,
                vertical: AppTheme.xs,
              ),
              decoration: BoxDecoration(
                color: AppTheme.deepBlue,
                borderRadius: BorderRadius.circular(AppTheme.sm),
                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.black.withOpacity(0.2),
                //     blurRadius: 8,
                //     offset: const Offset(0, 2),
                //   ),
                // ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // First page button
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: currentPage > 1
                        ? () {
                            setState(() {
                              currentPage = 1;
                              loadMovies();
                            });
                          }
                        : null,
                    icon: Icon(
                      Icons.keyboard_double_arrow_left,
                      size: AppTheme.xl,
                      color: currentPage > 1
                          ? AppTheme.textOnMediumBlue
                          : AppTheme.textOnMediumBlue.withOpacity(0.3),
                    ),
                  ),

                  // Previous page button
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: currentPage > 1
                        ? () {
                            setState(() {
                              currentPage--;
                              loadMovies();
                            });
                          }
                        : null,
                    icon: Icon(
                      Icons.keyboard_arrow_left,
                      size: AppTheme.xl,
                      color: currentPage > 1
                          ? AppTheme.textOnMediumBlue
                          : AppTheme.textOnMediumBlue.withOpacity(0.3),
                    ),
                  ),

                  // Current page display
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: AppTheme.xs),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.md,
                      vertical: AppTheme.xs,
                    ),
                    child: Text(
                      currentPage.toString(),
                      style: AppTheme.h3SemiboldOnMediumBlue,
                    ),
                  ),

                  // Next page button
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: currentPage < totalPages
                        ? () {
                            setState(() {
                              currentPage++;
                              loadMovies();
                            });
                          }
                        : null,
                    icon: Icon(
                      Icons.keyboard_arrow_right,
                      size: AppTheme.xl,
                      color: currentPage < totalPages
                          ? AppTheme.textOnMediumBlue
                          : AppTheme.textOnMediumBlue.withOpacity(0.3),
                    ),
                  ),

                  // Last page button
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: currentPage < totalPages
                        ? () {
                            setState(() {
                              currentPage = totalPages;
                              loadMovies();
                            });
                          }
                        : null,
                    icon: Icon(
                      Icons.keyboard_double_arrow_right,
                      size: AppTheme.xl,
                      color: currentPage < totalPages
                          ? AppTheme.textOnMediumBlue
                          : AppTheme.textOnMediumBlue.withOpacity(0.3),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppTheme.lg),
          ],
        ),
      ),
    );
  }
}
