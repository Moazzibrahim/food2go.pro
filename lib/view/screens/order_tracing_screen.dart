// ignore_for_file: must_be_immutable, unused_local_variable

import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:food2go_app/constants/colors.dart';
import 'package:food2go_app/controllers/Auth/login_provider.dart';
import 'package:food2go_app/view/widgets/custom_appbar.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class OrderTrackingScreen extends StatelessWidget {
  final int? orderId;
  int? deliveryManId;
  OrderTrackingScreen({super.key, this.orderId, this.deliveryManId});
  Future<Map<String, dynamic>> fetchOrderDetails(BuildContext context) async {
    final url = Uri.parse(
        'https://Bcknd.food2go.online/customer/orders/order_status/$orderId');
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);
    final String token = loginProvider.token!;

    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      deliveryManId = data['delivery_id'];
      log("order id: $orderId");
      log('delivery id: $deliveryManId');
      return data;
    } else {
      throw Exception('Failed to load order details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, 'Order Tracking'),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchOrderDetails(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No data found'));
          } else {
            final data = snapshot.data!;
            final status = data['status'] ?? 'unknown';
            final setting = data['delivery_time']['setting'] ?? 'Not Available';
            final createdAtString = data['delivery_time']['created_at'] ?? '';
            final timedeliverd = data['time_delivered'] ?? 'unknown';

            // Parse created_at to DateTime
            DateTime createdAt;
            int differenceInMinutes = 0;
            try {
              createdAt = DateTime.parse(createdAtString);
              differenceInMinutes =
                  DateTime.now().difference(createdAt).inMinutes;
            } catch (e) {
              log('Error parsing created_at: $e');
            }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Delivery time: $timedeliverd',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Text(
                  //   'Created At: $createdAtString',
                  //   style: const TextStyle(
                  //     fontSize: 16,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  // ),
                  // const SizedBox(height: 8),
                  // Text(
                  //   'Time Difference: $differenceInMinutes minutes',
                  //   style: const TextStyle(
                  //     fontSize: 16,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  // ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView(
                      children: [
                        _buildOrderStatusItem(
                          icon: Icons.pending_actions,
                          title: 'Pending',
                          isActive: status == 'pending' ||
                              status == 'confirmed' ||
                              status == 'processing' ||
                              status == 'out_for_delivery' ||
                              status == 'scheduled' ||
                              status == 'delivered',
                          isLast: false,
                        ),
                        _buildOrderStatusItem(
                          icon: Icons.kitchen,
                          title: 'Preparing',
                          isActive: status == 'processing' ||
                              status == 'out_for_delivery' ||
                              status == 'scheduled' ||
                              status == 'delivered',
                          isLast: false,
                        ),
                        _buildOrderStatusItem(
                          icon: Icons.delivery_dining,
                          title: 'Out for Delivery',
                          isActive: status == 'out_for_delivery' ||
                              status == 'delivered',
                          isLast: false,
                        ),
                        _buildOrderStatusItem(
                          icon: Icons.check_circle_outline,
                          title: 'Delivered',
                          isActive: status == 'delivered',
                          isLast: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildOrderStatusItem({
    required IconData icon,
    required String title,
    String? subtitle,
    required bool isActive,
    required bool isLast,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                icon,
                size: 40,
                color: isActive ? maincolor : Colors.grey,
              ),
            ),
            if (!isLast) CustomDashedLine(isActive: isActive),
          ],
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: isActive ? maincolor : Colors.grey,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (subtitle != null)
              Text(
                subtitle,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            const SizedBox(height: 20),
          ],
        ),
      ],
    );
  }
}

class CustomDashedLine extends StatelessWidget {
  final bool isActive;

  const CustomDashedLine({super.key, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: 2,
      child: CustomPaint(
        painter: DashedLinePainter(isActive ? maincolor : Colors.grey),
      ),
    );
  }
}

class DashedLinePainter extends CustomPainter {
  final Color color;

  DashedLinePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    double dashWidth = 5, dashSpace = 3;
    double startY = 0;
    while (startY < size.height) {
      canvas.drawLine(
        Offset(0, startY),
        Offset(0, startY + dashWidth),
        paint,
      );
      startY += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
