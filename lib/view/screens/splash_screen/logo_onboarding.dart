// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:food2go_app/constants/colors.dart';
import 'package:food2go_app/view/screens/onboarding_screens/first_onboarding.dart';

class LogoOnboarding extends StatefulWidget {
  const LogoOnboarding({super.key});

  @override
  State<LogoOnboarding> createState() => _LogoOnboardingState();
}

class _LogoOnboardingState extends State<LogoOnboarding> {
  void navigateToOnboarding() {
    // Delaying the navigation by 3 seconds
    Future.delayed(
      const Duration(seconds: 3),
      () {
        // Navigate to the FirstOnboarding screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const OnboardingScreen1(),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    navigateToOnboarding(); // Start the navigation after 3 seconds
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: maincolor,
      body: Center(
        child: Image.asset('assets/images/logo.png'),
      ),
    );
  }
}
