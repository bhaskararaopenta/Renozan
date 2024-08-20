import 'dart:convert';

import 'package:app/features/product_service/mock_products_data.dart';

import 'brand.dart';
import 'category.dart';
import 'product.dart';

const mockData = '''
{
  "categories": $mockCategoriesData,
  "distributors": $mockDistributorsData
}
''';

class BusinessConnection {
  final String accountCode;
  final String businessName;
  final String businessImage;
  final List<Brand> brands;

  BusinessConnection({
    required this.accountCode,
    required this.businessName,
    required this.businessImage,
    required this.brands,
  });

  factory BusinessConnection.fromJson(Map<String, dynamic> json) {
    return BusinessConnection(
      accountCode: json['distributorId'],
      businessName: json['name'],
      businessImage: json['distributorImage'],
      brands:
          (json['brands'] as List).map((item) => Brand.fromJson(item)).toList(),
    );
  }
}


Future<List<BusinessConnection>> getAllDistributors() async {
  final Map<String, dynamic> parsedData = jsonDecode(mockData);
  final List<dynamic> distributorsData = parsedData['distributors'];
  return distributorsData
      .map((data) => BusinessConnection.fromJson(data))
      .toList();
}

Future<List<Category>> getCategoriesFilters() async {
  final Map<String, dynamic> parsedData = jsonDecode(mockData);
  final List<dynamic> categoriesData = parsedData['categories'];
  return categoriesData.map((data) => Category.fromJson(data)).toList();
}

Future<List<Brand>> getBrandsForDistributor(String distributorId) async {
  final List<BusinessConnection> distributors = await getAllDistributors();
  final distributor =
      distributors.firstWhere((d) => d.accountCode == distributorId);
  return distributor.brands;
}

Future<List<Product>> getProductsForBrand(int brandId) async {
  final List<BusinessConnection> distributors = await getAllDistributors();
  for (final distributor in distributors) {
    for (final brand in distributor.brands) {
      if (brand.id == brandId) {
        return brand.products;
      }
    }
  }
  throw Exception('Brand not found');
}

Future<Product> getProductDetails(String productId) async {
  final List<BusinessConnection> distributors = await getAllDistributors();
  for (final distributor in distributors) {
    for (final brand in distributor.brands) {
      for (final product in brand.products) {
        if (product.name == productId) {
          return product;
        }
      }
    }
  }
  throw Exception('Product not found');
}

Future<Brand> getBrandDetails(int brandId) async {
  final List<BusinessConnection> distributors = await getAllDistributors();
  for (final distributor in distributors) {
    for (final brand in distributor.brands) {
      if (brand.id == brandId) {
        return brand;
      }
    }
  }
  throw Exception('Product not found');
}
