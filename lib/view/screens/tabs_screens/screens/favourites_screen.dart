// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:food2go_app/controllers/product_provider.dart';
import 'package:food2go_app/view/screens/popular_food/widget/popular_food_widget.dart';
import 'package:provider/provider.dart';

class FavouritesScreen extends StatefulWidget {
  const FavouritesScreen({super.key});

  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 16),
              const Center(
                child: Text(
                  "Favourites",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Expanded(
                child: Consumer<ProductProvider>(
                  builder: (context, productProvider, _) {
                    if (productProvider.favorites.isEmpty) {
                      return const Center(
                        child: Text('No Favorites yet!'),
                      );
                    } else {
                      // List to hold widgets
                      List<Widget> contentWidgets = [];

                      if (productProvider.favorites.isNotEmpty) {
                        contentWidgets.add(
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GridView.builder(
                              shrinkWrap: true, 
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                mainAxisExtent: 210,
                              ),
                              itemCount: productProvider.favorites.length,
                              itemBuilder: (BuildContext context, int index) {
                                final product =
                                    productProvider.favorites[index];
                                return FoodCard(
                                  description: product.description,
                                  image: product.image,
                                  name: product.name,
                                  price: product.price,
                                  productId: product.id,
                                  isFav: product.isFav,
                                  product: product,
                                );
                              },
                            ),
                          ),
                        );
                      }

                      return ListView(
                        children: contentWidgets,
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
