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
        _products = products.products.map((e) => Product.fromJson(e),).toList();
        _popularProducts = _products.where((e) => e.reccomended == 1,).toList();
        _favorites = _products.where((e) => e.isFav,).toList();
        _discounts = _products.where((e)=> e.discountId.isNotEmpty).toList();
        log('discounts: ${_discounts.map((e)=> e.name)}');
        notifyListeners();
      } else {
        log('fail with status code: ${response.statusCode}');
      }
    } catch (e) {
      log('Error in fetch products: $e');
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
          if(e.id == id){
            if(fav == 1){
              e.isFav = true;
              notifyListeners();
            }else{
              e.isFav = false;
              notifyListeners();
            }
          }
        }
        _favorites = _products.where((e) => e.isFav,).toList();
        notifyListeners();
        if(fav == 1){
          // ignore: use_build_context_synchronously
        showTopSnackBar(context, 'Added to Favorites!', Icons.favorite,
            maincolor, const Duration(seconds: 4));
        }else{
          // ignore: use_build_context_synchronously
        showTopSnackBar(context, 'item removed', Icons.heart_broken,
            maincolor, const Duration(seconds: 4));
        }
      } else {
        log('fail with status code: ${response.statusCode}');
      }
    } catch (e) {
      log('Error in making fav: $e');
    }
  }
}
