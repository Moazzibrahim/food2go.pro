import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:food2go_app/controllers/Auth/login_provider.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart'; // Ensure provider is imported

import '../../models/banners/banners_model.dart';

class BannerProvider with ChangeNotifier {
  List<AppBanner> _banners = [];

  List<AppBanner> get banners => _banners;
  Future<void> fetchBanners(BuildContext context) async {
    final url = Uri.parse('https://backend.food2go.pro/customer/home/slider');

    final loginProvider = Provider.of<LoginProvider>(context, listen: false);
    final String token = loginProvider.token!;

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      // Log the response body
      log('Response data: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> bannerData = data['banners'] ?? [];
        _banners = bannerData.map((json) => AppBanner.fromJson(json)).toList();
        notifyListeners();
      } else {
        log('Failed to load banners: ${response.body}');
        throw Exception('Failed to load banners');
      }
    } catch (error) {
      log('Error fetching banners: $error');
      throw Exception('Error fetching banners: $error');
    }
  }
}
