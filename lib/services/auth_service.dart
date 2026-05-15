import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:movietrackr/services/review_service.dart';
import 'package:movietrackr/services/user_service.dart';

ValueNotifier<AuthService> authService = ValueNotifier(AuthService());

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  User? get user => firebaseAuth.currentUser;

  // if the user is logged in
  Stream<User?> get authStateChange => firebaseAuth.authStateChanges();

  Future<UserCredential> login({
    required String email,
    required String password,
  }) async {
    return await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  Future<UserCredential> register({
    required String username,
    required String email,
    required String password,
  }) async {
    UserCredential userCredential = await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    if(userCredential.user != null){
      await userCredential.user!.updateDisplayName(username);
      await userCredential.user!.reload();
      UserService().updateBio(userCredential.user!.uid ,"");
    }

    return userCredential;
  }

  Future<void> updateUsername({required String username}) async {
    await user!.updateDisplayName(username);
    await user!.reload();

    // Update the users name in all their reviews
    await ReviewService().updateUsernameInReviews(user!.uid, username);

    authService.value = this;
    authService.notifyListeners();
  }

  Future<void> resetPassword({required String email}) async {
    await firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> deleteAccount({
    required String email,
    required String password,
  }) async {
    AuthCredential credential = EmailAuthProvider.credential(
      email: email,
      password: password,
    );

    await user!.reauthenticateWithCredential(credential);
    // Delete all the users data (reviews, watch later)
    await UserService().deleteUserAccount(user!.uid);
    await user!.delete();
    await firebaseAuth.signOut();
  }

  Future<void> resetPasswordFromCurrentUser({
    required String email,
    required String currentPassword,
    required String newPassword,
  }) async {
    AuthCredential credential = EmailAuthProvider.credential(
      email: email,
      password: currentPassword,
    );

    await user!.reauthenticateWithCredential(credential);
    await user!.updatePassword(newPassword);
  }

  bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}