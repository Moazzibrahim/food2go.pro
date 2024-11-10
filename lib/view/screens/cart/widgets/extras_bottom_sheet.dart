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
    required this.onSelectedExcludes,
  });
  final Product? product;
  final int selectedVariation;
  final Function(List<Extra>) onSelectedExtras;
  final Function(List<Excludes>) onSelectedExcludes;

  @override
  State<ExtrasBottomSheet> createState() => _ExtrasBottomSheetState();
}

class _ExtrasBottomSheetState extends State<ExtrasBottomSheet> {
  Map<int, int> extraQuantities = {};
  Set<int> selectedExtras = {}; 
  Set<int> selectedExcludes = {}; 

  @override
  void initState() {
    super.initState();
    final productProvider = Provider.of<ProductProvider>(context, listen: false);

    // Get extras for the selected variation
    final extras = productProvider.getExtras(widget.product!, widget.selectedVariation);
    for (int i = 0; i < extras.length; i++) {
      extraQuantities[i] = 1;
    }

    selectedExcludes = widget.product!.excludes.map((e) => e.id,).toSet();
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

  List<Excludes> getSelectedExcludes(List<Excludes> excludes) {
    return selectedExcludes.map((index) {
      final exclude = excludes[index];
      return Excludes(
        id: exclude.id,
        productId: exclude.productId,
        name: exclude.name,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, _) {
        final extras = productProvider.getExtras(widget.product!, widget.selectedVariation);
        final excludes = widget.product!.excludes;

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Extras:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
              const SizedBox(height: 10),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Total: \$${getTotalPrice(extras).toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text('Excludes:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
              const SizedBox(height: 10),
              ...List.generate(
                excludes.length,
                (index) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        excludes[index].name,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      Checkbox(
                        value: selectedExcludes.contains(index),
                        activeColor: maincolor,
                        onChanged: (value) {
                          setState(() {
                            if (value == true) {
                              selectedExcludes.add(index);
                            } else {
                              selectedExcludes.remove(index);
                            }
                          });
                        },
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      final selectedExtrasList = getSelectedExtras(extras);
                      final selectedExcludesList = getSelectedExcludes(excludes);
                      widget.onSelectedExtras(selectedExtrasList);
                      widget.onSelectedExcludes(selectedExcludesList);
                      Navigator.pop(context);
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
