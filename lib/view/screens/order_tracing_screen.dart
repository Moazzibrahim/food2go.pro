import 'package:flutter/material.dart';
import 'package:food2go_app/constants/colors.dart';
import 'package:food2go_app/view/widgets/custom_appbar.dart';

class OrderTracingScreen extends StatelessWidget {
  const OrderTracingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, 'Order Tracking'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildOrderStatusItem(
              icon: Icons.restaurant_menu,
              title: 'Order Placed',
              subtitle: '25 Aug 2024, 25 Aug 2024',
              isActive: true,
              isLast: false, // Not the last item
            ),
            _buildOrderStatusItem(
              icon: Icons.delivery_dining,
              title: 'Preparing From restaurant',
              isActive: true,
              isLast: false, // Not the last item
            ),
            _buildOrderStatusItem(
              icon: Icons.pedal_bike,
              title: 'Order Is On The Way',
              subtitle: 'Your Delivery Man Is Coming',
              isActive: false,
              isLast: false, // Not the last item
            ),
            _buildOrderStatusItem(
              icon: Icons.check_circle_outline,
              title: 'Order Delivered',
              isActive: false,
              isLast: true, 
            ),
          ],
        ),
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

  const CustomDashedLine({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
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
