import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:food2go_app/constants/strings.dart';
import 'package:food2go_app/controllers/Auth/login_provider.dart';
import 'package:food2go_app/models/categories/categories_model.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class CategoriesProvider with ChangeNotifier {
  List<Category> _categories = [];
  List<Category> get categories => _categories;
  Future<void> fetchCategories(BuildContext context) async{
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
        Categories categories = Categories.fromJson(responseData);
        _categories = categories.categories.map((e) => Category.fromJson(e),).toList();
        notifyListeners();
      }else{
        log('fail with status code: ${response.statusCode}');
      }
    } catch (e) {
      log('Error in fetching categories: $e');
    }
  }
}