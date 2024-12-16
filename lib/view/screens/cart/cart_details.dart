// ignore_for_file: library_private_types_in_public_api, deprecated_member_use

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
  double totalDiscount = 0;
  double originalTotalPrice = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
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
              originalTotalPrice = 0;
              for (var e in cartProvider.cart) {
                originalTotalPrice += e.product.price;
              }
              originalTotalPrice +=
                  cartProvider.getTotalTaxAmount(cartProvider.cart
                      .map(
                        (e) => e.product,
                      )
                      .toList());
              for (var e in cartProvider.cart) {
                if (e.product.discountId.isNotEmpty) {
                  double discountAmount =
                      (originalTotalPrice * (e.product.discount.amount / 100));
                  totalDiscount += discountAmount;
                }
              }
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
                              margin: const EdgeInsets.all(16),
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
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      cartItem.product.image,
                                      width: 75, 
                                      height: 71, 
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                            cartItem.options.isNotEmpty
                                                ? Text('${cartItem.options.map(
                                                    (e) => e.name,
                                                  )}')
                                                : const SizedBox()
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Display the original price with an overline if there's a discount
                                            if (cartItem
                                                .product.discountId.isNotEmpty)
                                              Text(
                                                'EGP${cartItem.product.price.toString()}',
                                                style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 14,
                                                  decoration: TextDecoration
                                                      .lineThrough, // Adds the overline to original price
                                                ),
                                              ),

                                            // Display the final price
                                            Text(
                                              cartItem.product.discountId
                                                      .isEmpty
                                                  ? 'EGP${cartItem.product.price.toString()}'
                                                  : 'EGP${(cartItem.product.price - (cartItem.product.price * (cartItem.product.discount.amount / 100))).toStringAsFixed(2)}',
                                              style: const TextStyle(
                                                color: maincolor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          IconButton(
                                            onPressed: () => cartProvider
                                                .decreaseProductQuantity(index),
                                            icon: const Icon(Icons.remove),
                                          ),
                                          Text(
                                              cartItem.product.quantity
                                                  .toString(),
                                              style: const TextStyle(
                                                  fontSize: 16)),
                                          IconButton(
                                            onPressed: () => cartProvider
                                                .increaseProductQuantity(index),
                                            icon: const Icon(Icons.add),
                                          ),
                                        ],
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          cartProvider.removeProductFromCart(index);
                                        },
                                        icon: const Icon(Icons.delete,
                                            color: maincolor),
                                      )
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
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.2),
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
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    cartItem.extra[extraIndex].name,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Text(
                                                    cartItem
                                                        .extra[extraIndex].price
                                                        .toString(),
                                                    style: const TextStyle(
                                                        color: maincolor,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    IconButton(
                                                      onPressed: () => cartProvider
                                                          .decreaseExtraQuantity(
                                                              index,
                                                              extraIndex),
                                                      icon: const Icon(Icons.remove),
                                                    ),
                                                    Text(
                                                        cartItem.extra[extraIndex].extraQuantity.toString(),
                                                        style: const TextStyle(fontSize: 16)),
                                                    IconButton(
                                                      onPressed: () => cartProvider
                                                          .increaseExtraQuantity(
                                                              index,
                                                              extraIndex),
                                                      icon:
                                                          const Icon(Icons.add),
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
                                const Text('Total Tax'),
                                Text(
                                    '${cartProvider.getTotalTaxAmount(cartProvider.cart.map(
                                          (e) => e.product,
                                        ).toList())} EGP'),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Total Food'),
                                Text('$originalTotalPrice EGP'),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Discount'),
                                Text('${totalDiscount.toStringAsFixed(2)} EGP'),
                              ],
                            ),
                            const Divider(thickness: 1),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Total',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16)),
                                Text('${cartProvider.totalPrice} EGP',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16)),
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
                                  List<Product> cartProducts = cartProvider.cart
                                      .map(
                                        (e) => e.product,
                                      )
                                      .toList();
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => CheckoutScreen(
                                                cartProducts: cartProducts,
                                              )));
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
                    const SizedBox(
                      height: 80,
                    )
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
