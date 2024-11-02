import 'package:flutter/material.dart';
import 'package:food2go_app/constants/colors.dart';
import 'package:food2go_app/controllers/product_provider.dart';
import 'package:food2go_app/models/categories/categories_model.dart';
import 'package:food2go_app/view/screens/popular_food/widget/popular_food_widget.dart';
import 'package:provider/provider.dart';
import 'package:food2go_app/models/categories/product_model.dart';

class CategoryDetailsScreen extends StatelessWidget {
  final Category category;

  const CategoryDetailsScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(100.0),
                  bottomRight: Radius.circular(100.0),
                ),
                child: Image.network(
                  category.imageLink,
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
                  child: Center(
                    child: InkWell(
                      child: const Icon(
                        Icons.arrow_back_ios,
                        color: maincolor,
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    const SizedBox(height: 44),
                    Text(
                      category.name, // Dynamic category name
                      style: const TextStyle(
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
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: category.subCategories.map((subCategory) {
                return SelectableFilterChip(label: subCategory.name);
              }).toList(),
            ),
          ),
          Expanded(
            child: Consumer<ProductProvider>(
              builder: (context, productProvider, _) {
                final products = productProvider.products;
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    mainAxisExtent: 230,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return FoodCard(
                      
                      name: product.name,
                      description: product.description,
                      image: product.image,
                      price: product.price,
                    );
                  },
                );
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
