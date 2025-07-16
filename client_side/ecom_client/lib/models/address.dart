class Address {
  String? sId;
  String? userId;
  String? addressType; // 'home', 'work', 'other'
  String? label; // 'Home', 'Work', 'Office', etc.
  String? fullName;
  String? phone;
  String? street;
  String? city;
  String? state;
  String? postalCode;
  String? country;
  bool? isDefault;
  DateTime? createdAt;
  DateTime? updatedAt;

  Address({
    this.sId,
    this.userId,
    this.addressType,
    this.label,
    this.fullName,
    this.phone,
    this.street,
    this.city,
    this.state,
    this.postalCode,
    this.country,
    this.isDefault,
    this.createdAt,
    this.updatedAt,
  });

  Address.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['userId'];
    addressType = json['addressType'];
    label = json['label'];
    fullName = json['fullName'];
    phone = json['phone'];
    street = json['street'];
    city = json['city'];
    state = json['state'];
    postalCode = json['postalCode'];
    country = json['country'];
    isDefault = json['isDefault'];
    createdAt =
        json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null;
    updatedAt =
        json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null;
  }

  Address.fromJsonObject(Object? json) {
    if (json == null) return;
    final Map<String, dynamic> jsonMap = json as Map<String, dynamic>;
    sId = jsonMap['_id'];
    userId = jsonMap['userId'];
    addressType = jsonMap['addressType'];
    label = jsonMap['label'];
    fullName = jsonMap['fullName'];
    phone = jsonMap['phone'];
    street = jsonMap['street'];
    city = jsonMap['city'];
    state = jsonMap['state'];
    postalCode = jsonMap['postalCode'];
    country = jsonMap['country'];
    isDefault = jsonMap['isDefault'];
    createdAt = jsonMap['createdAt'] != null
        ? DateTime.parse(jsonMap['createdAt'])
        : null;
    updatedAt = jsonMap['updatedAt'] != null
        ? DateTime.parse(jsonMap['updatedAt'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['userId'] = userId;
    data['addressType'] = addressType;
    data['label'] = label;
    data['fullName'] = fullName;
    data['phone'] = phone;
    data['street'] = street;
    data['city'] = city;
    data['state'] = state;
    data['postalCode'] = postalCode;
    data['country'] = country;
    data['isDefault'] = isDefault;
    data['createdAt'] = createdAt?.toIso8601String();
    data['updatedAt'] = updatedAt?.toIso8601String();
    return data;
  }

  // Helper method to get formatted address
  String get formattedAddress {
    final parts = <String>[];
    if (street != null && street!.isNotEmpty) parts.add(street!);
    if (city != null && city!.isNotEmpty) parts.add(city!);
    if (state != null && state!.isNotEmpty) parts.add(state!);
    if (postalCode != null && postalCode!.isNotEmpty) parts.add(postalCode!);
    if (country != null && country!.isNotEmpty) parts.add(country!);
    return parts.join(', ');
  }

  // Helper method to get display name
  String get displayName {
    if (label != null && label!.isNotEmpty) {
      return label!;
    }
    return addressType?.toUpperCase() ?? 'Address';
  }

  // Helper method to get icon based on address type
  String get icon {
    switch (addressType?.toLowerCase()) {
      case 'home':
        return '🏠';
      case 'work':
        return '🏢';
      case 'office':
        return '🏢';
      default:
        return '📍';
    }
  }

  // Copy with method for updating
  Address copyWith({
    String? sId,
    String? userId,
    String? addressType,
    String? label,
    String? fullName,
    String? phone,
    String? street,
    String? city,
    String? state,
    String? postalCode,
    String? country,
    bool? isDefault,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Address(
      sId: sId ?? this.sId,
      userId: userId ?? this.userId,
      addressType: addressType ?? this.addressType,
      label: label ?? this.label,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      street: street ?? this.street,
      city: city ?? this.city,
      state: state ?? this.state,
      postalCode: postalCode ?? this.postalCode,
      country: country ?? this.country,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
