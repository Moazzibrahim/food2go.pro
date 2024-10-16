import 'package:flutter/material.dart';
import 'package:food2go_app/constants/colors.dart';

class LogoOnboarding extends StatelessWidget {
  const LogoOnboarding({super.key});

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
