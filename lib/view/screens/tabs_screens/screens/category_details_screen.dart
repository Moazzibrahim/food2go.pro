import 'package:flutter/material.dart';
import 'package:food2go_app/constants/colors.dart';
import 'package:food2go_app/controllers/product_provider.dart';
import 'package:food2go_app/models/categories/categories_model.dart';
import 'package:food2go_app/view/screens/popular_food/widget/popular_food_widget.dart';
import 'package:provider/provider.dart';

class CategoryDetailsScreen extends StatefulWidget {
  final Category category;

  const CategoryDetailsScreen({super.key, required this.category});

  @override
  _CategoryDetailsScreenState createState() => _CategoryDetailsScreenState();
}

class _CategoryDetailsScreenState extends State<CategoryDetailsScreen> {
  String? selectedSubCategoryId;

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
                  widget.category.imageLink,
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
                      widget.category.name,
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
              children: widget.category.subCategories.map((subCategory) {
                return SelectableFilterChip(
                  label: subCategory.name,
                  isSelected:
                      selectedSubCategoryId == subCategory.id.toString(),
                  onSelected: (isSelected) {
                    setState(() {
                      selectedSubCategoryId =
                          isSelected ? subCategory.id.toString() : null;
                    });
                  },
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: Consumer<ProductProvider>(
              builder: (context, productProvider, _) {
                final products =
                    productProvider.getProductsByCategory(widget.category.id);
                final filteredProducts = selectedSubCategoryId == null
                    ? products
                    : products
                        .where((product) =>
                            product.subCategoryId == selectedSubCategoryId)
                        .toList();
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    mainAxisExtent: 230,
                  ),
                  itemCount: filteredProducts.length,
                  itemBuilder: (context, index) {
                    final product = filteredProducts[index];
                    return FoodCard(
                      product: product,
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

class SelectableFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final ValueChanged<bool> onSelected;

  const SelectableFilterChip({
    Key? key,
    required this.label,
    required this.isSelected,
    required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ChoiceChip(
        showCheckmark: false,
        label: Text(
          label,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w400,
            color: isSelected ? Colors.white : maincolor, // Text color
          ),
        ),
        selected: isSelected,
        onSelected: onSelected,
        backgroundColor: Colors.white, // White background when unselected
        selectedColor: maincolor, // Red background when selected
        shape: const StadiumBorder(
          side: BorderSide(color: maincolor), // Red border
        ),
      ),
    );
  }
}
