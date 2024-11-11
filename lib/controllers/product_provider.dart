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

  List<CartItem> _cart = [];
  List<CartItem> get cart => _cart;

  double _totalPrice = 0.0;
  double _totalTax = 0.0;

  double get totalPrice {
  _totalPrice = 0.0;
  double defaultPrice;
  for (var item in cart) {
    defaultPrice = item.product.price / item.product.quantity;
    defaultPrice += (defaultPrice * (item.product.tax.amount / 100));
    if(item.product.discountId.isNotEmpty){
      defaultPrice -=  (defaultPrice * (item.product.discount.amount / 100));
    }
    _totalPrice += defaultPrice * item.product.quantity;
    for (var extra in item.extra) {
      _totalPrice += extra.price * extra.extraQuantity;
    }
  }
  return _totalPrice;
}


  void increaseProductQuantity(int index) {
  double defaultPrice = cart[index].product.price / cart[index].product.quantity;
  cart[index].product.quantity++;
  cart[index].product.price  = defaultPrice * cart[index].product.quantity;
  notifyListeners();
}

void decreaseProductQuantity(int index) {
  double defaultPrice = cart[index].product.price / cart[index].product.quantity;
  if (cart[index].product.quantity > 1) {
    cart[index].product.quantity--;
    cart[index].product.price  = defaultPrice * cart[index].product.quantity;
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

  double getTotalTax(List<Product> cartProducts){
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
      final response = await http.put(Uri.parse('$makeFav$id'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({'favourite': fav}));
      if (response.statusCode == 200) {
        for (var e in _products) {
          if (e.id == id) {
            e.isFav = (fav == 1);
          }
        }
        _favorites = _products.where((e) => e.isFav).toList();
        notifyListeners();

        if (fav == 1) {
          showTopSnackBar(context, 'Added to Favorites!', Icons.favorite,
              maincolor, const Duration(seconds: 4));
        } else {
          showTopSnackBar(context, 'Item removed', Icons.heart_broken,
              maincolor, const Duration(seconds: 4));
        }
      } else {
        log('Failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      log('Error in making fav: $e');
    }
  }

  Future<void> postCart(BuildContext context, {
  required List<Product> products,
  required String date,
  required int? branchId,
  required String paymentStatus,
  required double totalTax,
  required int addressId,
  required String orderType,
  required String paidBy,
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
        'date': date,
        'branch_id': branchId,
        'amount': totalPrice,
        'payment_status': 'paid',
        'total_tax': 14,
        'total_discount': 50,
        'address': 2,
        'order_type': 'delivery',
        'paid_by': 'cash',
        'products': products.map((product) => {
          'product_id': product.id,
          'count' : product.quantity,
          'addons': product.addons.map((addon) => {
            'addon_id' : addon.id,
            'count' : 1
          },),
          'variation': product.variations.map((variation) => {
            'variation_id': variation.id,
            'option_id': variation.options.map((e) => e.id,).toList(),
          }).toList(),
          'extra_id': product.extra.map((e) => e.id,).toList(),
          'exclude_id': product.excludes.map((e) => e.id,).toList(),
        }).toList(),
      }),
    );
    
    if (response.statusCode == 200) {
      log('Order posted successfully');
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
        product: product, extra: extra, options: options, addons: addons,excludes: excludes));
  }
}
