import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:food2go_app/constants/colors.dart';
import 'package:food2go_app/controllers/product_provider.dart';
import 'package:food2go_app/view/screens/popular_food/widget/popular_food_widget.dart';
import 'package:food2go_app/view/widgets/custom_appbar.dart';
import 'package:provider/provider.dart';
class ResultScreen extends StatelessWidget {
  final int? categoryId;
  final double priceStart;
  final double priceEnd;

  const ResultScreen({
    Key? key,
    this.categoryId,
    required this.priceStart,
    required this.priceEnd,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final filteredProducts = productProvider.getFilteredProducts(categoryId, priceStart, priceEnd);

    return Scaffold(
      appBar: buildAppBar(context, 'Result'),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            _buildSearchAndFilter(),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (categoryId != null) _buildCategoryTag('Category $categoryId'),
                _buildPriceRangeTag(priceStart, priceEnd),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
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
                    name: product.name,
                    description: product.description,
                    image: product.image,
                    price: product.price,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryTag(String category) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: maincolor),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Center(
        child: Text(
          category,
          style: const TextStyle(
            fontSize: 16,
            color: maincolor,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget _buildPriceRangeTag(double start, double end) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: maincolor),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Center(
        child: Text(
          'Price: \$${start.toInt()} - \$${end.toInt()}',
          style: const TextStyle(
            fontSize: 16,
            color: maincolor,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
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
            
            },
          ),
        ),
      ],
    );
  }
}

