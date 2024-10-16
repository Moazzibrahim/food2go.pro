import 'package:flutter/material.dart';
import 'package:food2go_app/constants/colors.dart';
import 'package:food2go_app/view/screens/onboarding_screens/second_onboarding.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen1 extends StatelessWidget {
  const OnboardingScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    final PageController pageController = PageController(initialPage: 0);
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/f1.png', // Replace with your actual image
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
                  'Your Meal In An Instant',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // Subheading text
                const Text(
                  'Order Your Favorite Meal From Your Favorite Restaurants '
                  'And Have It Delivered Wherever You Are, With The Click Of A Button',
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
                              builder: (context) =>const SecondOnboarding()));
                    },
                    child: const Text(
                      'Next',
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
