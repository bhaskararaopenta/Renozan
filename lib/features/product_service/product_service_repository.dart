import 'package:app/core/exceptions.dart';
import 'package:app/features/product_service/brand.dart';
import 'package:app/features/product_service/business_connection_models.dart';
import 'package:app/features/product_service/category.dart';
import 'package:app/features/product_service/product.dart';
import 'package:app/services/api_service.dart';
import 'package:app/services/secure_storage_service.dart';

abstract class ProductServiceRepository {
  Future<List<BusinessConnection>> getDistributors();
  Future<List<Category>> getCategories();
  Future<List<Brand>> getBrandsOfDistributor(String distributorCode);
  Future<List<Product>> getProductsOfBrand(int brandId);
  Future<Product> getProductDetails(String productId);
  Future<Brand> getBrand(int brandId);
}

class ProductServiceRepositoryImpl implements ProductServiceRepository {
  final ApiService apiService;
  final SecureStorageService secureStorageService;

  // Cache to store the API response data
  Map<String, dynamic>? cachedResponseData;

  ProductServiceRepositoryImpl({
    required this.apiService,
    required this.secureStorageService,
  });

  @override
  Future<List<BusinessConnection>> getDistributors() async {
    final response = await apiService.performGetRequest(
      'users/account/account-list',
      {},
    );

    // Extract the list of accounts from the response
    final List<dynamic> accountList = response['data']['list'];

    // Transform it into BusinessConnection objects
    final List<BusinessConnection> distributors =
        accountList.map((accountJson) {
      return BusinessConnection.fromJson(accountJson);
    }).toList();

    return distributors; // Add a return statement
  }

  // Fetch and cache data when getBrandsOfDistributor is called
  @override
  Future<List<Brand>> getBrandsOfDistributor(String distributorCode) async {
    if (cachedResponseData == null) {
      final response = await apiService.performGetRequest(
        'products/retailer/distributorInventory',
        {'distributorCode': distributorCode},
      );
      cachedResponseData = response['data']; // Cache the response data
    }

    // Extract brands from cached data
    final List<dynamic> brandsJson =
        cachedResponseData!['details']['brandList'];
    return brandsJson.map((brandJson) => Brand.fromJson(brandJson)).toList();
  }

  @override
  Future<List<Category>> getCategories() async {
    // Use cached data if available
    if (cachedResponseData == null) {
      throw AppException(
          'No data available. Call getBrandsOfDistributor first.');
    }

    final List<dynamic> categoriesJson =
        cachedResponseData!['details']['categories'];
    return categoriesJson
        .map((categoryJson) => Category.fromJson(categoryJson))
        .toList();
  }

  @override
  Future<List<Product>> getProductsOfBrand(int brandId) async {
    // Use cached data if available
    if (cachedResponseData == null) {
      throw AppException(
          'No data available. Call getBrandsOfDistributor first.');
    }

    final List<dynamic> brandsJson =
        cachedResponseData!['details']['brandList'];
    final brand = brandsJson
        .firstWhere((brandJson) => brandJson['id'].toString() == brandId);
    final List<dynamic> productsJson = brand['products'];
    return productsJson
        .map((productJson) => Product.fromJson(productJson))
        .toList();
  }

  @override
  Future<Product> getProductDetails(String productId) async {
    // Use cached data if available
    if (cachedResponseData == null) {
      throw AppException(
          'No data available. Call getBrandsOfDistributor first.');
    }

    final List<dynamic> brandsJson =
        cachedResponseData!['details']['brandList'];
    for (final brand in brandsJson) {
      for (final product in brand['products']) {
        if (product['id'].toString() == productId) {
          return Product.fromJson(product);
        }
      }
    }
    throw AppException('Product not found');
  }

  @override
  Future<Brand> getBrand(int brandId) async {
    // Use cached data if available
    if (cachedResponseData == null) {
      throw AppException(
          'No data available. Call getBrandsOfDistributor first.');
    }

    final List<dynamic> brandsJson =
        cachedResponseData!['details']['brandList'];
    final brandJson = brandsJson
        .firstWhere((brandJson) => brandJson['id'].toString() == brandId);
    return Brand.fromJson(brandJson);
  }
}
