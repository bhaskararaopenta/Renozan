import 'package:app/template/page_with_api_data/model.dart';
import 'package:app/template/page_with_api_data/repository_interface.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductsRepositoryImpl implements ProductsRepository {
  final http.Client client;

  ProductsRepositoryImpl(this.client);

  @override
  Future<List<Product>> fetchProducts() async {
    final response = await client.get(Uri.parse('https://dummyjson.com/products'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['products'] as List).map((item) => Product.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }
}
