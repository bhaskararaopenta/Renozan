// product.dart
class Product {
  final String name;
  final String productImage;
  final int categoryId; // Added categoryId field
  final List<ProductVariant> productVariants;
  final List<DistributorInventory> distributorInventory;
  final List<RetailerInventory> retailerInventory;

  Product({
    required this.name,
    required this.productImage,
    required this.categoryId, // Added categoryId to constructor
    required this.productVariants,
    required this.distributorInventory,
    required this.retailerInventory,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'],
      productImage: json['productImage'],
      categoryId: json['categoryId'], // Added categoryId initialization
      productVariants: (json['ProductVariants'] as List)
          .map((variantJson) => ProductVariant.fromJson(variantJson))
          .toList(),
      distributorInventory: (json['DistributorInventory'] as List)
          .map((inventoryJson) => DistributorInventory.fromJson(inventoryJson))
          .toList(),
      retailerInventory: (json['RetailerInventory'] as List)
          .map((inventoryJson) => RetailerInventory.fromJson(inventoryJson))
          .toList(),
    );
  }

  double get price => productVariants.first.sellPrice;

  String get title => productVariants.first.variantName;

  String get image => productImage;

  String get description => name;
}

// product_variant.dart
class ProductVariant {
  final String variantName;
  final String upc;
  final double sellPrice;
  final double buyPrice;

  ProductVariant({
    required this.variantName,
    required this.upc,
    required this.sellPrice,
    required this.buyPrice,
  });

  factory ProductVariant.fromJson(Map<String, dynamic> json) {
    return ProductVariant(
      variantName: json['variantName'],
      upc: json['UPC'],
      sellPrice: json['sellprice'].toDouble(),
      buyPrice: json['buyprice'].toDouble(),
    );
  }
}

// distributor_inventory.dart
class DistributorInventory {
  final int stock;
  final int minStockLevel;
  final int maxStockLevel;

  DistributorInventory({
    required this.stock,
    required this.minStockLevel,
    required this.maxStockLevel,
  });

  factory DistributorInventory.fromJson(Map<String, dynamic> json) {
    return DistributorInventory(
      stock: json['stock'],
      minStockLevel: json['minStockLevel'],
      maxStockLevel: json['maxStockLevel'],
    );
  }
}

// retailer_inventory.dart
class RetailerInventory {
  final String retailerCode;
  final int stock;
  final bool isLowStock;

  RetailerInventory({
    required this.retailerCode,
    required this.stock,
    required this.isLowStock,
  });

  factory RetailerInventory.fromJson(Map<String, dynamic> json) {
    return RetailerInventory(
      retailerCode: json['retailerCode'],
      stock: json['stock'],
      isLowStock: json['isLowstock'],
    );
  }
}
