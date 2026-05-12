import 'package:firebase_database/firebase_database.dart';
import '../models/review.dart';

class ReviewService {
  late final DatabaseReference _db = FirebaseDatabase.instance.ref();

  ReviewService._privateConstructor();

  static final ReviewService instance =
  ReviewService._privateConstructor();

  factory ReviewService() {
    return instance;
  }

  Future<void> postReview(int movieId, Review review) async {
    final updates = <String, dynamic>{
      // Add to that movie's reviews
      'reviews/$movieId/${review.userId}': review.toJson(),

      // Add movie to users profile
      'users/${review.userId}/reviewed_movies/$movieId': {
        'rating': review.rating,
        'timestamp': review.timestamp.millisecondsSinceEpoch,
      },
    };

    await _db.update(updates);
  }

  Future<DataSnapshot> getReviews(int movieId, int limit) async {
    return await _db.child("reviews")
        .child(movieId.toString())
        .orderByChild('timestamp')
        .limitToLast(limit)
        .get();
  }

}