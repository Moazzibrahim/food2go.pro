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
  double price;
  final String discountId;
  final String taxId;
  final List addOns;
  final List<Excludes> excludes;
  final List<Extra> extra;
  final List<Variation> variations;
  final Discount discount;
  final List<AddOns> addons;

  Product(
      {required this.name,
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
      required this.discount,
      required this.addons});

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
      price: json['price'] != null ? json['price'].toDouble() : 0.0,  // Ensure `double`
      discountId: json['discount_id']?.toString() ?? '',
      taxId: json['tax_id']?.toString() ?? '',
      addOns: json['addons'] ?? [],
      excludes: (json['excludes'] as List<dynamic>)
          .map((e) => Excludes.fromJson(e))
          .toList(),
      extra: (json['extra'] as List<dynamic>)
          .map((e) => Extra.fromJson(e))
          .toList(),
      variations: (json['variations'] as List)
          .map((variation) => Variation.fromJson(variation))
          .toList(),
      discount: json['discount'] != null
          ? Discount.fromJson(json['discount'])
          : Discount(name: '', amount: 0.0, type: '', id: 0),
      addons: (json['addons'] as List<dynamic>)
          .map((item) => AddOns.fromJson(item))
          .toList(),
    );

}

class Products {
  final List<dynamic> products;

  Products({required this.products});

  factory Products.fromJson(Map<String, dynamic> json) =>
      Products(products: json['products']);
}

class Discount {
  final String name;
  final double amount;
  final String type;
  final int id;

  Discount({
    required this.name,
    required this.amount,
    required this.type,
    required this.id,
  });

  factory Discount.fromJson(Map<String, dynamic> json) => Discount(
      name: json['name'],
      amount: json['amount'] != null ? json['amount'].toDouble() : 0.0,
      type: json['type'],
      id: json['id'],
    );
}

class AddOns {
  final String name;
  double price;
  final int quantityAdd;
  final int id;

  AddOns(
      {required this.name,
      required this.price,
      required this.quantityAdd,
      required this.id});

  factory AddOns.fromJson(Map<String, dynamic> json) => AddOns(
        name: json['name'],
        price: json['price'].toDouble(),
        quantityAdd: json['quantity_add'],
        id: json['id'],
      );
}

class Excludes {
  final String name;
  final int id;
  final int productId;

  Excludes({required this.name, required this.id,required this.productId});

  factory Excludes.fromJson(Map<String, dynamic> json) => Excludes(
        name: json['name'],
        id: json['id'],
        productId: json['product_id'],
      );
}

class Extra {
  final String name;
  final int id;
  final int productId;
  double price;

  Extra({required this.name, required this.id,required this.productId,required this.price});

  factory Extra.fromJson(Map<String, dynamic> json) => Extra(
        name: json['name'],
        id: json['id'],
        productId: json['product_id'],
        price: json['price'].toDouble(),
      );
}


class Variation {
  final int id;
  final String name;
  final String type;
  final int? min;
  final int? max;
  final int required;
  final int productId;
  final int points;
  final List<Option> options;

  Variation({
    required this.id,
    required this.name,
    required this.type,
    this.min,
    this.max,
    required this.required,
    required this.productId,
    required this.points,
    required this.options,
  });

  factory Variation.fromJson(Map<String, dynamic> json) => Variation(
        id: json['id'],
        name: json['name'],
        type: json['type'],
        min: json['min'],
        max: json['max'],
        required: json['required'],
        productId: json['product_id'],
        points: json['points'],
        options: (json['options'] as List)
            .map((option) => Option.fromJson(option))
            .toList(),
      );
}

class Option {
  final int id;
  final String name;
  double price;
  final int productId;
  final int variationId;
  final List<Extra> extra;

  Option({
    required this.id,
    required this.name,
    required this.price,
    required this.productId,
    required this.variationId,
    required this.extra,
  });

  factory Option.fromJson(Map<String, dynamic> json) => Option(
        id: json['id'],
        name: json['name'],
        price: json['price']?.toDouble() ?? 0.0,
        productId: json['product_id'],
        variationId: json['variation_id'],
        extra: (json['extra'] as List)
            .map((extraItem) => Extra.fromJson(extraItem))
            .toList(),
      );
}