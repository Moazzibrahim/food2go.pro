import 'package:flutter/material.dart';
import 'package:food2go_app/constants/colors.dart';
import 'package:food2go_app/controllers/product_provider.dart';
import 'package:food2go_app/models/categories/product_model.dart';
import 'package:provider/provider.dart';

class ExtrasBottomSheet extends StatefulWidget {
  const ExtrasBottomSheet(
      {super.key, this.product, required this.selectedVariation});
  final Product? product;
  final int selectedVariation;

  @override
  State<ExtrasBottomSheet> createState() => _ExtrasBottomSheetState();
}

class _ExtrasBottomSheetState extends State<ExtrasBottomSheet> {
  Set<int> selectedExtras = {};

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, extraProvider, _) {
        final extras =
            extraProvider.getExtras(widget.product!, widget.selectedVariation);
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: List.generate(
              extras.length,
              (index) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(extras[index].name,style: const TextStyle(fontSize: 18,fontWeight: FontWeight.w600),),
                        const SizedBox(width: 10,),
                        Text('+(${extras[index].price.toString()})',style: const TextStyle(color: Colors.grey),)
                      ],
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
                );
              },
            ),
          ),
        );
      },
    );
  }
}
