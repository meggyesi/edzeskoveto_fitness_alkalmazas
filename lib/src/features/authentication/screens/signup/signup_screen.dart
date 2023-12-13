import 'package:flutter/material.dart';
import 'package:wtracker/src/repository/authentication_repository/exceptions/signup_failure.dart';
import 'package:wtracker/src/constants/sizes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wtracker/src/features/authentication/screens/login/login_screen.dart';
import 'package:wtracker/src/features/authentication/controllers/SignUpController.dart';
import '../../../../constants/image_strings.dart';
import '../../../../repository/authentication_repository/authentication_repository.dart';
import '../../../../repository/user_repository/user_repository.dart';
import '../../models/user_model.dart';
import '../personal_datas/personal_datas_screen.dart'; // Add the correct file path.
import 'package:get/get.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignUpController());

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(defaultSize),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    child: Image(
                      image: AssetImage(barbellLogo),
                      width: 130.0,
                      height: 65.0,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  AppLocalizations.of(context)!.register,
                  style: GoogleFonts.montserrat(
                      textStyle: Theme.of(context).textTheme.bodyLarge,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  AppLocalizations.of(context)!.createAccount,
                  style: GoogleFonts.montserrat(
                      textStyle: Theme.of(context).textTheme.bodyLarge,
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: defaultSize - 20,
                ),
                //Form
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: controller.nickname,
                          decoration: InputDecoration(
                            label: Text(AppLocalizations.of(context)!.nickname),
                            prefixIcon:
                                const Icon(Icons.person_outline_rounded),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: controller.email,
                          decoration: const InputDecoration(
                            label: Text("E-Mail"),
                            prefixIcon: Icon(Icons.email_outlined),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: controller.password,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.fingerprint_sharp),
                            label: Text(
                                AppLocalizations.of(context)!.passwordText),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: controller.password2,
                          obscureText: _obscureConfirmPassword,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.fingerprint_sharp),
                            label: Text(AppLocalizations.of(context)!
                                .repeatPasswordText),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _obscureConfirmPassword =
                                      !_obscureConfirmPassword;
                                });
                              },
                              icon: Icon(
                                _obscureConfirmPassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: (() async {
                              if (_formKey.currentState!.validate()) {
                                try {
                                  bool wasSuccessful = await SignUpController
                                      .instance
                                      .userRegister(
                                    controller.email.text.trim(),
                                    controller.password.text.trim(),
                                  );
                                  if (wasSuccessful) {
                                    String? userId = AuthenticationRepository
                                        .instance.currentUser?.uid;

                                    if (userId == null) {
                                      throw SignUpFailure("User ID not found");
                                    }

                                    UserModel newUser = UserModel(
                                      email: controller.email.text.trim(),
                                      userId: userId,
                                      nickname: controller.nickname.text.trim(),
                                    );
                                    await UserRepository.instance
                                        .createUser(newUser);

                                    await UserRepository.instance
                                        .createUserMeasures(userId);

                                    Get.offAll(() =>
                                        const PersonalDataScreen()); // Use GetX to navigate
                                  }
                                } catch (e) {
                                  if (e is SignUpFailure) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(e.message)),
                                    );
                                  }
                                }
                              }
                            }),
                            child: Text(AppLocalizations.of(context)!.register),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()),
                        );
                      },
                      child: Text.rich(
                        TextSpan(
                          text: AppLocalizations.of(context)!.haveAnAccount,
                          style: Theme.of(context).textTheme.bodyLarge,
                          children: [
                            TextSpan(
                              text: AppLocalizations.of(context)!.login,
                              style: const TextStyle(color: Colors.blue),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
