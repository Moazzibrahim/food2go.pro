import 'package:flutter/material.dart';
import 'package:food2go_app/view/screens/tabs_screens/widgets/deals_card.dart';
import 'package:food2go_app/view/widgets/custom_appbar.dart';

class DealsScreen extends StatelessWidget {
  const DealsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<DealsFakeData> data = [
      DealsFakeData(
          image: 'assets/images/dealsandwich.png',
          description: '2 single beef burgers with cheese ,potatoes',
          price: 200),
      DealsFakeData(
          image: 'assets/images/dealsandwich.png',
          description: '2 single beef burgers with cheese ,potatoes',
          price: 200),
      DealsFakeData(
          image: 'assets/images/dealsandwich.png',
          description: '2 single beef burgers with cheese ,potatoes',
          price: 200),
      DealsFakeData(
          image: 'assets/images/dealsandwich.png',
          description: '2 single beef burgers with cheese ,potatoes',
          price: 200),
    ];
    return Scaffold(
      appBar: buildAppBar(context, 'Deals'),
      body: SingleChildScrollView(
        child: Column(
          children: List.generate(
            4,
            (index) {
              return DealsCard(
                  description: data[index].description,
                  price: data[index].price,
                  image: data[index].image);
            },
          ),
        ),
      ),
    );
  }
}

class DealsFakeData {
  final String image;
  final String description;
  final double price;

  DealsFakeData(
      {required this.image, required this.description, required this.price});
}
