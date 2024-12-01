// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:food2go_app/controllers/Auth/login_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:food2go_app/constants/colors.dart';
import 'package:food2go_app/view/screens/onboarding_screens/onboarding.dart';

class LogoOnboarding extends StatefulWidget {
  const LogoOnboarding({super.key});

  @override
  State<LogoOnboarding> createState() => _LogoOnboardingState();
}

class _LogoOnboardingState extends State<LogoOnboarding> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    final prefs = await SharedPreferences.getInstance();
    final isNewUser = prefs.getBool('isNewUser') ?? true; // Default to true for new users

    Future.delayed(
      const Duration(seconds: 3),
      () {
        if (isNewUser) {
          // Navigate to Onboarding if user is new
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const Onboarding(),
            ),
          );
        } else {
          // Navigate to Login if user is not new
          Provider.of<LoginProvider>(context,listen: false).checkToken(context);
        }
      },
    );
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
