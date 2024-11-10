// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:food2go_app/constants/colors.dart';
import 'package:food2go_app/models/Auth/login_model.dart';
import 'package:food2go_app/view/screens/tabs_screen.dart';
import 'package:food2go_app/view/widgets/show_top_snackbar.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginProvider with ChangeNotifier {
  LoginModel? userModel;
  String? token; // Variable to store the token
  bool isLoading = false;

  Future<void> login(
      String email, String password, BuildContext context) async {
    final url = Uri.parse('https://Bcknd.food2go.online/api/user/auth/login');
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
        final responseData = jsonDecode(response.body);
        userModel = LoginModel.fromJson(responseData);
        token = userModel?.token; // Store the token in the variable

        // Log the token
        log('Token: $token');

        // Navigate to HomeScreen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const TabsScreen()),
        );

        // Handle successful login, save token, etc.
      } else {
        showTopSnackBar(context, 'wrong email or password.', Icons.cancel,
            maincolor, const Duration(seconds: 2));
        // Handle login failure, for example by throwing an error
        throw Exception('Failed to login');
      }
    } catch (error) {
      log('$error');
      // Handle any other errors (like network issues)
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
