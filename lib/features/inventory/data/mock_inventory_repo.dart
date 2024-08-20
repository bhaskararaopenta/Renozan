import 'package:app/features/inventory/data/mock_inventory_item_model.dart';

class MockRetailerInventoryRepository {
  final List<MockRetailerInventory> _inventoryItems =
      MockRetailerInventory.dummyData();

  List<MockRetailerInventory> get inventoryItems => _inventoryItems;

  Future<List<MockRetailerInventory>> getAllInventoryItems() async {
    await Future.delayed(const Duration(seconds: 2));
    return _inventoryItems;
  }

  Future<List<MockRetailerInventory>> getLowStockInventoryItems() async {
    return _inventoryItems
        .where((element) => element.stock < element.minStockLevel)
        .toList();
  }
}
