class UserProfile {
  final int id;
  final String fName;
  final String lName;
  final String email;
  final String phone;
  final String? image;
  final int wallet;
  final int status;
  final String? emailVerifiedAt;
  final String? createdAt;
  final String updatedAt;
  final int points;
  final List<dynamic> address;
  final String? bio;
  final String code;
  final String role;
  final String imageLink;
  final String name;
  final String type;

  UserProfile({
    required this.id,
    required this.fName,
    required this.lName,
    required this.email,
    required this.phone,
    this.image,
    required this.wallet,
    required this.status,
    this.emailVerifiedAt,
    this.createdAt,
    required this.updatedAt,
    required this.points,
    required this.address,
    this.bio,
    required this.code,
    required this.role,
    required this.imageLink,
    required this.name,
    required this.type,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      fName: json['f_name'],
      lName: json['l_name'],
      email: json['email'],
      phone: json['phone'],
      image: json['image'],
      wallet: json['wallet'],
      status: json['status'],
      emailVerifiedAt: json['email_verified_at'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      points: json['points'],
      address: List<dynamic>.from(json['address']),
      bio: json['bio'],
      code: json['code'],
      role: json['role'],
      imageLink: json['image_link'],
      name: json['name'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'f_name': fName,
      'l_name': lName,
      'email': email,
      'phone': phone,
      'image': image,
      'wallet': wallet,
      'status': status,
      'email_verified_at': emailVerifiedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'points': points,
      'address': address,
      'bio': bio,
      'code': code,
      'role': role,
      'image_link': imageLink,
      'name': name,
      'type': type,
    };
  }
}
