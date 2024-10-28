import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:food2go_app/constants/strings.dart';
import 'package:food2go_app/controllers/Auth/login_provider.dart';
import 'package:food2go_app/models/categories/product_model.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  List<Product> get products => _products;

  List<Product> _popularProducts = [];
  List<Product> get popularProducts => _popularProducts;

  Future<void> fetchProducts(BuildContext context) async{
    final loginProvider = Provider.of<LoginProvider>(context,listen: false);
    final String token = loginProvider.token!;
    try {
      final response = await http.get(Uri.parse(categoriesUrl),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      );
      if (response.statusCode == 200) {
        Map<String,dynamic> responseData = jsonDecode(response.body);
        Products products = Products.fromJson(responseData);
        _products = products.products.map((e) => Product.fromJson(e),).toList();
        _popularProducts = _products.where((e) => e.reccomended == 1,).toList();
        notifyListeners();
      }else{
        log('fail with status code: ${response.statusCode}');
      }
    } catch (e) {
      log('Error in fetch products: $e');
    }
  }
}