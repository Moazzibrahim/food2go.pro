// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:food2go_app/constants/colors.dart';
import 'package:food2go_app/constants/strings.dart';
import 'package:food2go_app/controllers/Auth/login_provider.dart';
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

  List<Extra> getExtras(Product product,int selectedVariation){
    if(product.extra.isEmpty){
      List<Extra> extras = [];
      final options = product.variations[selectedVariation].options;
      for (var e in options) {
        extras.addAll(e.extra);
      }
      return extras;
    }else{
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
}
