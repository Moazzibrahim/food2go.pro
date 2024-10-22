// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:food2go_app/constants/colors.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  double _priceStart = 33;
  double _priceEnd = 200;
  double _discount = 60;
  String _selectedCategory = 'Burger';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filter'),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: maincolor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Categories',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              children: [
                _buildCategoryChip('Burger'),
                _buildCategoryChip('Pastries'),
                _buildCategoryChip('Pasta'),
                _buildCategoryChip('Pizza'),
                _buildCategoryChip('Meat'),
                _buildCategoryChip('Candies'),
                _buildCategoryChip('Chickens'),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Price',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            RangeSlider(
              activeColor: maincolor,
              values: RangeValues(_priceStart, _priceEnd),
              min: 0,
              max: 200,
              divisions: 200,
              labels: RangeLabels('$_priceStart\$', '$_priceEnd\$'),
              onChanged: (RangeValues values) {
                setState(() {
                  _priceStart = values.start;
                  _priceEnd = values.end;
                });
              },
            ),
            const SizedBox(height: 20),
            const Text(
              'Discount',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Slider(
              activeColor: maincolor,
              value: _discount,
              min: 0,
              max: 100,
              divisions: 100,
              label: '$_discount%',
              onChanged: (double value) {
                setState(() {
                  _discount = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String category) {
    return ChoiceChip(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: maincolor)),
      label: Text(category),
      selected: _selectedCategory == category,
      onSelected: (bool selected) {
        setState(() {
          _selectedCategory = category;
        });
      },
      selectedColor: maincolor,
      labelStyle: TextStyle(
        color: _selectedCategory == category ? Colors.white : maincolor,
      ),
      backgroundColor: Colors.white,
    );
  }
}
