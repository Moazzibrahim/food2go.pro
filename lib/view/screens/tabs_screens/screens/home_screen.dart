import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food2go_app/constants/colors.dart';
import 'package:food2go_app/controllers/categories/categories_provider.dart';
import 'package:food2go_app/view/screens/categories/screens/categories_screen.dart';
import 'package:food2go_app/view/screens/tabs_screens/screens/deals_screen.dart';
import 'package:food2go_app/view/screens/tabs_screens/screens/points_items_screen.dart';
import 'package:food2go_app/view/screens/tabs_screens/widgets/discount_card.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCategory = 'All';

  @override
  void initState() {
    Provider.of<CategoriesProvider>(context,listen: false).fetchCategories(context);
    super.initState();
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
            _buildCategoryList(),
            const SizedBox(height: 16),
            _buildDealsSection(),
            const SizedBox(height: 16),
            _buildPopularFoodHeader(),
            const SizedBox(height: 16),
            _buildFoodItemsList(),
            const SizedBox(height: 16),
            _buildDiscountHeader(),
            const SizedBox(height: 16,),
            _buildDiscountList(),
            const SizedBox(height: 100,),
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
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (ctx)=> const PointsItemsScreen())
              );
            },
            child: Container(
              width: 70,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('10',style: TextStyle(color: maincolor,fontSize: 22,fontWeight: FontWeight.w400),),
                  const SizedBox(width: 5,),
                  SvgPicture.asset('assets/images/coin.svg')
                ],
              ),
            ),
          ),
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
                  icon: Icon(Icons.search,color: Colors.grey,),
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
            onPressed: () {},
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryList() {
    return LayoutBuilder(
    builder: (context, constraints) {
      double itemWidth = (constraints.maxWidth - 35) / 4;
      return SizedBox(
        height: 230,
        child: Center(
          child: Wrap(
            spacing: 10,
            runSpacing: 15, // Vertical spacing between rows
            children: [
              _buildCategoryItem('All', 'assets/images/bb.png', itemWidth),
              _buildCategoryItem('Burger', 'assets/images/bb.png', itemWidth),
              _buildCategoryItem('Pastries', 'assets/images/bb.png', itemWidth),
              _buildCategoryItem('Pasta', 'assets/images/bb.png', itemWidth),
              _buildCategoryItem('candies', 'assets/images/bb.png', itemWidth),
              _buildCategoryItem('Burger', 'assets/images/bb.png', itemWidth),
              _buildCategoryItem('Pastries', 'assets/images/bb.png', itemWidth),
              _buildCategoryItem('Pasta', 'assets/images/bb.png', itemWidth),
            ],
          ),
        ),
      );
    },
  );
}

  Widget _buildDealsSection() {
    return GestureDetector(
      onTap: (){
        Navigator.of(context).push(
          MaterialPageRoute(builder: (ctx)=> const DealsScreen())
        );
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
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Popular Food',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'See All',
          style: TextStyle(
            color: maincolor,
          ),
        ),
      ],
    );
  }

  Widget _buildDiscountHeader() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Discount',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'See All',
          style: TextStyle(
            color: maincolor,
          ),
        ),
      ],
    );
  }

  Widget _buildFoodItemsList() {
    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: foodItems.length,
        itemBuilder: (context, index) {
          return FoodCard(foodItem: foodItems[index]);
        },
      ),
    );
  }

  Widget _buildDiscountList() {
    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        itemBuilder: (context, index) {
          return const DiscountCard();
        },
        ),
    );
  }

  Widget _buildCategoryItem(String title, String image,double width) {
    return GestureDetector(
      onTap: () {
        if(title == 'All'){
          Navigator.of(context).push(
          MaterialPageRoute(builder: (ctx)=> const CategoriesScreen())
        );
        }else{}
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
              child: Image.asset(image),
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
}

class FoodCard extends StatefulWidget {
  final FoodItem foodItem;

  const FoodCard({super.key, required this.foodItem});

  @override
  State<FoodCard> createState() => _FoodCardState();
}

class _FoodCardState extends State<FoodCard> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 180,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.asset(
                  widget.foodItem.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 4,
                right: -2,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isFavorite = !isFavorite;
                    });
                  },
                  child: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? maincolor : Colors.grey,
                    size: 28,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.foodItem.name,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  widget.foodItem.description,
                  style: const TextStyle(
                    fontSize: 7,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${widget.foodItem.price} EGP',
                      style: const TextStyle(
                        fontSize: 14,
                        color: maincolor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: (){},
                      child: Container(
                        height: 24,
                        width: 24,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: maincolor
                        ),
                        child: const Center(
                          child: Icon(Icons.add, color: Colors.white,size: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FoodItem {
  final String name;
  final String description;
  final String imageUrl;
  final double price;

  FoodItem({
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
  });
}

// Sample food items list
final List<FoodItem> foodItems = [
  FoodItem(
    name: 'Big Burger',
    description: 'Juicy grilled beef patty with fresh lettuce and tomatoes.',
    imageUrl: 'assets/images/medium.png',
    price: 50.0,
  ),
  FoodItem(
    name: 'Double Burger',
    description: 'Two beef patties with cheese, lettuce, and tomatoes.',
    imageUrl: 'assets/images/medium.png',
    price: 70.0,
  ),
  FoodItem(
    name: 'Cheese Burger',
    description: 'Classic cheeseburger with melted cheese and pickles.',
    imageUrl: 'assets/images/medium.png',
    price: 60.0,
  ),
];
