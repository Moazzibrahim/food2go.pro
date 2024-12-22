// ignore_for_xxxxxxxxxxe: use_build_context_synchronously

// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:food2go_app/constants/colors.dart';
import 'package:food2go_app/constants/strings.dart';
import 'package:food2go_app/controllers/Auth/login_provider.dart';
import 'package:food2go_app/models/categories/cart_model.dart';
import 'package:food2go_app/models/categories/product_model.dart';
import 'package:food2go_app/view/screens/checkout/payment_web_view.dart';
import 'package:food2go_app/view/screens/order_tracing_screen.dart';
import 'package:food2go_app/view/widgets/show_top_snackbar.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  List<Product> get products => _products;

  List<Product> _popularProducts = [];
  List<Product> get popularProducts => _popularProducts;

  List<Product> _favorites = [];
  List<Product> get favorites => _favorites;

  List<Product> _discounts = [];
  List<Product> get discounts => _discounts;

  final List<CartItem> _cart = [];
  List<CartItem> get cart => _cart;

  double _totalPrice = 0.0;
  double _totalTax = 0.0;

  double get totalPrice {
    _totalPrice = 0.0;
    double defaultPrice;
    for (var item in cart) {
      defaultPrice = item.product.price / item.product.quantity;
      defaultPrice += (defaultPrice * (item.product.tax.amount / 100));
      if (item.product.discountId.isNotEmpty) {
        defaultPrice -= (defaultPrice * (item.product.discount.amount / 100));
      }
      _totalPrice += defaultPrice * item.product.quantity;
      for (var extra in item.extra) {
        _totalPrice += extra.price * extra.extraQuantity;
      }
    }
    return _totalPrice;
  }

  void removeProductFromCart(int index) {
    cart.removeAt(index);
    notifyListeners();
  }

  void increaseProductQuantity(int index) {
    double defaultPrice =
        cart[index].product.price / cart[index].product.quantity;
    cart[index].product.quantity++;
    cart[index].product.price = defaultPrice * cart[index].product.quantity;
    notifyListeners();
  }

  void decreaseProductQuantity(int index) {
    double defaultPrice =
        cart[index].product.price / cart[index].product.quantity;
    if (cart[index].product.quantity > 1) {
      cart[index].product.quantity--;
      cart[index].product.price = defaultPrice * cart[index].product.quantity;
      notifyListeners();
    }
  }

  void increaseExtraQuantity(int index, int extraIndex) {
    cart[index].extra[extraIndex].extraQuantity++;
    notifyListeners();
  }

  void decreaseExtraQuantity(int index, int extraIndex) {
    if (cart[index].extra[extraIndex].extraQuantity > 1) {
      cart[index].extra[extraIndex].extraQuantity--;
      notifyListeners();
    }
  }

  double getTotalTax(List<Product> cartProducts) {
    for (var e in cartProducts) {
      _totalTax += e.tax.amount;
    }
    return _totalTax;
  }

  double getTotalTaxAmount(List<Product> cartProducts) {
    double taxAmount = 0;
    for (var e in cartProducts) {
      taxAmount = (e.price * (e.tax.amount / 100));
    }
    return taxAmount;
  }

  Future<void> fetchProducts(BuildContext context) async {
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);
    final String token = loginProvider.token!;
    try {
      final response = await http.get(
        Uri.parse(categoriesUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        Products products = Products.fromJson(responseData);
        _products = products.products.map((e) => Product.fromJson(e)).toList();
        _popularProducts = _products.where((e) => e.reccomended == 1).toList();
        _favorites = _products.where((e) => e.isFav).toList();
        _discounts = _products.where((e) => e.discountId.isNotEmpty).toList();
        log('discounts: ${_discounts.map((e) => e.name)}');
        notifyListeners();
      } else {
        log('Failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      log('Error in fetch products: $e');
    }
  }

  List<Product> getProductsByCategory(int categoryId) {
    return _products
        .where((product) => product.categoryId == categoryId)
        .toList();
  }

  List<Product> getFilteredProducts(
      int? categoryId, double priceStart, double priceEnd) {
    return _products.where((product) {
      final matchesCategory =
          categoryId == null || product.categoryId == categoryId;
      final matchesPrice =
          product.price >= priceStart && product.price <= priceEnd;
      return matchesCategory && matchesPrice;
    }).toList();
  }

  List<Extra> getExtras(Product product, int selectedVariation) {
    // Return an empty list if the selectedVariation is invalid
    if (selectedVariation < 0 ||
        selectedVariation >= product.variations.length) {
      return [];
    }

    if (product.extra.isEmpty) {
      List<Extra> extras = [];
      final options = product.variations[selectedVariation].options;
      for (var e in options) {
        extras.addAll(e.extra);
      }
      return extras;
    } else {
      return product.extra;
    }
  }

  Future<void> makeFavourites(BuildContext context, int fav, int id) async {
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);
    final String token = loginProvider.token!;

    try {
      final response = await http.put(
        Uri.parse('$makeFav$id'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'favourite': fav}),
      );

      if (response.statusCode == 200) {
        // Update favorites status
        _updateFavoritesStatus(id, fav);

        // Notify user
        final message = fav == 1 ? 'Added to Favorites!' : 'Item removed';
        final icon = fav == 1 ? Icons.favorite : Icons.heart_broken;

        showTopSnackBar(
            context, message, icon, maincolor, const Duration(seconds: 4));
      } else {
        log('Failed with status code: ${response.statusCode}');
        showTopSnackBar(context, 'Failed to update favorite status.',
            Icons.error, Colors.red, const Duration(seconds: 4));
      }
    } catch (e) {
      log('Error in making fav: $e');
      showTopSnackBar(context, 'An error occurred. Please try again later.',
          Icons.error, Colors.red, const Duration(seconds: 4));
    }
  }

// Helper method to update favorites and discounts
  void _updateFavoritesStatus(int id, int fav) {
    bool isFavorite = (fav == 1);

    for (var product in _products) {
      if (product.id == id) {
        product.isFav = isFavorite;
      }
    }
    _favorites = _products.where((product) => product.isFav).toList();
    notifyListeners();
  }

  Future<void> postCart(
    BuildContext context, {
    required List<Product> products,
    String? receipt,
    String? notes,
    required String date,
    int? branchId,
    required double totalTax,
    int? addressId,
    required int paymentMethodId,
    required String orderType,
  }) async {
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);
    final String token = loginProvider.token!;

    try {
      final response = await http.post(
        Uri.parse(postOrder),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'notes': notes,
          'date': date,
          'payment_method_id': paymentMethodId,
          'receipt': receipt,
          'branch_id': branchId,
          'amount': totalPrice,
          'total_tax': totalTax,
          'total_discount': 50,
          'address_id': addressId,
          'order_type': 'delivery',
          'products': products
              .map((product) => {
                    'product_id': product.id,
                    'count': product.quantity,
                    'addons': product.addons
                        .map((addon) => {'addon_id': addon.id, 'count': 1})
                        .toList(),
                    'variation': product.variations
                        .map((variation) => {
                              'variation_id': variation.id,
                              'option_id':
                                  variation.options.map((e) => e.id).toList(),
                            })
                        .toList(),
                    'extra_id': product.extra.map((e) => e.id).toList(),
                    'exclude_id': product.excludes.map((e) => e.id).toList(),
                  })
              .toList(),
        }),
      );

      if (response.statusCode == 200) {
        log(response.body);
        log('Order posted successfully');
        final responseData = jsonDecode(response.body);

        if (responseData.containsKey('paymentLink')) {
          final String paymentLink = responseData['paymentLink'];
          final int orderId = responseData['success'];
          final result = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => PaymentWebView(url: paymentLink),
            ),
          );
          if (result == true) {
            await checkCallBack(context, orderId);
          } else {
            log('WebView closed without completing the payment');
          }
        }
      } else {
        log(response.body);
        log('Failed to post order: ${response.statusCode}');
      }
    } catch (e) {
      log('Error in post order: $e');
    }
  }

  void addtoCart(Product product, List<Extra> extra, List<Option> options,
      List<AddOns> addons, List<Excludes> excludes) {
    _cart.add(CartItem(
        product: product,
        extra: extra,
        options: options,
        addons: addons,
        excludes: excludes));
  }

  Future<void> checkCallBack(BuildContext context, int id) async {
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);
    final String token = loginProvider.token!;
    
      try {
        final response = await http.get(
          Uri.parse(
              'https://bcknd.food2go.online/customer/make_order/callback_status/$id'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode == 200) {
          log('The order submitted successfully');
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => OrderTrackingScreen(orderId: id),
            ),
          );
          return;
        } else if (response.statusCode == 400) {
          log('Something went wrong');
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Payment Failed'),
              content: const Text(
                  'The payment could not be completed. Please try again or use a different payment method.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop(); // Close the dialog
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        } else {
          log('response body: ${response.body}');
          log('response statuscode: ${response.statusCode}');
        }
      } catch (e) {
        log('Error in callback: $e');
      }
    }
  }
