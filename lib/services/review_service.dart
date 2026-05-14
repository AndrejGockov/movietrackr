import 'package:firebase_database/firebase_database.dart';

import '../models/review.dart';
import 'db_context.dart';

class ReviewService {

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

    await dbContext.update(updates);
  }

  Future<DataSnapshot> getReviews(int movieId, int limit) async {
    return await dbContext.child("reviews")
        .child(movieId.toString())
        .orderByChild('timestamp')
        .limitToLast(limit)
        .get();
  }

  Future<void> deleteReview(int movieId, String userId) async {
    final updates = <String, dynamic>{
      'reviews/$movieId/$userId': null,
      'users/$userId/reviewed_movies/$movieId': null,
    };
    await dbContext.update(updates);
  }

  Future<void> toggleWatchLater(String userId, int movieId) async {
    final ref = dbContext.child('users/$userId/watch_later/$movieId');
    final snapshot = await ref.get();

    if (snapshot.exists) {
      await ref.remove();
      return;
    }

    await ref.set(true);
  }

  Future<bool> isInWatchLater(String userId, int movieId) async {
    final snapshot = await dbContext.child('users/$userId/watch_later/$movieId').get();
    return snapshot.exists;
  }


  Stream<Map<int, double>> reviewsStream(String uid) {
    return dbContext.child('users/$uid/reviewed_movies').onValue.map((event) {
      final data = event.snapshot.value as Map? ?? {};
      return data.map((key, value) => MapEntry(
          int.parse(key.toString()),
          double.parse(value['rating'].toString())
      ));
    });
  }

  Stream<List<int>> watchLaterStream(String uid) {
    return dbContext.child('users/$uid/watch_later').onValue.map((event) {
      final data = event.snapshot.value as Map? ?? {};
      return data.keys.map((key) => int.parse(key.toString())).toList();
    });
  }

  // Updates username in reviews
  Future<void> updateUsernameInReviews(String uid, String newName) async {
    final DatabaseReference reviewsRef = FirebaseDatabase.instance.ref('reviews');
    final snapshot = await reviewsRef.get();

    if (snapshot.exists) {
      Map<dynamic, dynamic> allReviews = snapshot.value as Map;

      Map<String, Object?> updates = {};

      allReviews.forEach((movieId, userReviews) {
        if (userReviews is Map && userReviews.containsKey(uid)) {
          updates['$movieId/$uid/username'] = newName;
        }
      });

      if (updates.isNotEmpty) {
        await reviewsRef.update(updates);
      }
    }
  }
}