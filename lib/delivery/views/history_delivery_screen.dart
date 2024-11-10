import 'package:flutter/material.dart';
import 'package:food2go_app/constants/colors.dart';

class HistoryDeliveryScreen extends StatelessWidget {
  HistoryDeliveryScreen({super.key});

  final List<Map<String, dynamic>> orderHistory = [
    {
      'orderId': '#5258',
      'status': 'Delivered',
      'amount': '152 LE',
      'orderDate': '05 Nov 2024',
    },
    {
      'orderId': '#5259',
      'status': 'Pending',
      'amount': '200 LE',
      'orderDate': '04 Nov 2024',
    },
    {
      'orderId': '#5260',
      'status': 'Cancelled',
      'amount': '120 LE',
      'orderDate': '03 Nov 2024',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('Order History'),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: orderHistory.length,
        itemBuilder: (context, index) {
          final order = orderHistory[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Order Id: ${order['orderId']}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Text(
                        'Amount',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Status: ${order['status']}',
                        style: TextStyle(
                          fontSize: 16,
                          color: order['status'] == 'Delivered'
                              ? maincolor
                              : Colors.black,
                          fontWeight: order['status'] == 'Delivered'
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                      Text(
                        order['amount'],
                        style: const TextStyle(
                          fontSize: 16,
                          color: maincolor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Order At ${order['orderDate']}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
