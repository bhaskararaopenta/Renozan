import 'package:app/template/page_with_api_data/model.dart';

abstract class ProductsRepository {
  Future<List<Product>> fetchProducts();
}
