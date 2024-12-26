import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:food2go_app/models/categories/product_model.dart';

class AddonSelectionWidget extends StatefulWidget {
  const AddonSelectionWidget({
    super.key,
    required this.product,
    required this.mainColor,
    required this.onAddonsChanged,
  });

  final Product product;
  final Color mainColor;
  final Function(List<AddOns>, double) onAddonsChanged; // Updated signature

  @override
  State<AddonSelectionWidget> createState() => _AddonSelectionWidgetState();
}

class _AddonSelectionWidgetState extends State<AddonSelectionWidget> {
  Map<int, int> addonQuantities = {};
  Set<int> selectedAddOnIndices = {};
  List<AddOns> selectedAddons = [];
  double defaultPrice = 0.0;

  @override
  void initState() {
    defaultPrice = widget.product.price;
    super.initState();
    for (int i = 0; i < widget.product.addons.length; i++) {
      addonQuantities[i] = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Add on order:",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        ...List.generate(
          widget.product.addons.length,
          (index) {
            final addon = widget.product.addons[index];
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(addon.name),
                Row(
                  children: [
                    Checkbox(
                      value: selectedAddOnIndices.contains(index),
                      activeColor: widget.mainColor,
                      onChanged: (value) {
                        setState(() {
                          if (value == true) {
                            selectedAddOnIndices.add(index);
                            addonQuantities[index] = 1;
                            selectedAddons.add(addon);
                            log("Addons: $selectedAddons");
                            widget.product.price += addon.price;
                          } else {
                            selectedAddOnIndices.remove(index);
                            addonQuantities[index] = 0;
                            selectedAddons.remove(addon);
                            widget.product.price = defaultPrice;
                          }
                          widget.onAddonsChanged(selectedAddons, widget.product.price);
                        });
                      },
                    ),
                    if (selectedAddOnIndices.contains(index))
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () {
                              setState(() {
                                if (addonQuantities[index]! > 1) {
                                  addonQuantities[index] = addonQuantities[index]! - 1;
                                  widget.product.price -= addon.price;
                                  widget.onAddonsChanged(selectedAddons, widget.product.price);
                                }
                              });
                            },
                          ),
                          Text(addonQuantities[index].toString()),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              setState(() {
                                addonQuantities[index] = addonQuantities[index]! + 1;
                                widget.product.price += addon.price;
                                widget.onAddonsChanged(selectedAddons, widget.product.price);
                              });
                            },
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
