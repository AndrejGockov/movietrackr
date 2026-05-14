import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:movietrackr/services/auth_service.dart';
import 'package:movietrackr/widgets/movie_screen/movie_review_section.dart';
import 'package:url_launcher/url_launcher.dart';
import '../app_theme.dart';
import '../models/review.dart';
import '../models/movie.dart';
import '../models/gallery.dart';
import '../widgets/movie_screen/delete_review_dialog.dart';
import '../widgets/movie_screen/movie_details_section.dart';
import '../widgets/movie_screen/movie_info_section.dart';
import '../widgets/movie_screen/movie_gallery_section.dart';
import '../widgets/movie_screen/movie_genres_section.dart';
import '../widgets/movie_screen/movie_tagline.dart';
import '../widgets/shared/section_separator.dart';
import '../widgets/shared/snackbars.dart';
import '../widgets/shared/image_viewer.dart';
import '../widgets/shared/loading_screen.dart';
import '../services/movies_service.dart';
import '../services/review_service.dart';

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
  bool isInWatchLater = false;

  final TextEditingController commentController = TextEditingController();
  double currentRating = 5.0;
  bool isSubmitting = false;

  List<Review> loadedReviews = [];
  int currentLimit = 10;
  bool hasMore = true;
  bool isLoadingMore = false;

  final DateFormat dateFormatter = DateFormat('dd.MM.yyyy');

  @override
  void initState() {
    super.initState();
  }

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    movieId = ModalRoute.of(context)!.settings.arguments as int;
    loadMovie();
    fetchReviews();
    checkWatchLaterStatus();
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

  void loadMore() {
    setState(() {
      currentLimit += 10;
    });
    fetchReviews();
  }

  Future<void> checkWatchLaterStatus() async {
    final String uid = authService.value.user?.uid ?? '';
    if (uid.isEmpty) return;

    final status = await ReviewService().isInWatchLater(uid, movieId);
    setState(() => isInWatchLater = status);
  }

  Future<void> toggleWatchLater() async {
    final String uid = authService.value.user?.uid ?? '';
    if (uid.isEmpty) {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      return;
    }

    await ReviewService().toggleWatchLater(uid, movieId);
    setState(() => isInWatchLater = !isInWatchLater);
  }

  Future<void> openIMDBPage() async {
    if (movie.imdb_id.isEmpty) {
      Snackbars.showErrorSnackbar(
        context,
        'The IMDb page for this movie isn\'t available',
      );
      return;
    }

    final Uri uri = Uri.parse('https://www.imdb.com/title/${movie.imdb_id}');

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      Snackbars.showErrorSnackbar(context, 'Could not open the website');
    }
  }

  Future<void> openMovieHomePage() async {
    if (movie.homepage.isEmpty) {
      Snackbars.showErrorSnackbar(context, 'This website isn\'t available');
      return;
    }

    final Uri uri = Uri.parse('${movie.homepage}');

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      Snackbars.showErrorSnackbar(context, 'Could not open the website');
    }
  }

  Future<void> submitReview() async {
    if (commentController.text.trim().isEmpty) return;

    setState(() => isSubmitting = true);

    try {
      final String currentUid = authService.value.user?.uid ?? '';
      final String currentUsername = authService.value.user?.displayName ?? '';

      final newReview = Review(
        userId: currentUid,
        username: currentUsername,
        content: commentController.text.trim(),
        rating: double.parse(currentRating.toStringAsFixed(1)),
        // Save as decimal
        timestamp: DateTime.now(),
      );

      await ReviewService().postReview(movieId, newReview);

      commentController.clear();
      setState(() {
        currentRating = 5.0;
        isSubmitting = false;
      });

      fetchReviews();
    } catch (e) {
      setState(() => isSubmitting = false);
      Snackbars.showErrorSnackbar(context, "Failed to post review");
    }
  }

  Future<void> fetchReviews() async {
    if (isLoadingMore) return;
    setState(() => isLoadingMore = true);

    final snapshot = await ReviewService().getReviews(movieId, currentLimit);

    if (snapshot.exists) {
      final Map<dynamic, dynamic> data = snapshot.value as Map;
      final List<Review> fetched = data.values
          .map((item) => Review.fromJson(Map<String, dynamic>.from(item)))
          .toList()
        ..sort((a, b) => b.timestamp.compareTo(a.timestamp));

      setState(() {
        loadedReviews = fetched;
        hasMore = fetched.length == currentLimit;
        isLoadingMore = false;
      });
    } else {
      // HIGHLIGHT: Ensure list is cleared if no reviews exist on the server
      setState(() {
        loadedReviews = [];
        isLoadingMore = false;
      });
    }
  }

  void editReview(Review review) {
    setState(() {
      commentController.text = review.content;
      currentRating = review.rating;
    });
  }

  Future<void> deleteReview(Review review) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => const DeleteReviewDialog(),
    );

    if (confirm == true) {
      // 1. Save a backup of the current list in case the API call fails
      final backupList = List<Review>.from(loadedReviews);

      try {
        // 2. HIGHLIGHT: Update UI immediately (Optimistic Update)
        setState(() {
          loadedReviews.removeWhere((item) =>
          item.userId == review.userId && item.timestamp == review.timestamp
          );
        });

        // 3. Perform the actual background deletion
        await ReviewService().deleteReview(movieId, review.userId);
        Snackbars.showSuccessSnackbar(context, "Review deleted");

      } catch (e) {
        // 4. HIGHLIGHT: Rollback logic - if the database fails, the review reappears
        setState(() {
          loadedReviews = backupList;
        });
        Snackbars.showErrorSnackbar(context, "Failed to delete review");
      }
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
                            year: movie.release_date.year != 0
                                ? movie.release_date.year.toString()
                                : '-',
                            runtime: movie.runtime.toString(),
                            genre: movie.genres.isNotEmpty
                                ? movie.genres[0].name
                                : '-',
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Back Button
                  Positioned(
                    top: 40,
                    left: AppTheme.md,
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

                  Positioned(
                    top: 40,
                    right: AppTheme.md,
                    child: IconButton(
                      onPressed: toggleWatchLater,
                      icon: CircleAvatar(
                        radius: AppTheme.md,
                        backgroundColor: AppTheme.deepBlue.withOpacity(0.8),
                        child: Icon(
                          isInWatchLater ? Icons.bookmark : Icons.bookmark_border,
                          size: AppTheme.lg,
                          color: isInWatchLater ? AppTheme.lightBlue : AppTheme.textOnMediumBlue,
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
                            production_countries: movie.production_countries,
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
                                  backgroundColor: AppTheme.deepBlue
                                      .withOpacity(0.6),
                                  child: FaIcon(
                                    FontAwesomeIcons.link,
                                    size: AppTheme.lg,
                                    color: AppTheme.textOnMediumBlue,
                                  ),
                                ),
                              ),

                              const SizedBox(width: AppTheme.sm),

                              IconButton(
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),

                                onPressed: openIMDBPage,

                                icon: CircleAvatar(
                                  radius: AppTheme.lg,
                                  backgroundColor: AppTheme.deepBlue
                                      .withOpacity(0.6),
                                  child: FaIcon(
                                    FontAwesomeIcons.imdb,
                                    size: AppTheme.lg,
                                    color: AppTheme.textOnMediumBlue,
                                  ),
                                ),
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

                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    TextField(
                                      controller: commentController,
                                      maxLines: null,
                                      keyboardType: TextInputType.multiline,
                                      style: AppTheme.h5SemiboldOnMediumBlue,
                                      cursorColor: AppTheme.lightBlue,
                                      decoration: InputDecoration(
                                        hintText: "Write a review. . .",
                                        hintStyle: AppTheme
                                            .h5SemiboldOnMediumBlue
                                            .copyWith(color: Colors.white38),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.white24,
                                          ),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: AppTheme.lightBlue,
                                          ),
                                        ),
                                      ),
                                    ),

                                    SizedBox(height: AppTheme.sm),

                                    Row(
                                      children: [
                                        // Decimal Rating Selector
                                        Text(
                                          "${currentRating.toStringAsFixed(1)} / 10.0",
                                          style:
                                              AppTheme.h6SemiboldOnMediumBlue,
                                        ),
                                        Expanded(
                                          child: Slider(
                                            value: currentRating,
                                            min: 0,
                                            max: 10,
                                            divisions: 100,
                                            // Allows for 0.1 increments
                                            activeColor: AppTheme.lightBlue,
                                            onChanged: (val) => setState(
                                              () => currentRating = val,
                                            ),
                                          ),
                                        ),

                                        SizedBox(
                                          width: 100,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: AppTheme.deepBlue,
                                              foregroundColor: AppTheme.lightBlue,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(AppTheme.sm),
                                              ),
                                              padding: const EdgeInsets.symmetric(
                                                vertical: AppTheme.sm,
                                              ),
                                            ),
                                            onPressed: isSubmitting ? null : submitReview,
                                            child: isSubmitting
                                                ? const SizedBox(
                                              height: AppTheme.md,
                                              width: AppTheme.md,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: AppTheme.lightBlue,
                                              ),
                                            )
                                                : Text(
                                              "Post",
                                              style: AppTheme.h5SemiboldOnMediumBlue,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: AppTheme.xl),

                          MovieReviews(
                            reviews: loadedReviews,
                            isLoadingMore: isLoadingMore,
                            hasMore: hasMore,
                            onLoadMore: loadMore,
                            dateFormatter: dateFormatter,
                            onDelete: deleteReview,
                            onEdit: editReview,
                          ),
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
