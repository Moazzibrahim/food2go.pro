import 'package:flutter/material.dart';
import 'package:food2go_app/constants/colors.dart';
import 'package:food2go_app/controllers/product_provider.dart';
import 'package:food2go_app/models/categories/product_model.dart';
import 'package:provider/provider.dart';

class ExtrasBottomSheet extends StatefulWidget {
  const ExtrasBottomSheet({
    super.key,
    this.product,
    required this.selectedVariation,
    required this.onSelectedExtras,
  });
  final Product? product;
  final int selectedVariation;
  final Function(List<Extra>) onSelectedExtras;

  @override
  State<ExtrasBottomSheet> createState() => _ExtrasBottomSheetState();
}

class _ExtrasBottomSheetState extends State<ExtrasBottomSheet> {
  Map<int, int> extraQuantities = {}; // Stores quantity of each extra by index
  Set<int> selectedExtras = {}; // Stores indices of selected extras

  @override
  void initState() {
    super.initState();
    final extraProvider = Provider.of<ProductProvider>(context, listen: false);
    final extras =
        extraProvider.getExtras(widget.product!, widget.selectedVariation);
    for (int i = 0; i < extras.length; i++) {
      extraQuantities[i] = 1; // Initialize all quantities to 1
    }
  }

  void increaseQuantity(int index) {
    setState(() {
      extraQuantities[index] = (extraQuantities[index] ?? 1) + 1;
    });
  }

  void decreaseQuantity(int index) {
    setState(() {
      if (extraQuantities[index]! > 1) {
        extraQuantities[index] = extraQuantities[index]! - 1;
      }
    });
  }

  double getTotalPrice(List<Extra> extras) {
    double totalPrice = 0.0;
    for (var index in selectedExtras) {
      totalPrice += extras[index].price * (extraQuantities[index] ?? 1);
    }
    return totalPrice;
  }

  List<Extra> getSelectedExtras(List<Extra> extras) {
    return selectedExtras.map((index) {
      final extra = extras[index];
      return Extra(
        id: extra.id,
        productId: extra.productId,
        name: extra.name,
        price: extra.price,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, extraProvider, _) {
        final extras =
            extraProvider.getExtras(widget.product!, widget.selectedVariation);
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ...List.generate(
                extras.length,
                (index) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            extras[index].name,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            '+(${extras[index].price})',
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              decreaseQuantity(index);
                            },
                            icon: const Icon(Icons.remove_circle_outline),
                          ),
                          Text(
                            '${extraQuantities[index]}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              increaseQuantity(index);
                            },
                            icon: const Icon(Icons.add_circle_outline),
                          ),
                          Checkbox(
                            value: selectedExtras.contains(index),
                            activeColor: maincolor,
                            onChanged: (value) {
                              setState(() {
                                if (value == true) {
                                  selectedExtras.add(index);
                                } else {
                                  selectedExtras.remove(index);
                                }
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 10),
              Text(
                'Total: \$${getTotalPrice(extras).toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      final selectedExtrasList = getSelectedExtras(
                        extraProvider.getExtras(
                            widget.product!, widget.selectedVariation),
                      );
                      widget.onSelectedExtras(selectedExtrasList);
                      Navigator.pop(
                          context); // Close the bottom sheet after selection
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: maincolor,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Done'),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
