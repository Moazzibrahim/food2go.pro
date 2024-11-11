import 'package:food2go_app/models/categories/product_model.dart';

class CartItem {
  final Product product;
  final List<Extra> extra;
  final List<Option> options;
  final List<AddOns> addons;
  final List<Excludes> excludes;

  CartItem(
      {required this.product,
      required this.extra,
      required this.options,
      required this.addons,
      required this.excludes,
      });
}

class Cart {
  final List<CartItem> cartItems;
  final double totalPrice;
  final String date;
  final int branchId;
  final String paymentStatus;
  final double totalTax;
  final int addressId;
  final String orderType;
  final String paidBy;

  Cart(
      {required this.cartItems,
      required this.totalPrice,
      required this.date,
      required this.branchId,
      required this.paymentStatus,
      required this.totalTax,
      required this.addressId,
      required this.orderType,
      required this.paidBy});
}
