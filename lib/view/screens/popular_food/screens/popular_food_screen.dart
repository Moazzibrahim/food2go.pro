import 'package:flutter/material.dart';
import 'package:food2go_app/view/screens/popular_food/widget/popular_food_widget.dart';
import 'package:food2go_app/view/widgets/custom_appbar.dart';

class PopularFoodScreen extends StatelessWidget {
  const PopularFoodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, 'Popular Food'),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
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
            return FoodCard(
              name: 'Big Burger',
                  description: 'Juicy grilled beef patty with fresh lettuce and tomatoes.',
                  image: 'assets/images/medium.png',
                  price: 50.0,
            );
          },
        ),
      ),
    );
  }
}
