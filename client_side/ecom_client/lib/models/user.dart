class User {
  String? sId;
  String? name;
  String? email;
  String? phone;
  String? image;
  int? role;
  String? status;
  String? currentAddress;
  String? dateOfBirth;
  String? gender;
  String? createdAt;
  String? updatedAt;

  User({
    this.sId,
    this.name,
    this.email,
    this.phone,
    this.gender,
    this.dateOfBirth,
    this.currentAddress,
    this.image,
    this.role,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  /// Factory method to create a `User` object from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      sId: json['_id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      gender: json['gender'],
      dateOfBirth: json['dateOfBirth'],
      currentAddress: json['currentAddress'],
      image: json['image'],
      role: json['role'],
      status: json['status'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  /// Converts the `User` object to JSON format
  Map<String, dynamic> toJson() {
    return {
      '_id': sId,
      'name': name,
      'email': email,
      'phone': phone,
      'gender': gender,
      'dateOfBirth': dateOfBirth,
      'currentAddress': currentAddress,
      'image': image,
      'role': role,
      'status': status,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
