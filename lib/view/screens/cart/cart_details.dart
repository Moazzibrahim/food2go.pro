// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:food2go_app/constants/colors.dart';
import 'package:food2go_app/controllers/product_provider.dart';
import 'package:food2go_app/models/categories/product_model.dart';
import 'package:food2go_app/view/screens/checkout/checkout_screen.dart';
import 'package:provider/provider.dart';

class CartDetailssScreen extends StatefulWidget {
  const CartDetailssScreen({super.key});

  @override
  _CartDetailssScreenState createState() => _CartDetailssScreenState();
}

class _CartDetailssScreenState extends State<CartDetailssScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Details cart')),
        automaticallyImplyLeading: false,
      ),
      body: Consumer<ProductProvider>(
        builder: (context, cartProvider, _) {
          if (cartProvider.cart.isEmpty) {
            return const Center(
              child: Text('No Items in Cart yet'),
            );
          } else {
            return SingleChildScrollView(
              child: Column(
                children: [
                  ...List.generate(
                    cartProvider.cart.length,
                    (index) {
                      final cartItem = cartProvider.cart[index];
                      return Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.all(16.0),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 5,
                                  blurRadius: 10,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Text(
                                  cartItem.product.image,
                                  // height: 70,
                                  // width: 70,
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            cartItem.product.name,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          ),
                                          const SizedBox(
                                            height: 3,
                                          ),
                                          cartItem.options.isNotEmpty ? Text('${cartItem.options.map(
                                            (e) => e.name,
                                          )}') : const SizedBox()
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        cartItem.product.description,
                                        style:
                                            const TextStyle(color: Colors.grey),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        cartItem.product.price.toString(),
                                        style: const TextStyle(
                                            color: maincolor,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        IconButton(
                                          onPressed: () => cartProvider.decreaseProductQuantity(index),
                                          icon: const Icon(Icons.remove),
                                        ),
                                        Text(cartItem.product.quantity.toString(),
                                            style: const TextStyle(fontSize: 16)),
                                        IconButton(
                                          onPressed: () => cartProvider.increaseProductQuantity(index),
                                          icon: const Icon(Icons.add),
                                        ),
                                      ],
                                    ),
                                    IconButton(
                                      onPressed: () {},
                                      icon: const Icon(Icons.delete,
                                          color: maincolor),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
              
              
              
              
                          cartItem.extra.isNotEmpty
                  ? Column(
                      children: List.generate(
                        cartItem.extra.length,
                        (extraIndex) => Container(
              margin: const EdgeInsets.all(16.0),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 5,
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cartItem.extra[extraIndex].name,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          cartItem.extra[extraIndex].price.toString(),
                          style: const TextStyle(
                              color: maincolor, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: ()=> cartProvider.decreaseExtraQuantity (index, extraIndex),
                            icon: const Icon(Icons.remove),
                          ),
                          Text(cartItem.extra[extraIndex].extraQuantity.toString(),
                              style: const TextStyle(fontSize: 16)),
                          IconButton(
                            onPressed: ()=> cartProvider.increaseExtraQuantity(index, extraIndex),
                            icon: const Icon(Icons.add),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.delete, color: maincolor),
                      ),
                    ],
                  ),
                ],
              ),
                        ),
                      ),
                    )
                  : const SizedBox(),
                        ],
                      );
                    },
                  ),
                  // Order Summary Section
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 5,
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Order Summary',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(height: 10),
                            Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Total Food'),
                              Text('${cartProvider.totalPrice} EGP'),
                            ],
                          ),
                          const SizedBox(height: 15),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Discount'),
                              Text('0 EGP'),
                            ],
                          ),
                          const Divider(thickness: 1),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                            const Text('Total',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 16)),
                              Text('${cartProvider.totalPrice} EGP',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 16)),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Center(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: maincolor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 32, vertical: 16),
                              ),
                              onPressed: () {
                                List<Product> cartProducts = cartProvider.cart.map((e) => e.product,).toList();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            CheckoutScreen(cartProducts: cartProducts,)));
                              },
                              child: const Text('Checkout',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 80,)
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
