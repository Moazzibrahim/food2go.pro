import 'package:flutter/material.dart';
import 'package:food2go_app/constants/colors.dart';
import 'package:food2go_app/view/screens/cart/product_details_screen.dart';

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
      height: 240,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0, right: 8.0),
            child: Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    isFavorite = !isFavorite;
                  });
                },
                child: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? maincolor : Colors.grey,
                  size: 23,
                ),
              ),
            ),
          ),
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.asset(
                  widget.foodItem.imageUrl,
                  fit: BoxFit.cover,
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
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ProductDetailsScreen()));
                      },
                      child: Container(
                        height: 24,
                        width: 24,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: maincolor),
                        child: const Center(
                          child: Icon(Icons.add, color: Colors.white, size: 16),
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
