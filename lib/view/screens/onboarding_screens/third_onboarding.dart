import 'package:flutter/material.dart';
import 'package:food2go_app/constants/colors.dart';
import 'package:food2go_app/view/screens/Auth/login_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ThirdOnboarding extends StatelessWidget {
  const ThirdOnboarding({super.key});

  @override
  Widget build(BuildContext context) {
    final PageController pageController = PageController(initialPage: 2);
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/third.png', // Replace with your actual image
              fit: BoxFit.cover,
            ),
          ),

          // Content Overlaid on Image
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top section with back arrow and logo
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Food2go',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 299,
                ),

                // Main heading text
                const Text(
                  'A Unique Dining Experience',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // Subheading text
                const Text(
                  'Enjoy a unique dining experience with  '
                  'exclusive offers and Great discounts',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 20),

                // Indicator for onboarding screens
                Center(
                  child: SmoothPageIndicator(
                    controller: pageController,
                    count: 3, // Number of pages
                    effect: const WormEffect(
                      dotWidth: 16.0,
                      dotHeight: 6.0,
                      activeDotColor: maincolor,
                      dotColor: Colors.white,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Skip button
                Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()));
                    },
                    child: const Text(
                      'Start',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
