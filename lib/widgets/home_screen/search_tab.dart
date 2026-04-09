import 'package:flutter/material.dart';

import '../../app_theme.dart';
import 'package:movietrackr/models/movie_cover.dart';
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
                Pagination(),
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

          // IconButton(
          //   onPressed: () {
          //     if(controller.text.isEmpty)
          //       return;
          //
          //     setState(() {
          //       movies = [];
          //       currentPage = 1;
          //       totalPages = 1;
          //       controller.clear();
          //     });
          //   },
          //   icon: const Icon(
          //     Icons.clear_rounded,
          //     color: AppTheme.lightBlue,
          //   ),
          // ),
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

  Widget Pagination() {
    return Container(
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
                      loadMovies(controller.text);
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
                      loadMovies(controller.text);
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
                      loadMovies(controller.text);
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
                      loadMovies(controller.text);
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
    );
  }
}

// @override
// Widget build(BuildContext context) {
//   return SafeArea(
//     child: Container(
//       margin: EdgeInsets.all(AppTheme.md),
//       child: CustomScrollView(
//         slivers: [
//           // Search bar – fixed at top
//           SliverToBoxAdapter(
//             child: searchBar(),
//           ),
//
//           // Movie grid – lazy
//           SliverPadding(
//             padding: AppTheme.paddingSm,
//             sliver: SliverGrid(
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 mainAxisSpacing: 4.0,
//                 crossAxisSpacing: 4.0,
//                 childAspectRatio: 150 / 240,
//               ),
//               delegate: SliverChildBuilderDelegate(
//                     (context, index) => MovieCoverCard(movieCover: scrollable_movie_lists[index]),
//                 childCount: scrollable_movie_lists.length,
//               ),
//             ),
//           ),
//
//           if(scrollable_movie_lists.isNotEmpty) ...[
//             pagination(),
//           ],
//         ],
//       ),
//     ),
//   );
// }
