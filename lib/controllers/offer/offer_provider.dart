import 'dart:convert';
import 'package:food2go_app/controllers/Auth/login_provider.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../../models/offer/offer_model.dart';

Future<List<Offer>> fetchOffers(context) async {
  const String url = 'https://backend.food2go.pro/customer/offers';
  
  final loginProvider = Provider.of<LoginProvider>(context, listen: false);
  final String token = loginProvider.token!;
  try {
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['offers'] as List)
          .map((offerJson) => Offer.fromJson(offerJson))
          .toList();
    } else {
      print(response.body);
      throw Exception('Failed to load offers');
    }
  } catch (e) {
    throw Exception('Error fetching offers: $e');
  }
}
