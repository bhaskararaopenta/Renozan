import 'dart:math';

class MockRetailerInventory {
  final int productId;
  final int stock;
  final String retailerCode;
  final int minStockLevel;
  final int maxStockLevel;
  final int defaultReOrderQuantity;

  final String productName;
  final String distributorName;
  final String productImage;
  final double price;

  MockRetailerInventory({
    required this.productId,
    required this.stock,
    required this.retailerCode,
    required this.minStockLevel,
    required this.maxStockLevel,
    required this.defaultReOrderQuantity,
    required this.productName,
    required this.distributorName,
    required this.productImage,
    required this.price,
  });

  factory MockRetailerInventory.fromJson(Map<String, dynamic> json) {
    return MockRetailerInventory(
      productId: json['productId'],
      stock: json['stock'],
      retailerCode: json['retailerCode'],
      minStockLevel: json['minStockLevel'],
      maxStockLevel: json['maxStockLevel'],
      defaultReOrderQuantity: json['defaultReOrderQuantity'],
      productName: json['productName'],
      distributorName: json['distributorName'],
      productImage: json['productImage'],
      price: json['price'].toDouble(),
    );
  }

  //create dummy json data for testing. create a list of RetailerInventoryItem about 20
  static List<MockRetailerInventory> dummyData() {
    return List.generate(
      20,
      (index) => MockRetailerInventory(
        productId: index,
        stock: Random().nextInt(20),
        retailerCode: 'RETAILER_CODE_${Random().nextInt(100)}',
        minStockLevel: 10, //Random().nextInt(100),
        maxStockLevel: 20, //Random().nextInt(100),
        defaultReOrderQuantity: 10, // Random().nextInt(100),
        productName: 'Product Name $index',
        distributorName: 'Distributor Name $index',
        productImage: 'assets/images/lasco.png',
        price: Random().nextInt(100).toDouble(),
      ),
    );
  }

  bool isLowOnStock() {
    return stock < minStockLevel;
  }

  bool isSuperLowOnStock() {
    return stock < (minStockLevel * 0.3);
  }

  int getReorderQuantity() {
    return defaultReOrderQuantity - stock;
  }

  int getHowMuchLowOnStock() {
    return minStockLevel - stock;
  }
}
