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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<OrderdeliveryProvider>(context, listen: false)
          .fetchOrders(context);
    });
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

class OrderCard extends StatefulWidget {
  final Order order;

  const OrderCard({required this.order, super.key});

  @override
  _OrderCardState createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  bool _isDelivered = true;
  bool _showNotDeliveredOptions = false;
  String? _selectedNotDeliveredOption;

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
                      "Order Id: #${widget.order.id ?? 'N/A'}",
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
                    Text(widget.order.address?.zone?.zone ??
                        'Address not available'),
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
                                DetailsOrderDeliveryScreen(order: widget.order),
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
          bottom: 0,
          left: 0,
          right: 0,
          child: _buildActionButtons(),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    if (widget.order.orderStatus == 'processing') {
      return GestureDetector(
        onTap: () {
          Provider.of<OrderdeliveryProvider>(context, listen: false)
              .updateOrderStatus(context, widget.order.id!, 'out_for_delivery');
          setState(() {
            widget.order.orderStatus = 'out_for_delivery';
          });
        },
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
      );
    } else if (widget.order.orderStatus == 'out_for_delivery') {
      return _showNotDeliveredOptions
          ? Row(
              children: [
                _buildStatusButton("Failed to Deliver",
                    _selectedNotDeliveredOption == "Failed to Deliver"),
                _buildStatusButton(
                    "Returned", _selectedNotDeliveredOption == "Returned"),
              ],
            )
          : Row(
              children: [
                _buildMainStatusButton("Delivered", _isDelivered, true),
                _buildMainStatusButton("Not Delivered", !_isDelivered, false),
              ],
            );
    }
    return const SizedBox.shrink();
  }

  Widget _buildMainStatusButton(String label, bool isActive, bool isDelivered) {
    return Expanded(
      child: GestureDetector(
        onTap: () async {
          setState(() {
            _isDelivered = isDelivered;
            _showNotDeliveredOptions = label == "Not Delivered";
            _selectedNotDeliveredOption = null;
          });

          if (label == "Delivered") {
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              await Provider.of<OrderdeliveryProvider>(context, listen: false)
                  .updateOrderStatus(context, widget.order.id!, 'delivered');

              Provider.of<OrderdeliveryProvider>(context, listen: false)
                  .fetchOrders(context);
            });
          }
        },
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isActive ? maincolor : Colors.white,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(isDelivered ? 12 : 0),
              bottomRight: Radius.circular(isDelivered ? 0 : 12),
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isActive ? Colors.white : maincolor,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusButton(String label, bool isActive) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedNotDeliveredOption = label;
          });

          WidgetsBinding.instance.addPostFrameCallback((_) async {
            final orderStatus =
                label == "Failed to Deliver" ? 'faild_to_deliver' : 'returned';

            await Provider.of<OrderdeliveryProvider>(context, listen: false)
                .updateOrderStatus(context, widget.order.id!, orderStatus);

            Provider.of<OrderdeliveryProvider>(context, listen: false)
                .fetchOrders(context);
          });
        },
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isActive ? maincolor : Colors.white,
            borderRadius: BorderRadius.only(
              bottomLeft:
                  Radius.circular(label == "Failed to Deliver" ? 12 : 0),
              bottomRight: Radius.circular(label == "Returned" ? 12 : 0),
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isActive ? Colors.white : maincolor,
            ),
          ),
        ),
      ),
    );
  }
}
