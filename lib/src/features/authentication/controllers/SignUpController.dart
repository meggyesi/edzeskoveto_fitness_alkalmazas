import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wtracker/src/repository/authentication_repository/authentication_repository.dart';
import 'package:wtracker/src/repository/authentication_repository/exceptions/signup_failure.dart';

class SignUpController extends GetxController {
  static SignUpController get instance => Get.find();

  final nickname = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final password2 = TextEditingController();

  Future<bool> userRegister(String email, String password) async {
    try {
      return await AuthenticationRepository.instance
          .createUserWithEmailAndPassword(email, password);
    } catch (e) {
      if (e is SignUpFailure) {
        rethrow;
      } else {
        throw SignUpFailure();
      }
    }
  }

  Future<bool> userLogin(String email, String password) async {
    return await AuthenticationRepository.instance
        .loginUserWithEmailAndPassword(email, password);
  }
}
