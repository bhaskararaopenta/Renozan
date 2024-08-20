import 'package:app/features/product_service/product.dart';

class Brand {
  final int id;
  final String name;
  final String image;
  final List<int> categoryIds;
  final List<Product> products;
  final int retailerStock;

  Brand({
    required this.id,
    required this.name,
    required this.image,
    required this.categoryIds,
    required this.products,
    required this.retailerStock,
  });

  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(
      id: json['id'],
      name: json['name'],
      image: json['image'] ?? "",
      categoryIds: List<int>.from(json['categoryIds']),
      products: (json['products'] as List)
          .map((productJson) => Product.fromJson(productJson))
          .toList(),
      retailerStock: json['retailerStock'],
    );
  }
}

