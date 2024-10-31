import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:food2go_app/controllers/Auth/login_provider.dart';
import 'package:food2go_app/models/address/user_address_model.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class AddressProvider with ChangeNotifier {
  List<Address> _addresses = [];
  List<Zone> _zones = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Address> get addresses => _addresses;
  List<Zone> get zones => _zones;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchAddresses(String token) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('https://backend.food2go.pro/customer/address'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        _addresses = (data['addresses'] as List)
            .map((addressJson) => Address.fromJson(addressJson))
            .toList();

        _zones = (data['zones'] as List)
            .map((zoneJson) => Zone.fromJson(zoneJson))
            .toList();
      } else {
        _errorMessage = 'Failed to load addresses and zones';
      }
    } catch (error) {
      _errorMessage = 'An error occurred: $error';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addAddress({
    required BuildContext context,
    required int zoneId,
    required String address,
    required String street,
    required String buildingNum,
    required String floorNum,
    required String apartment,
    String? additionalData,
    required String type,
  }) async {
    _isLoading = true;
    notifyListeners();

    final loginProvider = Provider.of<LoginProvider>(context, listen: false);
    final String token = loginProvider.token!;

    try {
      final response = await http.post(
        Uri.parse('https://backend.food2go.pro/customer/address/add'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'zone_id': zoneId,
          'address': address,
          'street': street,
          'building_num': buildingNum,
          'floor_num': floorNum,
          'apartment': apartment,
          'additional_data': additionalData,
          'type': type,
        }),
      );

      if (response.statusCode == 200) {
        print(response.body);
        await fetchAddresses(token); // Pass token directly to fetchAddresses
      } else {
        print(response.body);
        _errorMessage = 'Failed to add address. Please try again.';
      }
    } catch (error) {
      print(error);
      _errorMessage = 'An error occurred: $error';
    } finally {
      _isLoading = false;
      if (context.mounted) {
        // Check if the context is still mounted
        notifyListeners();
      }
    }
  }

  Future<void> deleteAddress(String token, int addressId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.delete(
        Uri.parse(
            'https://backend.food2go.pro/customer/address/delete/$addressId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        _addresses.removeWhere((address) => address.id == addressId);
        notifyListeners(); // Trigger update in UI
      } else {
        _errorMessage = 'Failed to delete address. Please try again.';
      }
    } catch (error) {
      _errorMessage = 'An error occurred: $error';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
