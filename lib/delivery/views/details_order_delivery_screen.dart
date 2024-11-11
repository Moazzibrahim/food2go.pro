import 'package:flutter/material.dart';
import 'package:food2go_app/constants/colors.dart';
import 'package:food2go_app/view/widgets/custom_appbar.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/delivery/orders_delivery_model.dart';

class DetailsOrderDeliveryScreen extends StatelessWidget {
  final Order order;

  const DetailsOrderDeliveryScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: buildAppBar(context, 'Order '),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Your Order Is Delivered',
                style: TextStyle(
                  color: maincolor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 20),
              buildSectionTitle('Delivery Info'),
              const SizedBox(height: 8),
              buildInfoContainer(
                'From',
                order.address?.zone?.branch?.name ?? 'Default Branch Name',
                'To',
                '${order.address?.address ?? 'Default Address'}, '
                    '${order.address?.street ?? 'Default Street'}, '
                    '${order.address?.buildingNum ?? 'Default Building Number'}, '
                    '${order.address?.floorNum ?? 'Default Floor Number'}, '
                    '${order.address?.apartment ?? 'Default Apartment'}, '
                    '${order.address?.zone?.zone ?? 'Default Zone'}',
              ),
              const SizedBox(height: 20),
              buildSectionTitle('Item Info'),
              const SizedBox(height: 8),
              buildItemInfo(),
              const SizedBox(height: 20),
              buildSectionTitle('Delivery Man'),
              const SizedBox(height: 8),
              buildDeliveryManInfo(),
              const SizedBox(height: 20),
              buildSectionTitle('Payment Info'),
              const SizedBox(height: 8),
              buildPaymentInfo(),
              const SizedBox(height: 20),
              buildSectionTitle('Delivery Note'),
              const SizedBox(height: 8),
              buildDeliveryNote(),
              const SizedBox(height: 20),
              buildSectionTitle('Price Details'),
              const SizedBox(height: 8),
              buildPriceDetails(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
        color: Colors.black87,
      ),
    );
  }

  Widget buildInfoContainer(
      String labelFrom, String addressFrom, String labelTo, String addressTo) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildAddressRow(labelFrom, addressFrom),
          const SizedBox(height: 12),
          buildAddressRow(labelTo, addressTo),
        ],
      ),
    );
  }

  Widget buildAddressRow(String label, String address) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        const SizedBox(height: 4),
        Row(
          children: [
            const Icon(
              Icons.location_on,
              color: maincolor,
              size: 18,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                address,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildItemInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: order.items?.map((item) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: const Icon(Icons.fastfood, color: maincolor),
                    title: Text(item.name ?? 'Item Name',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('${item.price?.toStringAsFixed(2)} E£'),
                    trailing: Text('X ${item.count ?? 1}'),
                  ),
                  if (item.addons != null && item.addons!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: item.addons!.map((addon) {
                          return Text(
                            'Adds On: ${addon.name} ${addon.price?.toStringAsFixed(2)} E£ (Qty: ${addon.count ?? 1})',
                            style: const TextStyle(color: Colors.grey),
                          );
                        }).toList(),
                      ),
                    ),
                ],
              );
            }).toList() ??
            [Container()],
      ),
    );
  }

  Widget buildDeliveryManInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: order.user?.image != null
                ? NetworkImage(order.user!.imageLink ?? order.user!.image!)
                : const AssetImage('assets/images/delivery.png')
                    as ImageProvider,
            radius: 24,
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                order.user?.name ?? 'customer',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const Row(
                children: [
                  Text('4.0', style: TextStyle(color: Colors.orange)),
                  Icon(Icons.star, color: Colors.orange, size: 16),
                ],
              ),
            ],
          ),
          const Spacer(),
          InkWell(
            onTap: () async {
              final phone = order.user?.phone;
              if (phone != null) {
                final url = Uri.parse('tel:$phone');
                if (await canLaunchUrl(url)) {
                  await launchUrl(url);
                } else {}
              }
            },
            child: const Icon(Icons.phone, color: maincolor),
          ),
        ],
      ),
    );
  }

  Widget buildPaymentInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.payment, color: maincolor),
          const SizedBox(width: 16),
          Text(
            order.orderStatus == "unpaid" ? 'Payment Accept' : 'Cash',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget buildDeliveryNote() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Text(
        order.notes!,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }

  Widget buildPriceDetails() {
    double totalAmount = (order.amount ?? 0.0) -
        (order.totalDiscount ?? 0.0) -
        (order.coupondiscount ?? 0.0) +
        (order.totalTax ?? 0.0) +
        ((order.address?.zone?.price) ?? 0.0);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          buildPriceRow(
              'Items Price', '${order.amount!.toStringAsFixed(2)} E£'),
          buildPriceRow(
              'Discount', '- ${order.totalDiscount!.toStringAsFixed(2)} E£'),
          buildPriceRow(
              'Vat/Tax', '+ ${order.totalTax!.toStringAsFixed(2)} E£'),
          buildPriceRow('Coupon Discount',
              '- ${order.coupondiscount!.toStringAsFixed(2)} E£'),
          buildPriceRow('Delivery Fee',
              '+ ${order.address?.zone?.price?.toStringAsFixed(2)} E£'),
          const Divider(),
          buildPriceRow('Total Amount', '${totalAmount.toStringAsFixed(2)} E£',
              isTotal: true),
        ],
      ),
    );
  }

  Widget buildPriceRow(String label, String amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 14,
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 14,
              color: isTotal ? Colors.black87 : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
