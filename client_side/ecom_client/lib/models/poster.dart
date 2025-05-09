class Poster {
  String? sId;
  String? posterName;
  String? imageUrl;
  String? productId;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Poster(
      {this.sId,
        this.posterName,
        this.imageUrl,
        this.createdAt,
        this.updatedAt,
        this.productId,
        this.iV});

  Poster.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    posterName = json['posterName'];
    imageUrl = json['imageUrl'];
    productId = json['productId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['posterName'] = this.posterName;
    data['imageUrl'] = this.imageUrl;
    data['createdAt'] = this.createdAt;
    data['productId'] = this.productId;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}