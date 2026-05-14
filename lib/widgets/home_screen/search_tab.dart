import 'package:flutter/material.dart';

import '../../app_theme.dart';
import 'package:movietrackr/models/movie_cover.dart';
import '../shared/pagination/pagination.dart';
import '../shared/scrollable_movie_lists/shared/movie_grid.dart';

import 'package:movietrackr/services/movies_service.dart';

class SearchTab extends StatefulWidget {
  const SearchTab({super.key});

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  int currentPage = 1;
  int totalPages = 1;
  List<MovieCover> movies = [];
  List<MovieCover> pagedMovies = [];
  bool loading = true;
  final int itemsPerPage = 20;

  TextEditingController controller = TextEditingController();

  String formatSearch(String query) {
    return query.replaceAll(RegExp(r'\s+'), "-");
  }

  void searchMovies(String query) async {
    if (!RegExp(r'[a-zA-Z0-9]').hasMatch(query) || query.trim().isEmpty) return;

    query = formatSearch(query);

    try {
      final search = await TheMovieDBService().searchMovies(1, query);
      final getTotalPages = await TheMovieDBService().getTotalPages(
        1,
        "search/movie",
        query,
      );

      setState(() {
        movies = search;
        currentPage = 1;
        totalPages = getTotalPages;
      });
    } catch (e) {}
  }

  void loadMovies(String query) async {
    try {
      final List<MovieCover> receiver = await TheMovieDBService().getPage(
        currentPage,
        'search/movie',
        query,
      );

      setState(() {
        movies = receiver;
      });
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(
          top: AppTheme.md,
          left: AppTheme.sm,
          right: AppTheme.sm,
          bottom: AppTheme.md,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Search bar
              SearchBar(),

              if (movies.isNotEmpty) ...[
                MovieGrid(movies: movies),
                PaginationControls(
                  currentPage: currentPage,
                  totalPages: totalPages,
                  onPageChanged: (newPage) {
                    setState(() {
                      currentPage = newPage;
                      loadMovies(controller.text);
                    });
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget SearchBar() {
    return Container(
      padding: const EdgeInsets.only(left: AppTheme.md, right: AppTheme.sm),
      height: 41,
      decoration: BoxDecoration(
        color: AppTheme.deepBlue,
        borderRadius: BorderRadius.circular(AppTheme.sm),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(width: AppTheme.sm),

          Expanded(
            child: TextField(
              controller: controller,
              onSubmitted: (String value) async {
                searchMovies(value);
              },
              style: AppTheme.h5SemiboldOnMediumBlue,
              cursorColor: AppTheme.lightBlue,
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: 'Search for Movies. . .',
                hintStyle: AppTheme.h5SemiboldOnMediumBlue,
              ),
            ),
          ),

          const SizedBox(width: AppTheme.md),

          ListenableBuilder(
            listenable: controller,
            builder: (context, child) {
              return Visibility(
                visible: controller.text.isNotEmpty,
                child: IconButton(
                  onPressed: () {
                    if (controller.text.isEmpty) return;

                    setState(() {
                      movies = [];
                      currentPage = 1;
                      totalPages = 1;
                      controller.clear();
                    });
                  },
                  icon: const Icon(
                    Icons.clear_rounded,
                    color: AppTheme.lightBlue,
                  ),
                ),
              );
            },
          ),
          IconButton(
            onPressed: () async {
              searchMovies(controller.text);
            },
            icon: const Icon(Icons.search_outlined, color: AppTheme.lightBlue),
          ),
        ],
      ),
    );
  }
}
