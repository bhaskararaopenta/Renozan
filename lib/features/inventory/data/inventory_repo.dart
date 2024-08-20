import 'package:app/features/inventory/data/retailer_inventory_models.dart';
import 'package:app/services/api_service.dart';

class RetailerInventoryRepository {
  final ApiService apiService;

  RetailerInventoryRepository({required this.apiService});

  List<RetailerInventory> _inventoryItems = [];

  List<RetailerInventory> get inventoryItems => _inventoryItems;


  Future<List<RetailerInventory>> getAllInventoryItems() async {
    final response = await apiService.performGetRequest(
      'products/retailer/inventory',
      {},
    );

    final inventoryResponse = RetailerInventoryResponse.fromJson(response);
    _inventoryItems = inventoryResponse.list;
    return _inventoryItems;
  }

  Future<List<RetailerInventory>> getLowStockInventoryItems() async {
    return _inventoryItems
        .where((element) => element.stock < element.minStockLevel)
        .toList();
  }
}
