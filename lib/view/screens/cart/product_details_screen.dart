// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:food2go_app/constants/colors.dart';
import 'package:food2go_app/models/categories/product_model.dart';
import 'package:food2go_app/view/screens/cart/cart_details.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key,this.product});
  final Product? product;

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int quantity = 1;
  String? selectedOption; // Track the selected size
  bool isFavorited = false;

  void increaseQuantity() {
    setState(() {
      quantity++;
    });
  }

  void decreaseQuantity() {
    if (quantity > 1) {
      setState(() {
        quantity--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header section with curved background and image
            Stack(
              children: [
                ClipPath(
                  clipper: HeaderClipper(),
                  child: Container(
                    height: 450,
                    color: maincolor,
                  ),
                ),
                Positioned(
                  top: 40,
                  left: 16,
                  right: 16,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios,
                            color: Colors.white),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      const Text(
                        "Cart",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          isFavorited ? Icons.favorite : Icons.favorite_border,
                          color: isFavorited ? maincolor : Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            isFavorited = !isFavorited; // Toggle favorite state
                          });
                        },
                      )
                    ],
                  ),
                ),
                Positioned(
                  top: 100,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: CircleAvatar(
                      radius: 120,
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/pastaa.png', // Replace with your image path
                          height: 200,
                          width: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Pasta",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "150 Egp",
                        style: TextStyle(
                          fontSize: 22,
                          color: maincolor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16,),
                  ...List.generate(widget.product!.variations.length, (index) {
                    final variation = widget.product!.variations[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(variation.name,style: const TextStyle(fontSize: 17,fontWeight: FontWeight.w700),),
                        const SizedBox(height: 8,),
                        Row(
                          children: List.generate(widget.product!.variations[index].options.length,
                          (j) {
                            final option = widget.product!.variations[index].options[j];
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedOption = option.name;
                                });
                              },
                              child: SizeOption(
                                text: option.name,
                                isSelected: selectedOption == option.name,
                                ),
                            );
                          },
                          ),
                        )
                      ],
                    );
                  },),
                  const SizedBox(height: 16),
                  const Text(
                    "Ingredients:",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text("Pasta, Basil, Cheese"),
                  const SizedBox(height: 8),
                  const Text(
                    "Add on order:",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  ...List.generate(
                  widget.product!.addons.length, 
                  (index) {
                    final addon = widget.product!.addons[index];
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(addon.name),
                        Checkbox(value: false, onChanged: (value){})
                      ],
                    );
                  },
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: decreaseQuantity,
                            icon: const Icon(Icons.remove_circle_outline),
                          ),
                          Text(
                            "$quantity",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            onPressed: increaseQuantity,
                            icon: const Icon(Icons.add_circle_outline),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const CartDetailssScreen()));
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 32),
                          backgroundColor: maincolor,
                        ),
                        child: const Text(
                          "Add to Cart",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom clipper for the curved header
class HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 100);
    var controlPoint = Offset(size.width / 2, size.height);
    var endPoint = Offset(size.width, size.height - 100);
    path.quadraticBezierTo(
        controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class SizeOption extends StatelessWidget {
  final String text;
  final bool isSelected;

  const SizeOption({super.key, required this.text, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? maincolor : Colors.transparent,
          border: Border.all(color: maincolor),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : maincolor,
          ),
        ),
      ),
    );
  }
}
