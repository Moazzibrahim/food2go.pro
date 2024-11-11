// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:food2go_app/controllers/product_provider.dart';
import 'package:food2go_app/models/categories/product_model.dart';
import 'package:food2go_app/view/screens/order_tracing_screen.dart';
import 'package:food2go_app/view/widgets/custom_appbar.dart';
import 'package:provider/provider.dart';
import '../../../constants/colors.dart'; // Replace this with your actual constants import

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key, required this.cartProducts});
  final List<Product> cartProducts;

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String? selectedPaymentMethod;
  String? selectedDeliveryOption;
  String? selectedBranch;
  String? selectedDeliveryLocation;
  bool deliveryNow = false;
  double totalTax = 0.0;
  final TextEditingController noteController = TextEditingController();
  final TextEditingController deliveryTimeController = TextEditingController();

  final List<Map<String, dynamic>> paymentMethods = [
    {'name': 'Cash', 'icon': Icons.money, 'value': 'cash'},
    {'name': 'Visa', 'icon': Icons.credit_card, 'value': 'visa'},
  ];

  final List<Map<String, String>> branches = [
    {'name': 'Miami', 'address': '2464 Royal Ln. Mesa, New Jersey 45463'},
    {
      'name': 'Sumuhih',
      'address': '3891 Ranchview Dr. Richardson, California 62639'
    },
  ];

  final List<Map<String, String>> deliveryLocations = [
    {'name': 'Home', 'address': '2464 Royal Ln. Mesa, New Jersey 45463'},
    {
      'name': 'Work',
      'address': '3891 Ranchview Dr. Richardson, California 62639'
    },
  ];

  @override
  void initState() {
    totalTax = Provider.of<ProductProvider>(context,listen: false).getTotalTax(widget.cartProducts);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, 'Checkout'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Delivery Option Section
              _buildSectionTitle('Choose Pickup or Delivery'),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _buildDeliveryOptionRadio('take_away', 'Pickup'),
                  ),
                  Expanded(
                    child: _buildDeliveryOptionRadio('delivery', 'Delivery'),
                  ),
                  Expanded(
                    child: _buildDeliveryOptionRadio('dine_in', 'Dine in'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (selectedDeliveryOption == 'pickup') _buildNearestBranchCard(),
              if (selectedDeliveryOption == 'delivery')
                _buildDeliveryLocationCard(),

              const SizedBox(height: 30),
              // Payment Method Section
              _buildSectionTitle('Payment Method'),
              const SizedBox(height: 10),
              Column(
                children: paymentMethods.map((method) {
                  return _buildPaymentMethodTile(method);
                }).toList(),
              ),
              const SizedBox(height: 30),

              // Note Section
              _buildSectionTitle('Note'),
              const SizedBox(height: 10),
              _buildNoteInputField(),

              // Delivery Time Section
              if (!deliveryNow) ...[
                const SizedBox(height: 20),
                _buildSectionTitle('Delivery Time'),
                const SizedBox(height: 10),
                _buildDeliveryTimePicker(),
              ],

              const SizedBox(height: 10),
              _buildDeliveryNowCheckbox(),
              const SizedBox(height: 30),

              // Place Order Button
              _buildPlaceOrderButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: maincolor,
      ),
    );
  }

  Widget _buildDeliveryOptionRadio(String value, String text) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio(
          value: value,
          activeColor: maincolor,
          groupValue: selectedDeliveryOption,
          onChanged:  (String? value) {
            setState(() {
              selectedDeliveryOption = value;
            });
          },
        ),
        Text(text),
      ],
    );
}


  Widget _buildPaymentMethodTile(Map<String, dynamic> method) {
    return RadioListTile<String>(
      value: method['value'],
      groupValue: selectedPaymentMethod,
      onChanged: (String? value) {
        setState(() {
          selectedPaymentMethod = value;
        });
      },
      title: Row(
        children: [
          Icon(method['icon'], color: maincolor),
          const SizedBox(width: 10),
          Text(
            method['name'],
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      activeColor: maincolor,
    );
  }

  Widget _buildNearestBranchCard() {
    return Column(
      children: branches.map((branch) {
        return _buildSelectionTile(
            branch['name'], branch['address'], selectedBranch, (value) {
          setState(() {
            selectedBranch = value;
          });
        });
      }).toList(),
    );
  }

  Widget _buildDeliveryLocationCard() {
    return Column(
      children: deliveryLocations.map((location) {
        return _buildSelectionTile(
            location['name'], location['address'], selectedDeliveryLocation,
            (value) {
          setState(() {
            selectedDeliveryLocation = value;
          });
        });
      }).toList(),
    );
  }

  Widget _buildSelectionTile(String? name, String? address,
      String? selectedValue, ValueChanged<String?> onChanged) {
    return RadioListTile<String?>(
      value: name,
      groupValue: selectedValue,
      onChanged: onChanged,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name!,
            style: TextStyle(
              color: selectedValue == name ? Colors.white : maincolor,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            address!,
            style: TextStyle(
              color: selectedValue == name ? Colors.white70 : Colors.grey[700],
            ),
          ),
        ],
      ),
      activeColor: maincolor,
      tileColor: selectedValue == name ? maincolor : Colors.white,
      selected: selectedValue == name,
      selectedTileColor: maincolor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      contentPadding:
          const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
    );
  }

  Widget _buildNoteInputField() {
    return TextField(
      controller: noteController,
      decoration: InputDecoration(
        hintText: 'Add a note (e.g., delivery instructions)',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: Colors.grey[200],
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      ),
    );
  }

  // Delivery Time Picker
  Widget _buildDeliveryTimePicker() {
    return GestureDetector(
      onTap: () async {
        TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );
        if (pickedTime != null) {
          setState(() {
            deliveryTimeController.text = pickedTime.format(context);
          });
        }
      },
      child: AbsorbPointer(
        child: TextField(
          controller: deliveryTimeController,
          decoration: InputDecoration(
            hintText: 'Select delivery time',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            filled: true,
            fillColor: Colors.grey[200],
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          ),
        ),
      ),
    );
  }

  Widget _buildDeliveryNowCheckbox() {
    return CheckboxListTile(
      value: deliveryNow,
      onChanged: (bool? value) {
        setState(() {
          deliveryNow = value!;
          if (deliveryNow) {
            deliveryTimeController.clear();
          }
        });
      },
      title: Text(
        'Delivery Now',
        style: TextStyle(
          color: deliveryNow ? maincolor : Colors.grey[700],
          fontWeight: FontWeight.bold,
        ),
      ),
      controlAffinity: ListTileControlAffinity.leading,
      activeColor: maincolor,
    );
  }

  Widget _buildPlaceOrderButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async{
        await Provider.of<ProductProvider>(context,listen: false).postCart(context, 
        products: widget.cartProducts, 
        date: DateTime.now().toString(), 
        branchId: 1, 
        paymentStatus: 'paymentStatus', 
        totalTax: totalTax, 
        addressId: 1, 
        orderType: selectedDeliveryOption!, 
        paidBy: 'visa',
        );
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const OrderTrackingScreen()),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: maincolor,
        padding: const EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: const Center(
        child: Text(
          'Place Order',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
