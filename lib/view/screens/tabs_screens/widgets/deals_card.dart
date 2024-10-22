import 'package:flutter/material.dart';
import 'package:food2go_app/constants/colors.dart';

class DealsCard extends StatelessWidget {
  const DealsCard({super.key, required this.description, required this.price, required this.image});
  final String description;
  final double price;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      width: double.infinity,
      height: 173,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(image),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(price.toString(),style: const TextStyle(fontSize: 32,fontWeight: FontWeight.w500,color: maincolor),),
                  const Text('EGP',style: TextStyle(fontSize: 32,fontWeight: FontWeight.w500,color: maincolor),)
                ],
              )
            ],
          ),
          const SizedBox(height: 12,),
          Text(description,style: const TextStyle(fontSize: 15,fontWeight: FontWeight.w600),)
        ],
      ),
    );
  }
}