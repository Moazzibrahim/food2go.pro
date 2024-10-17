class SignUpModel {
  final User? user; // Make User nullable
  final String? token; // Make token nullable

  SignUpModel({
    this.user, // Remove required
    this.token, // Remove required
  });

  factory SignUpModel.fromJson(Map<String, dynamic> json) {
    return SignUpModel(
      user: json['user'] != null ? User.fromJson(json['user']) : null, // Check if user is not null
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user?.toJson(), // Use the safe access operator
      'token': token,
    };
  }
}

class User {
  final String? fName; // Make fName nullable
  final String? lName; // Make lName nullable
  final String? email; // Make email nullable
  final String? phone; // Make phone nullable
  final DateTime? updatedAt; // Make updatedAt nullable
  final DateTime? createdAt; // Make createdAt nullable
  final int? id; // Make id nullable
  final String? image; // Image is already nullable
  final String? role; // Make role nullable
  final String? token; // Make token nullable
  final String? imageLink; // Make imageLink nullable
  final String? name; // Make name nullable
  final String? type; // Make type nullable

  User({
    this.fName, // Remove required
    this.lName, // Remove required
    this.email, // Remove required
    this.phone, // Remove required
    this.updatedAt, // Remove required
    this.createdAt, // Remove required
    this.id, // Remove required
    this.image, // This is already optional
    this.role, // Remove required
    this.token, // Remove required
    this.imageLink, // Remove required
    this.name, // Remove required
    this.type, // Remove required
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      fName: json['f_name'],
      lName: json['l_name'],
      email: json['email'],
      phone: json['phone'],
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null, // Check for null
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null, // Check for null
      id: json['id'],
      image: json['image'],
      role: json['role'],
      token: json['token'],
      imageLink: json['image_link'],
      name: json['name'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'f_name': fName,
      'l_name': lName,
      'email': email,
      'phone': phone,
      'updated_at': updatedAt?.toIso8601String(), // Use the safe access operator
      'created_at': createdAt?.toIso8601String(), // Use the safe access operator
      'id': id,
      'image': image,
      'role': role,
      'token': token,
      'image_link': imageLink,
      'name': name,
      'type': type,
    };
  }
}
