import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food2go_app/constants/colors.dart';
import 'package:food2go_app/view/tabs_screens/favourites_screen.dart';
import 'package:food2go_app/view/tabs_screens/cart_details_screen.dart';
import 'package:food2go_app/view/tabs_screens/home_screen.dart';
import 'package:food2go_app/view/tabs_screens/profile_screen.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  var _currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              children: const [
                HomeScreen(),
                FavouritesScreen(),
                CartDetailsScreen(),
                ProfileScreen(),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 20, // This sets the floating effect
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  height: 50,
                  color: maincolor, 
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _bottomNavBarIcon(
                        iconOn: 'assets/images/home_on.svg',
                        iconOff: 'assets/images/home_off.svg',
                        index: 0,
                      ),
                      _bottomNavBarIcon(
                        iconOn: 'assets/images/fav_on.svg',
                        iconOff: 'assets/images/fav_off.svg',
                        index: 1,
                      ),
                      _bottomNavBarIcon(
                        iconOn: 'assets/images/cart_on.svg',
                        iconOff: 'assets/images/cart_pff.svg',
                        index: 2,
                      ),
                      _bottomNavBarIcon(
                        iconOn: 'assets/images/person_on.svg',
                        iconOff: 'assets/images/person_off.svg',
                        index: 3,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomNavBarIcon(
      {String? iconOn, required String iconOff, required int index}) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
          _pageController.jumpToPage(index);
        });
      },
      child: SvgPicture.asset(isSelected ? iconOn ?? iconOff : iconOff),
    );
  }
}
