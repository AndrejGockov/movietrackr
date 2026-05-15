import 'db_context.dart';

class UserService {

  Future<void> deleteUserAccount(String uid) async {
    await deleteUserById(uid);
    await deleteReviewsByUser(uid);
  }

  Future<void> deleteUserById(String uid) async {
    final updates = <String, dynamic>{
      'users/$uid': null
    };

    await dbContext.update(updates);
  }

  Future<void> deleteReviewsByUser(String uid) async {
    final reviewsRef = dbContext.child('reviews');
    final snapshot = await reviewsRef.get();

    if (!snapshot.exists)
      return;

    Map<dynamic, dynamic> allMovies = snapshot.value as Map;
    Map<String, Object?> updates = {};

    allMovies.forEach((movieId, movieReviews) {
      if (movieReviews is Map && movieReviews.containsKey(uid)) {
        updates['reviews/$movieId/$uid'] = null;
      }
    });

    if (updates.isEmpty)
      return;

    await dbContext.update(updates);
  }

  Stream<String> getBioStream(String uid) {
    return dbContext.child('users/$uid/bio').onValue.map((event) {
      return event.snapshot.value?.toString() ?? "";
    });
  }

  Future<void> updateBio(String uid, String bio) async {
    await dbContext.child('users/$uid/bio').set(bio);
  }
}