class BannerCategory {
  final int id;
  final String name;
  final String image;
  final String? bannerImage;
  final int? categoryId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int status;
  final int priority;
  final int active;
  final String imageLink;
  final String bannerLink;

  BannerCategory({
    required this.id,
    required this.name,
    required this.image,
    this.bannerImage,
    this.categoryId,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
    required this.priority,
    required this.active,
    required this.imageLink,
    required this.bannerLink,
  });
  factory BannerCategory.fromJson(Map<String, dynamic> json) {
    return BannerCategory(
      id: json['id'] ?? 0, // Use a default value if null
      name: json['name'] ?? '', // Default to empty string if name is null
      image: json['image'] ?? '', // Default to empty string if image is null
      bannerImage:
          json['banner_image'] ?? '', // Default to empty string if null
      categoryId: json['category_id'], // This can be nullable
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ??
          DateTime.now(), // Default to now if parse fails
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ??
          DateTime.now(), // Default to now if parse fails
      status: json['status'] ?? '', // Default to empty string if status is null
      priority: json['priority'] ?? 0, // Default to 0 if null
      active: json['active'] ?? false, // Default to false if null
      imageLink: json['image_link'] ?? '', // Default to empty string if null
      bannerLink: json['banner_link'] ?? '', // Default to empty string if null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'banner_image': bannerImage,
      'category_id': categoryId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'status': status,
      'priority': priority,
      'active': active,
      'image_link': imageLink,
      'banner_link': bannerLink,
    };
  }
}

class AppBanner {
  final int id;
  final String image;
  final int order;
  final int? categoryId;
  final int? productId;
  final int? dealId;
  final int translationId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String imageLink;
  final BannerCategory? category;

  AppBanner({
    required this.id,
    required this.image,
    required this.order,
    this.categoryId,
    this.productId,
    this.dealId,
    required this.translationId,
    required this.createdAt,
    required this.updatedAt,
    required this.imageLink,
    this.category,
  });

  factory AppBanner.fromJson(Map<String, dynamic> json) {
    return AppBanner(
      id: json['id'] ?? 0, // Default to 0 if id is null
      image: json['image'] ?? '', // Default to empty string if image is null
      order: json['order'] ?? 0, // Default to 0 if order is null
      categoryId: json['category_id'], // This can remain nullable
      productId: json['product_id'], // This can remain nullable
      dealId: json['deal_id'], // This can remain nullable
      translationId: json['translation_id'] ?? 0, // Default to 0 if null
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ??
          DateTime.now(), // Default to now if parse fails
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ??
          DateTime.now(), // Default to now if parse fails
      imageLink: json['image_link'] ??
          '', // Default to empty string if image_link is null
      category: json['category_banner'] != null
          ? BannerCategory.fromJson(json['category_banner'])
          : null,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': image,
      'order': order,
      'category_id': categoryId,
      'product_id': productId,
      'deal_id': dealId,
      'translation_id': translationId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'image_link': imageLink,
      'category': category?.toJson(),
    };
  }
}
