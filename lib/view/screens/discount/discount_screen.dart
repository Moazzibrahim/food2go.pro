import 'package:flutter/material.dart';
import 'package:food2go_app/view/widgets/custom_appbar.dart';
import '../tabs_screens/widgets/discount_card.dart';

class DiscountScreen extends StatelessWidget {
  const DiscountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, 'Discount'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.9,
          ),
          itemCount: 10,
          itemBuilder: (context, index) {
            return const DiscountCard();
          },
        ),
      ),
    );
  }
}
