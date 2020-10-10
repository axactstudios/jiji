import 'package:jiji/models/photo.dart';

class MyProduct {
  MyProduct({
    this.views,
    this.likes,
    this.id,
    this.name,
    this.description,
    this.price,
    this.title,
    this.condition,
    this.city,
    this.category,
    this.subCategory,
    this.photo,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  int views;
  List<dynamic> likes;
  String id;
  String name;
  String description;
  String price;
  String title;
  String condition;
  String city;
  String category;
  String subCategory;
  List<Photo> photo;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  factory MyProduct.fromJson(Map<String, dynamic> json) => MyProduct(
        views: json["views"],
        likes: List<dynamic>.from(json["likes"].map((x) => x)),
        id: json["_id"],
        name: json["name"],
        description: json["description"],
        price: json["price"],
        title: json["title"],
        condition: json["condition"],
        city: json["city"],
        category: json["category"],
        subCategory: json["subCategory"],
        photo: List<Photo>.from(json["photo"].map((x) => Photo.fromJson(x))),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );
}
