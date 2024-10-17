// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:food2go_app/models/Auth/sign_up_model.dart';
import 'package:food2go_app/view/screens/home_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SignUpProvider with ChangeNotifier {
  SignUpModel? signUpModel;
  String? errorMessage; // Store error messages
  bool isLoading = false; // Store loading state

  Future<void> signUpUser({
    required String fName,
    required String lName,
    required String email,
    required String phone,
    required String password,
    required String confPassword,
    BuildContext? context,
  }) async {
    const String url = 'https://backend.food2go.pro/api/user/auth/signup';
    errorMessage = null; // Reset the error message at the start

    // Prepare the request body
    final Map<String, dynamic> body = {
      'f_name': fName,
      'l_name': lName,
      'email': email,
      'phone': phone,
      'password': password,
      'conf_password': confPassword,
    };

    isLoading = true; // Set loading to true before the request
    notifyListeners(); // Notify listeners about the loading state change

    try {
      // Make the POST request
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json', // Set the content type to JSON
        },
        body: jsonEncode(body), // Encode the body to JSON format
      );

      // Check the response status
      if (response.statusCode == 200) {
        // Successful signup
        final responseData = jsonDecode(response.body);
        signUpModel = SignUpModel.fromJson(responseData);
        print('User signed up successfully: ${signUpModel?.user?.name}');

        ScaffoldMessenger.of(context!).showSnackBar(
          SnackBar(
            content: Text(
                'Sign up successful! Welcome, ${signUpModel?.user?.name}.'),
          ),
        );
        Future.delayed(
          const Duration(seconds: 2),
          () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const HomeScreen()));
          },
        );
      } else {
        // Handle errors
        final responseData = jsonDecode(response.body);
        String errorMsg = 'Sign up failed.';

        // Check if there are validation errors
        if (responseData['errors'] != null) {
          // Collect all error messages from the response
          final List<String> errorMessages = [];
          responseData['errors'].forEach((key, value) {
            if (value is List) {
              errorMessages.addAll(value.map((e) => '$key: $e').toList());
            }
          });
          errorMsg = errorMessages.join('\n'); // Join error messages
        }

        errorMessage = errorMsg;
        print('Failed to sign up. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');

        // Show the combined error messages in the Snackbar
        ScaffoldMessenger.of(context!).showSnackBar(
          SnackBar(content: Text(errorMsg)),
        );
      }
    } catch (e) {
      // Handle exceptions
      errorMessage = 'Error occurred during signup: $e';
      print(errorMessage);

      // Show error message in the Snackbar if context is provided
      if (context != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage!)),
        );
      }
    } finally {
      isLoading = false; // Set loading to false after the request
      notifyListeners(); // Notify listeners about the loading state change
    }
  }
}
