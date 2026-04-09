import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../app_theme.dart';
import '../models/movie.dart';
import '../models/gallery.dart';
import '../widgets/movie_screen/movie_details_section.dart';
import '../widgets/movie_screen/movie_info_section.dart';
import '../widgets/movie_screen/movie_gallery_section.dart';
import '../widgets/movie_screen/movie_genres_section.dart';
import '../widgets/movie_screen/movie_tagline.dart';
import '../widgets/movie_screen/shared/section_separator.dart';
import '../widgets/shared/snackbars.dart';
import '../widgets/shared/image_viewer.dart';
import '../widgets/shared/loading_screen.dart';
import '../services/movies_service.dart';

class MoviePage extends StatefulWidget {
  const MoviePage({super.key});

  @override
  State<MoviePage> createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  late int movieId = -1;
  bool loadingMovie = true;
  late Movie movie;
  late Gallery gallery;

  @override
  void initState() {
    super.initState();
  }

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    movieId = ModalRoute.of(context)!.settings.arguments as int;
    loadMovie();
  }

  Future<void> loadMovie() async {
    try {
      final getMovie = await TheMovieDBService().findMovieById(movieId);
      final getGallery = await TheMovieDBService().findGalleryById(movieId);

      setState(() {
        movie = getMovie;
        gallery = getGallery;
        loadingMovie = false;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> openIMDBPage() async{
    if (movie.imdb_id.isEmpty) {
      Snackbars.showErrorSnackbar(context,
          'The IMDb page for this movie isn\'t available');
      return;
    }

    final Uri uri = Uri.parse('https://www.imdb.com/title/${movie.imdb_id}');

    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      Snackbars.showErrorSnackbar(context,
          'Could not open the website');
    }
  }

  Future<void> openMovieHomePage() async{
    if (movie.homepage.isEmpty) {
      Snackbars.showErrorSnackbar(context, 'This website isn\'t available');
      return;
    }

    final Uri uri = Uri.parse('${movie.homepage}');

    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      Snackbars.showErrorSnackbar(context,
          'Could not open the website');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loadingMovie) return LoadingScreen();

    return Scaffold(
      backgroundColor: AppTheme.darkBlue,
      body: CustomScrollView(
        slivers: [
          // Top part
          SliverAppBar(
            // Increased to make room for bottom widget (620 + ~80)
            expandedHeight: 620,
            pinned: false,
            stretch: true,
            floating: false,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [StretchMode.zoomBackground],
              background: Stack(
                children: [
                  // Background Image
                  SizedBox(
                    width: double.infinity,
                    height: 520,
                    child: Image.network(
                      movie.backdrop_path != ''
                          ? movie.display(movie.backdrop_path)
                          : movie.display(movie.poster_path),
                      fit: BoxFit.cover,
                      loadingBuilder:
                          (
                            BuildContext context,
                            Widget child,
                            ImageChunkEvent? loadingProgress,
                          ) {
                            if (loadingProgress == null) return child;
                            return LoadingScreen();
                          },
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.broken_image);
                      },
                    ),
                  ),

                  // Gradient Overlay
                  Container(
                    height: 520,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.darkBlue.withOpacity(0.6),
                          AppTheme.darkBlue,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),

                  // Poster, Title & Details
                  Positioned(
                    left: 0,
                    right: 0,
                    // Increased to leave space for bottom widget
                    bottom: 30,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: Container(
                            width: 240,
                            height: 328,
                            padding: const EdgeInsets.all(AppTheme.xs),
                            decoration: BoxDecoration(
                              color: AppTheme.deepBlue.withOpacity(0.6),
                            ),

                            child: GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ImageViewer(
                                    url: movie.display(movie.poster_path),
                                  ),
                                ),
                              ),
                              child: Image.network(
                                movie.display(movie.poster_path),
                                height: 320,
                                width: 240,
                                fit: BoxFit.cover,
                                loadingBuilder:
                                    (
                                      BuildContext context,
                                      Widget child,
                                      ImageChunkEvent? loadingProgress,
                                    ) {
                                      if (loadingProgress == null) return child;
                                      return LoadingScreen();
                                    },
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.broken_image);
                                },
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: AppTheme.md),

                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppTheme.md,
                          ),
                          child: Text(
                            movie.title,
                            style: AppTheme.h1SemiboldOnMediumBlue,
                            softWrap: true,
                            overflow: TextOverflow.visible,
                            textAlign: TextAlign.center,
                          ),
                        ),

                        if (movie.tagline != '')
                          Tagline(tagline: movie.tagline),

                        const SizedBox(height: AppTheme.lg),

                        // Release Year, Runtime & Genre
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppTheme.md,
                          ),
                          child: InfoSection(
                            year: movie.release_date.year != 0 ? movie.release_date.year.toString() : '-',
                            runtime: movie.runtime.toString(),
                            genre: movie.genres.isNotEmpty ? movie.genres[0].name : '-',
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Back Button
                  Positioned(
                    top: 40,
                    left: 16,
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: CircleAvatar(
                        radius: AppTheme.md,
                        backgroundColor: AppTheme.deepBlue.withOpacity(0.8),
                        child: Icon(
                          Icons.arrow_back_outlined,
                          size: AppTheme.lg,
                          color: AppTheme.textOnMediumBlue,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Lower Part
          SliverList(
            delegate: SliverChildListDelegate([
              Container(
                width: double.infinity,
                color: AppTheme.darkBlue,
                child: Column(
                  children: [
                    const SizedBox(height: AppTheme.xxl),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.lg,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // OVERVIEW
                          Text(
                            "Overview",
                            style: AppTheme.h2SemiboldOnMediumBlue,
                          ),

                          SectionSeparator(),

                          Text(
                            movie.overview,
                            style: AppTheme.h5SemiboldOnMediumBlue,
                          ),

                          SizedBox(height: AppTheme.xl),

                          // DETAILS
                          MovieDetails(
                              budget: movie.budget,
                              revenue: movie.revenue,
                              status: movie.status,
                              release_date: movie.release_date,
                              production_companies: movie.production_companies,
                              production_countries: movie.production_countries
                          ),

                          // Imdb and website link
                          Row(
                            children: [
                              IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),

                                  onPressed: openMovieHomePage,

                                  icon: CircleAvatar(
                                    radius: AppTheme.lg,
                                    backgroundColor: AppTheme.deepBlue.withOpacity(0.6),
                                    child: FaIcon(
                                      FontAwesomeIcons.link,
                                      size: AppTheme.lg,
                                      color: AppTheme.textOnMediumBlue,
                                    ),
                                  )
                              ),

                              const SizedBox(width: AppTheme.sm),

                              IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),

                                  onPressed: openIMDBPage,

                                  icon: CircleAvatar(
                                    radius: AppTheme.lg,
                                    backgroundColor: AppTheme.deepBlue.withOpacity(0.6),
                                    child: FaIcon(
                                      FontAwesomeIcons.imdb,
                                      size: AppTheme.lg,
                                      color: AppTheme.textOnMediumBlue,
                                    ),
                                  )
                              ),
                            ],
                          ),

                          SizedBox(height: AppTheme.md),

                          // GENRES
                          if (movie.genres.isNotEmpty)
                            MovieGenres(genres: movie.genres),

                          // GALLERY
                          if (gallery.backdrops.isNotEmpty)
                            MovieGallery(gallery: gallery),

                          // REVIEWS
                          Text(
                            "Reviews",
                            style: AppTheme.h3SemiboldOnMediumBlue,
                          ),

                          SectionSeparator(),
                        ],
                      ),
                    ),

                    const SizedBox(height: AppTheme.xxl),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}