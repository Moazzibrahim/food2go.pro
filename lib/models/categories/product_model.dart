class Product {
  final String name;
  final int id;
  final String description;
  final String image;
  final int categoryId;
  final String? subCategoryId;
  final String productTimeStatus;
  final String? from;
  final String? to;
  final int numOfStock;
  final int status;
  final int reccomended;
  final bool inStock;
  bool isFav;
  final double price;
  final String discountId;
  final String taxId;
  final List addOns;
  final List excludes;
  final List extra;
  final List variations;

  Product({
    required this.name,
    required this.id,
    required this.description,
    required this.image,
    required this.categoryId,
    required this.subCategoryId,
    required this.productTimeStatus,
    required this.from,
    required this.to,
    required this.numOfStock,
    required this.status,
    required this.reccomended,
    required this.inStock,
    required this.isFav,
    required this.price,
    required this.discountId,
    required this.taxId,
    required this.addOns,
    required this.excludes,
    required this.extra,
    required this.variations,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
      name: json['name'] ?? '',
      id: json['id'].toInt(),
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      categoryId: json['category_id'].toInt(),
      subCategoryId: json['sub_category_id']?.toString(),
      productTimeStatus: json['product_time_status'].toString(),
      from: json['from'] ?? '',
      to: json['to'] ?? '',
      numOfStock: json['number']?.toInt() ?? 0,
      status: json['status'].toInt(),
      reccomended: json['recommended'].toInt(),
      inStock: json['in_stock'] ?? false,
      isFav: json['favourite'] ?? false,
      price: json['price']?.toDouble() ?? 0.0,
      discountId: json['discount_id']?.toString() ?? '',
      taxId: json['tax_id']?.toString() ?? '',
      addOns: json['addons'] ?? [],
      excludes: json['excludes'] ?? [],
      extra: json['extra'] ?? [],
      variations: json['variations'] ?? [],
    );

}

class Products {
  final List<dynamic> products;

  Products({required this.products});

  factory Products.fromJson(Map<String,dynamic> json)=> Products(products: json['products']);
}