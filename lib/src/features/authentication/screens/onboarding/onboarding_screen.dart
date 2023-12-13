import 'package:flutter/material.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:wtracker/src/constants/colors.dart';
import 'package:wtracker/src/constants/image_strings.dart';
import 'package:wtracker/src/constants/text_strings.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wtracker/src/features/authentication/models/model_onboarding.dart';
import 'package:wtracker/src/features/authentication/screens/onboarding/onboarding_page_widget.dart';
import 'package:wtracker/src/features/authentication/screens/login/login_screen.dart'; // Import the LoginScreen

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final pages = [
      OnboardingPageWidget(
          model: OnboardingModel(
              image: onboardingImage1,
              title: AppLocalizations.of(context)!.onboardingTitle1,
              subTitle: AppLocalizations.of(context)!.onboardingText1,
              counterText: onboardingCounter1,
              height: size.height,
              bgColor: onboardingPageColor1)),
      OnboardingPageWidget(
          model: OnboardingModel(
              image: onboardingImage2,
              title: AppLocalizations.of(context)!.onboardingTitle2,
              subTitle: AppLocalizations.of(context)!.onboardingText2,
              counterText: onboardingCounter2,
              height: size.height,
              bgColor: onboardingPageColor2)),
      OnboardingPageWidget(
          model: OnboardingModel(
              image: onboardingImage3,
              title: AppLocalizations.of(context)!.onboardingTitle3,
              subTitle: AppLocalizations.of(context)!.onboardingText3,
              counterText: onboardingCounter3,
              height: size.height,
              bgColor: onboardingPageColor3))
    ];

    return Scaffold(
      body: Stack(
        children: [
          LiquidSwipe(
            pages: pages,
            slideIconWidget: const Icon(Icons.arrow_back_ios),
            enableSideReveal: true,
          ),
          Positioned(
            right: 20,
            bottom: 20,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              child: Text(AppLocalizations.of(context)!.login),
            ),
          ),
        ],
      ),
    );
  }
}
