import 'package:flutter/material.dart';
import 'package:wtracker/src/constants/sizes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wtracker/src/features/authentication/screens/login/login_form_widget.dart';
import '../../../../constants/image_strings.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                    width: 140.0,
                    height: 70.0,
                  ),
                ),
              ),
              const SizedBox(
                height: defaultSize,
              ),
              Text(
                AppLocalizations.of(context)!.loginTitle,
                style: GoogleFonts.montserrat(
                    textStyle: Theme.of(context).textTheme.bodyLarge,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                AppLocalizations.of(context)!.loginText,
                style: GoogleFonts.montserrat(
                    textStyle: Theme.of(context).textTheme.bodyLarge,
                    fontSize: 20,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: defaultSize - 20,
              ),
              const LoginForm(),
            ],
          ),
        )),
      ),
    );
  }
}
