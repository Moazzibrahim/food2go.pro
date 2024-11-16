import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:food2go_app/models/chat/chat_deliver_model.dart'; // Ensure this import is correct
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../Auth/login_provider.dart';

class ChatProvider with ChangeNotifier {
  List<Chat> _messages = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Chat> get messages => _messages;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Future<void> fetchChat(BuildContext context, int orderId, int userId) async {
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);
    final String token = loginProvider.token!;
    final String url =
        'https://bcknd.food2go.online/delivery/chat/$orderId/$userId';

    print('UserId: $userId');
    print('OrderId: $orderId');

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        log(response.body);
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['chat'] != null) {
          _messages = List<Chat>.from(
            data['chat'].map((json) => Chat.fromJson(json)),
          );

          _messages.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
        } else {
          log('No messages found in response');
          _errorMessage = 'No messages found in response';
        }
      } else {
        _errorMessage = 'Failed to load chat messages';
        log('Error: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      _errorMessage = 'An error occurred: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> sendMessage(
      BuildContext context, int orderId, int userId, String message) async {
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);
    final String token = loginProvider.token!; // Assuming token is non-nullable
    const String url = 'https://bcknd.food2go.online/delivery/chat/send';

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'order_id': orderId,
          'user_id': userId,
          'message': message,
        }),
      );

      if (response.statusCode == 200) {
        log('Message sent successfully');
      } else {
        _errorMessage = 'Failed to send message';
        log('Error: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      _errorMessage = 'An error occurred: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
