import 'package:chat_genius/widgets/onboarding/header.dart';
import 'package:chat_genius/widgets/onboarding/navigate_button.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Header(),
            const SizedBox(
              height: 32,
            ),
            Image.asset('assets/onboarding.png'),
            const SizedBox(
              height: 32,
            ),
            const NavigateButton()
          ],
        ),
      ),
    );
  }
}
