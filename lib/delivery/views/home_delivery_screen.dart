import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/colors.dart';
import '../../controllers/delivery/order_provider.dart';
import '../../models/delivery/orders_delivery_model.dart';
import 'details_order_delivery_screen.dart';

class HomeDeliveryScreen extends StatefulWidget {
  const HomeDeliveryScreen({super.key});

  @override
  State<HomeDeliveryScreen> createState() => _HomeDeliveryScreenState();
}

class _HomeDeliveryScreenState extends State<HomeDeliveryScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<OrderdeliveryProvider>(context, listen: false)
        .fetchOrders(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Hello Muhammad"),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Active Order",
              style: TextStyle(
                color: maincolor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Consumer<OrderdeliveryProvider>(
                builder: (context, orderProvider, child) {
                  if (orderProvider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (orderProvider.orders.isEmpty) {
                    return const Center(child: Text("No active orders"));
                  }
                  return ListView.builder(
                    itemCount: orderProvider.orders.length,
                    itemBuilder: (context, index) {
                      final order = orderProvider.orders[index];
                      return OrderCard(order: order);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final Order order;

  const OrderCard({required this.order, super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "Order Id: #${order.id ?? 'N/A'}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.location_on, color: maincolor, size: 16),
                    const SizedBox(width: 4),
                    Text(order.address?.zone?.zone ?? 'Address not available'),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DetailsOrderDeliveryScreen(order: order),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: maincolor,
                      ),
                      child: const Text(
                        "View Details",
                        style: TextStyle(decoration: TextDecoration.underline),
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        foregroundColor: maincolor,
                        side: const BorderSide(color: maincolor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text("Directions"),
                    ),
                  ],
                ),
                const SizedBox(height: 35),
              ],
            ),
          ),
        ),
        Positioned(
          top: 12,
          right: 5,
          child: Container(
            height: 30,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 249, 105, 94),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
            ),
            child: const Text(
              'Confirmed',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: const BoxDecoration(
              color: maincolor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: const Center(
              child: Text(
                "Order Received",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
