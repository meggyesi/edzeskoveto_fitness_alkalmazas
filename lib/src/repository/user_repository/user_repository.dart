import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../features/authentication/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  User? get currentUser => FirebaseAuth.instance.currentUser;
  final _db = FirebaseFirestore.instance;

  Future<void> createUser(UserModel user) async {
    try {
      await _db.collection("Users").doc(user.userId).set(user.toJson());
      await _db.collection('userMeasures').doc(user.userId).set({
        'datum': 0,
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

      Get.snackbar(
        "Success",
        "Your account has been created.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.black87,
      );
    } catch (error) {
      Get.snackbar(
        "Error",
        "Something went wrong. Please try again.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.1),
        colorText: Colors.black87,
      );
    }
  }

  Future<void> updateUser(UserModel user) async {
    try {
      await _db.collection("Users").doc(user.userId).update({
        'fullName': user.fullName,
        'gender': user.gender,
        'height': user.height,
        'weight': user.weight,
        'birthDate': user.birthDate?.toIso8601String(),
        'loggedInDays': user.loggedInDays
            .map((date) => date.toIso8601String())
            .toList(), // Update the logged-in days in Firestore
      });
      Get.snackbar(
        "Success",
        "Your personal data has been updated.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(1.0),
        colorText: Colors.black87,
      );
    } catch (error) {
      Get.snackbar(
        "Error",
        "Something went wrong. Please try again.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(1.0),
        colorText: Colors.black87,
      );
    }
  }

  Future<UserModel> getUser(String userId) async {
    // Fetch the user document from Firestore
    DocumentSnapshot userDocSnapshot =
        await _db.collection("Users").doc(userId).get();

    if (userDocSnapshot.exists) {
      // If the document exists, parse the data into a UserModel instance
      return UserModel.fromJson(userDocSnapshot.data() as Map<String, dynamic>);
    } else {
      // If the document doesn't exist, return a default UserModel
      return UserModel(
        email: '',
        userId: userId,
      );
    }
  }

  Future<void> updateLoggedInDays(
      String userId, List<DateTime> loggedInDays) async {
    try {
      List<String> isoDates =
          loggedInDays.map((date) => date.toIso8601String()).toList();

      await _db.collection("Users").doc(userId).update({
        'loggedInDays': isoDates,
      });
    } catch (error) {}
  }

  Future<void> createUserMeasures(String userId) async {
    try {
      await _db.collection('userMeasures').doc(userId).set({
        'datum': 0,
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
    } catch (error) {}
  }
}
