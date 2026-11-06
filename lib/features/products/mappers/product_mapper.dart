import 'package:flutter_products/config/config.dart';
import 'package:flutter_products/features/auth/auth.dart';
import 'package:flutter_products/features/products/products.dart';

class ProductMapper {
  static Product jsonToEntity(Map<String, dynamic> json) => Product(
    id: json['id'],
    title: json['title'],
    price: double.parse(json['price'].toString()),
    description: json['description'],
    slug: json['slug'],
    stock: json['stock'],
    sizes: List<String>.from(json['sizes'].map((size) => size)),
    gender: json['gender'],
    tags: List<String>.from(json['tags'].map((tag) => tag)),
    images: List<String>.from(
      json['images'].map(
        (image) => image.startsWith('http')
            ? image
            : '${Environment.apiURL}/files/product/$image',
      ),
    ),
    user: UserMapper.userJsonToEntity(json['user']),
  );
}
