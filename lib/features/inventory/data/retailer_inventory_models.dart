class RetailerInventory {
  final int id;
  final int variantId;
  final int productId;
  final String? description; // Made nullable
  final String? location; // Made nullable
  final int stock;
  final String? retailerCode; // Made nullable
  final String? distributorCode; // Made nullable
  final int minStockLevel;
  final int maxStockLevel;
  final int reOrderLevel;
  final bool? isLowstock; // Made nullable
  final DateTime? createdAt; // Made nullable
  final DateTime? updatedAt; // Made nullable
  final ProductVariants productVariants;
  final List<RetailerStock>? retailerStock; // Made nullable


  RetailerInventory({
    required this.id,
    required this.variantId,
    required this.productId,
    this.description, // Removed required
    this.location, // Removed required
    required this.stock,
    this.retailerCode, // Removed required
    this.distributorCode, // Removed required
    required this.minStockLevel,
    required this.maxStockLevel,
    required this.reOrderLevel,
    this.isLowstock, // Removed required
    this.createdAt, // Removed required
    this.updatedAt, // Removed required
    required this.productVariants,
    this.retailerStock, // Removed required
  });

factory RetailerInventory.fromJson(Map<String, dynamic> json) {
  return RetailerInventory(
    id: json['id'],
    variantId: json['variantId'],
    productId: json['productId'],
    description: json['description'] ?? 'No description', // Default value if null
    location: json['location'] ?? 'Unknown location', // Default value if null
    stock: json['stock'],
    retailerCode: json['retailerCode'] ?? 'No code', // Default value if null
    distributorCode: json['distributorCode'] ?? 'No code', // Default value if null
    minStockLevel: json['minStockLevel'],
    maxStockLevel: json['maxStockLevel'],
    reOrderLevel: json['reOrderLevel'],
    isLowstock: json['isLowstock'] ?? false, // Default value if null
    createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(), // Default value if null
    updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : DateTime.now(), // Default value if null
    productVariants: ProductVariants.fromJson(json['productVariants']),
    retailerStock: json['retailerStock'] != null ? (json['retailerStock'] as List).map((e) => RetailerStock.fromJson(e)).toList() : [], // Default value if null
  );
}
  bool isLowOnStock() {
    return stock < minStockLevel;
  }

  bool isSuperLowOnStock() {
    return stock < (minStockLevel * 0.3);
  }

  int getReorderQuantity() {
    return reOrderLevel - stock;
  }

  int getHowMuchLowOnStock() {
    return minStockLevel - stock;
  }
}

class ProductVariants {
  final String variantName;
  final String upc;
  final String distributorCode;
  final String variantImage;
  final String barcode;
  final double sellPrice;
  final double buyPrice;

  ProductVariants({
    required this.variantName,
    required this.upc,
    required this.distributorCode,
    required this.variantImage,
    required this.barcode,
    required this.sellPrice,
    required this.buyPrice,
  });

  factory ProductVariants.fromJson(Map<String, dynamic> json) {
    return ProductVariants(
      variantName: json['variantName'],
      upc: json['UPC'],
      distributorCode: json['distributorCode'],
      variantImage: json['variantImage'],
      barcode: json['barcode'] ?? '',
      sellPrice: json['sellprice'].toDouble(),
      buyPrice: json['buyprice'].toDouble(),
    );
  }
}

class RetailerStock {
  final int id;
  final int retailerInventoryId;
  final int stockAdded;
  final int operationType;
  final int quantityAtInventory;
  final dynamic orderReference;
  final double buyPrice;
  final double sellPrice;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int? productVariantsId;

  RetailerStock({
    required this.id,
    required this.retailerInventoryId,
    required this.stockAdded,
    required this.operationType,
    required this.quantityAtInventory,
    this.orderReference,
    required this.buyPrice,
    required this.sellPrice,
    required this.createdAt,
    required this.updatedAt,
    this.productVariantsId,
  });

  factory RetailerStock.fromJson(Map<String, dynamic> json) {
    return RetailerStock(
      id: json['id'],
      retailerInventoryId: json['retailerInventoryId'],
      stockAdded: json['stockAdded'],
      operationType: json['operationType'],
      quantityAtInventory: json['quantityAtInventory'],
      orderReference: json['orderReference'],
      buyPrice: json['buyPrice'].toDouble(),
      sellPrice: json['sellPrice'].toDouble(),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      productVariantsId: json['productVariantsId'],
    );
  }
}

class RetailerInventoryResponse {
  final bool success;
  final String message;
  final List<RetailerInventory> list;
  final int stockCount;

  RetailerInventoryResponse({
    required this.success,
    required this.message,
    required this.list,
    required this.stockCount,
  });

  factory RetailerInventoryResponse.fromJson(Map<String, dynamic> json) {
    return RetailerInventoryResponse(
      success: json['success'],
      message: json['message'],
      list: (json['data']['list'] as List)
          .map((e) => RetailerInventory.fromJson(e))
          .toList(),
      stockCount: json['data']['stockCount'],
    );
  }
}
