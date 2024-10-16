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
    Future.delayed(
      const Duration(seconds: 3),
      () => const FirstOnboarding(),
    );
  }

  @override
  void initState() {
    super.initState();
    navigateToOnboarding();
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
