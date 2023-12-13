import 'package:flutter/material.dart';
import 'package:wtracker/src/constants/sizes.dart';
import 'package:wtracker/src/features/authentication/models/model_onboarding.dart';

class OnboardingPageWidget extends StatelessWidget {
  const OnboardingPageWidget({
    Key? key,
    required this.model,
  }) : super(key: key);

  final OnboardingModel model;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultSize),
      color: model.bgColor,
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Image(
          image: AssetImage(model.image),
          height: model.height * 0.4,
        ),
        Column(
          children: [
            Text(
              model.title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              model.subTitle,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        Text(
          model.counterText,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(
          height: 50.0,
        )
      ]),
    );
  }
}
