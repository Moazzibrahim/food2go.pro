class Category {
  final String name;
  final String imageLink;
  final int id;
  final int status;
  final int activity;
  final int priority;

  Category(
      {required this.name,
      required this.imageLink,
      required this.id,
      required this.status,
      required this.activity,
      required this.priority});

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        name: json['name'],
        imageLink: json['image_link'],
        id: json['id'],
        status: json['status'],
        activity: json['active'],
        priority: json['priority'],
      );
}

class Categories {
  final List<dynamic> categories;

  Categories({required this.categories});

  factory Categories.fromJson(Map<String, dynamic> json) => Categories(categories: json['categories']);
}
