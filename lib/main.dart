import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:wtracker/firebase_options.dart';
import 'package:wtracker/src/features/authentication/screens/onboarding/onboarding_screen.dart';
import 'package:wtracker/src/features/authentication/screens/welcome/welcome.dart';
import 'package:wtracker/src/repository/authentication_repository/authentication_repository.dart';
import 'package:wtracker/src/repository/user_repository/user_repository.dart';
import 'package:wtracker/src/utils/theme/widget_themes/theme.dart';
import 'package:wtracker/src/constants/l10n/l10n.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'src/features/authentication/controllers/SignUpController.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Await Firebase initialization
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Register AuthenticationRepository with GetX
  Get.put(AuthenticationRepository());

  // Register UserRepository with GetX
  Get.put(UserRepository());

  Get.put(SignUpController());

  // Run the app
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key})
      : super(key: key); // Modified this line to correct the syntax for key

  @override
  Widget build(BuildContext context) {
    FirebaseAuth _auth = FirebaseAuth.instance;
    User? currentUser = _auth.currentUser;

    if (currentUser != null) {
      return GetMaterialApp(
          title: 'Workout Tracker',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: AppTheme.themeMode,
          supportedLocales: L10n.all,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: const Welcome());
    } else {
      return GetMaterialApp(
          title: 'Workout Tracker',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: AppTheme.themeMode,
          supportedLocales: L10n.all,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: const OnboardingScreen());
    }
  }
}
