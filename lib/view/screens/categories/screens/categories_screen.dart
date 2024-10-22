import 'package:flutter/material.dart';
import 'package:food2go_app/constants/colors.dart';
import 'package:food2go_app/controllers/categories/categories_provider.dart';
import 'package:food2go_app/view/screens/categories/widgets/category_card.dart';
import 'package:food2go_app/view/widgets/custom_appbar.dart';
import 'package:provider/provider.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: buildAppBar(context, 'Category'),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<CategoriesProvider>(
          builder: (context, categoryProvider, _) {
            if(categoryProvider.categories.isEmpty){
              return const Center(
                child: CircularProgressIndicator(color: maincolor,),
              );
            }else{
              return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            ), 
            itemCount: 6,
          itemBuilder: (context, index) {
            return const CategoryCard(
              text: 'All',
              image: 'assets/images/category1.png',
            );
          },
          );
            }
          },
          ),
      ),
    );
  }
}