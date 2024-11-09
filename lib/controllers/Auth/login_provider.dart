// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:food2go_app/constants/colors.dart';
import 'package:food2go_app/delivery/views/tabs_delivery_screen.dart';
import 'package:food2go_app/models/Auth/login_model.dart';
import 'package:food2go_app/view/screens/tabs_screen.dart';
import 'package:food2go_app/view/widgets/show_top_snackbar.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginProvider with ChangeNotifier {
  LoginModel? userModel;
  String? token;
  bool isLoading = false;
  Future<void> login(
      String email, String password, BuildContext context) async {
    final url = Uri.parse('https://backend.food2go.pro/api/user/auth/login');
    try {
      isLoading = true;
      notifyListeners();

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        log(response.body.toString());
        final responseData = jsonDecode(response.body);
        userModel = LoginModel.fromJson(responseData);
        token = userModel?.token;
        log('Token: $token');

        if (userModel!.user?.role == "customer") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TabsScreen()),
          );
        } else if (userModel!.user?.role == "delivery") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TabsDeliveryScreen()),
          );
        } else {
          showTopSnackBar(
            context,
            'Access denied: Unauthorized role.',
            Icons.cancel,
            maincolor,
            const Duration(seconds: 2),
          );
        }
      } else {
        showTopSnackBar(context, 'Wrong email or password.', Icons.cancel,
            maincolor, const Duration(seconds: 2));
        throw Exception('Failed to login');
      }
    } catch (error) {
      log('$error');
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
