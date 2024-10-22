import 'package:flutter/material.dart';
import 'package:food2go_app/constants/colors.dart';

class DiscountCard extends StatelessWidget {
  const DiscountCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120, // Set the width as requested
      height: 180, // Set the height as requested
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24), // Rounded corners
      ),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                color: maincolor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: const Text(
                '20%',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          // Favorite Button
          const Positioned(
            top: 5,
            right: 5,
            child: Icon(
              Icons.favorite_border,
              color: maincolor
            ),
          ),
          // Product Image
          Align(
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                const SizedBox(height: 30,),
                Image.asset(
                  'assets/images/stake.png',
                ),
              ],
            ),
          ),
          // Product Info
          const Positioned(
            bottom: 40,
            left: 10,
            right: 10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Croissant',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 11,
                  ),
                ),
                Text(
                  'Sesame, Butter',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 7,
                  ),
                ),
              ],
            ),
          ),
          // Price Info
          const Positioned(
            bottom: 10,
            left: 10,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '150 Egp',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                SizedBox(width: 5),
                Text(
                  '90 Egp',
                  style: TextStyle(
                    color: maincolor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          // Add to Cart Button
          Positioned(
            bottom: 5,
            right: 10,
            child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: (){},
                      child: Container(
                        height: 24,
                        width: 24,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: maincolor
                        ),
                        child: const Center(
                          child: Icon(Icons.add, color: Colors.white,size: 16),
                        ),
                      ),
                    ),
          ),
        ],
      ),
    );
  }
}