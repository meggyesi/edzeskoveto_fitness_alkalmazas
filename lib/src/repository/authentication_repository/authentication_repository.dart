import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:wtracker/src/repository/authentication_repository/exceptions/signup_failure.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  User? get currentUser => _auth.currentUser;
  final _auth = FirebaseAuth.instance;
  late final Rx<User?> firebaseUser;

  @override
  void onReady() {
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.userChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  void _setInitialScreen(User? user) {}

  Future<bool> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return firebaseUser.value != null;
    } on FirebaseAuthException catch (e) {
      throw SignUpFailure.code(e.code);
    } catch (_) {
      throw SignUpFailure();
    }
  }

  Future<bool> loginUserWithEmailAndPassword(
      String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return firebaseUser.value != null;
    } on FirebaseAuthException catch (e) {
      throw SignUpFailure.code(e.code);
    } catch (_) {
      throw SignUpFailure();
    }
  }

  Future<void> logout() async => await _auth.signOut();

  Future<void> createUserMeasures(String userId) async {
    await FirebaseFirestore.instance
        .collection('userMeasures')
        .doc(userId)
        .set({
      'datum': DateTime.now(),
      'mellboseg': 0,
      'derekboseg': 0,
      'csipoboseg': 0,
      'felkarBal': 0,
      'felkarJobb': 0,
      'combBal': 0,
      'combJobb': 0,
      'nyak': 0,
      'vall': 0,
      'alkarJobb': 0,
      'alkarBal': 0,
      'vadliBal': 0,
      'vadliJobb': 0,
    });
  }
}
