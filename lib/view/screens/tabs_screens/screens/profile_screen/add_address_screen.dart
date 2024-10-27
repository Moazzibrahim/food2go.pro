import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:food2go_app/constants/colors.dart';
import 'package:food2go_app/view/widgets/custom_appbar.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({super.key});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  String selectedCategory = 'Home';
  GoogleMapController? _mapController;
  final LatLng _initialPosition = const LatLng(37.7749, -122.4194);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(context, 'Add Address'),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: GoogleMap(
                          onMapCreated: (controller) {
                            _mapController = controller;
                          },
                          initialCameraPosition: CameraPosition(
                            target: _initialPosition,
                            zoom: 14,
                          ),
                          myLocationEnabled: true,
                          myLocationButtonEnabled: false,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildCategoryButton(context, 'Home'),
                        _buildCategoryButton(context, 'Work'),
                        _buildCategoryButton(context, 'Other'),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildTextField(context, 'Selection Zone',
                        isDropdown: true),
                    const SizedBox(height: 16),
                    _buildTextField(context, 'Street'),
                    const SizedBox(height: 16),
                    _buildTextField(context, 'Building No.'),
                    const SizedBox(height: 16),

                    // Row with Floor No and Apartment fields
                    Row(
                      children: [
                        Expanded(child: _buildTextField(context, 'Floor No')),
                        const SizedBox(width: 16),
                        Expanded(child: _buildTextField(context, 'Apartment')),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Additional Data field
                    _buildTextField(context, 'Additional Data'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Handle button press
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: maincolor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Save Address',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryButton(BuildContext context, String label) {
    final bool isSelected = selectedCategory == label;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = label;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? maincolor : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: maincolor),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : maincolor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(BuildContext context, String label,
      {bool isDropdown = false}) {
    if (isDropdown) {
      return DropdownButtonFormField<String>(
        decoration: InputDecoration(
          hintText: label,
          hintStyle: TextStyle(color: Colors.grey.shade600),
          filled: true,
          fillColor: Colors.grey.shade100,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
        items: ['Zone 1', 'Zone 2', 'Zone 3']
            .map((zone) => DropdownMenuItem(
                  value: zone,
                  child: Text(zone),
                ))
            .toList(),
        onChanged: (value) {},
        style: const TextStyle(color: Colors.black87),
      );
    } else {
      return TextFormField(
        decoration: InputDecoration(
          hintText: label,
          hintStyle: TextStyle(color: Colors.grey.shade600),
          filled: true,
          fillColor: Colors.grey.shade100,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
        style: const TextStyle(color: Colors.black87),
      );
    }
  }
}
