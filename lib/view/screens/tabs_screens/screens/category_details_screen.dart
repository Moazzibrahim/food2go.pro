import 'package:flutter/material.dart';
import 'package:food2go_app/constants/colors.dart';
import 'package:food2go_app/view/screens/popular_food/widget/popular_food_widget.dart';


class CategoryDetailsScreen extends StatelessWidget {
  const CategoryDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header section with image and category title
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(100.0),
                  bottomRight: Radius.circular(100.0),
                ),
                child: Image.asset(
                  'assets/images/categoty_image.png', // Replace with your image asset
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 40,
                left: 16,
                child: Container(
        height: 32,
        width: 32,
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Center(child: Icon(Icons.arrow_back_ios,color: maincolor,)),
      ),
              ),
              const Align(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    SizedBox(height: 44,),
                    Text(
                      'Burger', // Category name
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                SelectableFilterChip(label: 'Cheese'),
                SelectableFilterChip(label: 'Mushroom'),
                SelectableFilterChip(label: 'Meat'),
              ],
            ),
          ),
          Expanded(
              child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              mainAxisExtent: 230
                        ),
                        itemCount: foodItems.length,
                        itemBuilder: (context, index) {
              return FoodCard(foodItem: foodItems[index]);
                        },
                      ),
            ),
        ],
      ),
    );
  }
}

class SelectableFilterChip extends StatefulWidget {
  const SelectableFilterChip({super.key, required this.label});
  final String label;

  @override
  State<SelectableFilterChip> createState() => _SelectableFilterChipState();
}

class _SelectableFilterChipState extends State<SelectableFilterChip> {
  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ChoiceChip(
        showCheckmark: false,
        label: Text(
          widget.label,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w400,
            color: _isSelected ? Colors.white : maincolor // Text color
          ),
        ),
        selected: _isSelected,
        onSelected: (selected) {
          setState(() {
            _isSelected = selected;
          });
        },
        backgroundColor: Colors.white, // White background when unselected
        selectedColor: maincolor, // Red background when selected
        shape: const StadiumBorder(
          side: BorderSide(color: maincolor), // Red border
        ),
      ),
    );
  }
}
