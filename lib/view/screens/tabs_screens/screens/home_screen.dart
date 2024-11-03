import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food2go_app/view/screens/categories/screens/categories_screen.dart';
import 'package:food2go_app/view/screens/discount/discount_screen.dart';
import 'package:food2go_app/view/screens/popular_food/screens/popular_food_screen.dart';
import 'package:food2go_app/view/screens/popular_food/widget/popular_food_widget.dart';
import 'package:food2go_app/view/screens/tabs_screens/screens/category_details_screen.dart';
import 'package:food2go_app/view/screens/tabs_screens/screens/deals_screen.dart';
import 'package:food2go_app/view/screens/tabs_screens/screens/filter_screen.dart';
import 'package:food2go_app/view/screens/tabs_screens/widgets/discount_card.dart';
import 'package:provider/provider.dart';
import 'package:food2go_app/constants/colors.dart';
import 'package:food2go_app/controllers/categories/categories_provider.dart';
import 'package:food2go_app/controllers/product_provider.dart';
import 'package:food2go_app/controllers/profile/get_profile_provider.dart';
import 'package:food2go_app/view/screens/tabs_screens/screens/points_items_screen.dart';

import '../../../../models/categories/categories_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCategory = 'All';
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    Provider.of<CategoriesProvider>(context, listen: false)
        .fetchCategories(context);
    Provider.of<ProductProvider>(context, listen: false).fetchProducts(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<GetProfileProvider>(context, listen: false)
          .fetchUserProfile(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            _buildSearchAndFilter(),
            const SizedBox(height: 16),
            _buildImageCarousel(),
            _buildCategoryList(),
            _buildDealsSection(),
            const SizedBox(height: 16),
            _buildPopularFoodHeader(),
            const SizedBox(height: 16),
            _buildFoodItemsList(),
            const SizedBox(height: 16),
            _buildDiscountHeader(),
            const SizedBox(height: 16),
            _buildDiscountList(),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Choose\nYour Favorite Food',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        Consumer<GetProfileProvider>(
          builder: (context, profileProvider, child) {
            final points = profileProvider.userProfile?.points ?? 0;
            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (ctx) => const PointsItemsScreen(),
                ));
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      points.toString(),
                      style: const TextStyle(
                        color: maincolor,
                        fontSize: 22,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(width: 5),
                    SvgPicture.asset('assets/images/coin.svg'),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSearchAndFilter() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Center(
              child: TextField(
                decoration: InputDecoration(
                  icon: Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                  hintText: 'Search',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        CircleAvatar(
          backgroundColor: maincolor,
          child: IconButton(
            icon: SvgPicture.asset('assets/images/filter.svg'),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const FilterScreen()));
            },
          ),
        ),
      ],
    );
  }

  Widget _buildImageCarousel() {
    return Column(
      children: [
        CarouselSlider(
          items: [
            _buildCarouselImage(
                'assets/images/Chicken Barbecue on a Stick.jpeg'),
            _buildCarouselImage(
                'assets/images/Penne alla Vodka _ Recipe _ Kitchen Stories.jpeg'),
            _buildCarouselImage('assets/images/The Perfect Basic Burger.jpeg'),
          ],
          options: CarouselOptions(
            height: 160.0,
            enlargeCenterPage: true,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 2),
            viewportFraction: 1,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) => _buildIndicator(index)),
        ),
      ],
    );
  }

  Widget _buildCarouselImage(String assetPath) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8.0,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: Image.asset(
          assetPath,
          fit: BoxFit.cover,
          width: double.infinity,
        ),
      ),
    );
  }

  Widget _buildIndicator(int index) {
    return Container(
      width: 8.0,
      height: 8.0,
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 3.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _currentIndex == index ? maincolor : Colors.grey,
      ),
    );
  }

  Widget _buildCategoryList() {
    return Consumer<CategoriesProvider>(
      builder: (context, categoriesProvider, child) {
        final allCategory = Category(
          name: 'All',
          imageLink: 'assets/images/Onboarding3.png',
          id: 0,
          status: 1,
          activity: 1,
          priority: 0,
          subCategories: [],
        );

        final categories = [allCategory, ...categoriesProvider.categories];

        return LayoutBuilder(
          builder: (context, constraints) {
            double itemWidth = (constraints.maxWidth - 35) / 4;
            return SizedBox(
              height: 150,
              child: Center(
                child: Wrap(
                  spacing: 10,
                  runSpacing: 15,
                  children: categories.map((category) {
                    return _buildCategoryItem(
                        category.name, category.imageLink, itemWidth);
                  }).toList(),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCategoryItem(String title, String image, double width) {
    return GestureDetector(
      onTap: () {
        if (title == 'All') {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (ctx) => const CategoriesScreen()),
          );
        } else {
          // Find the selected category from the provider or your list
          final selectedCategory =
              Provider.of<CategoriesProvider>(context, listen: false)
                  .categories
                  .firstWhere((category) => category.name == title);

          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) =>
                  CategoryDetailsScreen(category: selectedCategory),
            ),
          );
        }
      },
      child: Container(
        width: width,
        height: 110,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: maincolor,
              child: ClipOval(
                child: title == 'All'
                    ? Image.asset(
                        'assets/images/Onboarding3.png',
                        fit: BoxFit.cover,
                        width: 60,
                        height: 60,
                      )
                    : Image.network(
                        image,
                        fit: BoxFit.cover,
                        width: 60,
                        height: 60,
                      ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDealsSection() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (ctx) => const DealsScreen()));
      },
      child: Stack(
        children: [
          SvgPicture.asset(
            'assets/images/deals.svg',
            width: 345,
          ),
          Positioned(
            right: -14,
            child: Image.asset('assets/images/bigburger.png'),
          ),
        ],
      ),
    );
  }

  Widget _buildPopularFoodHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Popular Food',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const PopularFoodScreen()),
            );
          },
          child: const Text(
            'See All',
            style: TextStyle(
              color: maincolor,
            ),
          ),
        )
      ],
    );
  }

  Widget _buildDiscountHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Discount',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DiscountScreen()),
            );
          },
          child: const Text(
            'See All',
            style: TextStyle(
              color: maincolor,
            ),
          ),
        )
      ],
    );
  }

  Widget _buildFoodItemsList() {
    return SizedBox(
      height: 200,
      child: Consumer<ProductProvider>(builder: (context, productProvider, _) {
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: productProvider.popularProducts.length,
          itemBuilder: (context, index) {
            final product = productProvider.popularProducts[index];
            return FoodCard(
              name: product.name,
              image: 'assets/images/medium.png',
              description: product.description,
              price: product.price,
              productId: product.id,
              isFav: product.isFav,
              product: product,
            );
          },
        );
      }),
    );
  }

  Widget _buildDiscountList() {
    return SizedBox(
      height: 180,
      child: Consumer<ProductProvider>(
        builder: (context, productProvider, _) {
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: productProvider.discounts.length,
            itemBuilder: (context, index) {
              final product = productProvider.discounts[index];
              return DiscountCard(
                name: product.name,
                image: 'assets/images/stake.png',
                description: product.description,
                price: product.price,
              );
            },
          );
        },
      ),
    );
  }
}
