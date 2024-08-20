import 'package:app/core/base_provider.dart';
import 'package:app/core/exceptions.dart';
import 'package:app/features/inventory/data/inventory_cart_model.dart';
import 'package:app/features/inventory/data/inventory_repo.dart';
import 'package:app/features/inventory/data/retailer_inventory_models.dart';
import 'package:app/features/inventory/data/sale_order_request_model.dart';
import 'package:app/services/service_locator.dart';

class InventoryViewModel extends BaseProvider {
  final RetailerInventoryRepository retailerInventoryRepository;
  InventoryViewModel(this.retailerInventoryRepository) {
    log.d('Creating InventoryViewModel');
  }

  final InventoryCart cart = InventoryCart();
  late SaleOrderRequest _saleOrderRequest;
  List<RetailerInventory> _allInventoryItems = [];
  List<RetailerInventory> _lowStockInventoryItems = [];

  List<RetailerInventory> currentListItems() {
    if (_isCard1Selected) {
      return _allInventoryItems;
    } else {
      return _lowStockInventoryItems;
    }
  }

  int allInventoryItemsCount() {
    return _allInventoryItems.length;
  }

  int getLowStockCount() {
    return _lowStockInventoryItems.length;
  }

  bool _isCard1Selected = true;

  bool get isCard1Selected => _isCard1Selected;

  void selectCard1() {
    _isCard1Selected = true;
    notifyListeners();
  }

  void selectCard2() {
    _isCard1Selected = false;
    notifyListeners();
  }

  Future<void> loadInventoryItems() async {
    setState(ViewState.loading);
    try {
      _allInventoryItems =
          await retailerInventoryRepository.getAllInventoryItems();
      _lowStockInventoryItems =
          await retailerInventoryRepository.getLowStockInventoryItems();

      setState(ViewState.done);
    } catch (e) {
      if (e is AppException) {
        handleException(e);
      } else {
        //set current screen specific error message or use a generic one
        setStateToErrorWithMessage('Failed to load details');
      }
    }
  }

  void addItemToCart(RetailerInventory item, int quantity) {
    cart.addItemQuanity(item, quantity);
    notifyListeners();
  }

  void addAllItemsToCart(Map<RetailerInventory, int> itemsWithQuantities) {
    itemsWithQuantities.forEach((item, quantity) {
      addItemToCart(item, quantity);
    });
    notifyListeners();
  }

  bool isItemInCart(RetailerInventory item) {
    if (getCartItems().isEmpty) {
      return false;
    }
    return getCartItems().keys.contains(item);
  }

  void removeItemFromCart(RetailerInventory item) {
    cart.removeFromCart(item);
    notifyListeners();
  }

  // Method to get cart items
  Map<RetailerInventory, int> getCartItems() {
    return cart.getCartItems();
  }

  // method to get quantity of an item in the cart
  int getQuantityOfItem(RetailerInventory item) {
    return cart.getQuantityOfItem(item);
  }

  void decrementItemQuantity(RetailerInventory inventroyItem) {
    cart.decrementItemQuantity(inventroyItem);
    notifyListeners();
  }

  void incrementItemQuantity(RetailerInventory inventroyItem) {
    log.d('viewModel: incrementItemQuantity');
    cart.incrementItemQuantity(inventroyItem);
    notifyListeners();
  }

  bool isItemLowOnStock(RetailerInventory inventroyItem) {
    return inventroyItem.isLowOnStock();
  }

  void createSaleOrderRequest() {
    _saleOrderRequest = SaleOrderRequest(cartItems: cart.getCartItems());
  }

  SaleOrderRequest getSaleOrderRequest() {
    return _saleOrderRequest;
  }

  void refillAllLowStock() {
    for (var item in _lowStockInventoryItems) {
      cart.removeFromCart(item);
      cart.addItemQuanity(item, item.getReorderQuantity());
    }
    notifyListeners();
  }
}
