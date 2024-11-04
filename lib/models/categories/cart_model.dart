import 'package:food2go_app/models/categories/product_model.dart';

class CartItem {
  final Product product;
  final List<Extra> extra;
  final List<Option> options;


  CartItem({required this.product, required this.extra, required this.options});

}