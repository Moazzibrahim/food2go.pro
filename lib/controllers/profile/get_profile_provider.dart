// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:food2go_app/models/profile/profile_model.dart';
import 'package:http/http.dart' as http;

class GetProfileProvider with ChangeNotifier {
  UserProfile? _userProfile;
  bool _isLoading = false;

  UserProfile? get userProfile => _userProfile;
  bool get isLoading => _isLoading;
//token
  Future<void> fetchUserProfile() async {
    final url = Uri.parse('https://backend.food2go.pro/customer/profile/profile_data');

    try {
      _isLoading = true;
      notifyListeners();

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'];
        _userProfile = UserProfile.fromJson(data);
      } else {
        throw Exception('Failed to load profile data');
      }
    } catch (error) {
      print(error);
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}