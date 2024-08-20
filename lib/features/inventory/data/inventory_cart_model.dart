import 'package:app/features/inventory/data/retailer_inventory_models.dart';
import 'package:app/services/service_locator.dart';

class InventoryCart {
  final Map<RetailerInventory, int> cartItems = {};

  void addItemQuanity(RetailerInventory item, int quantity) {
    if (cartItems.containsKey(item)) {
      cartItems[item] = cartItems[item]! + quantity;
    } else {
      cartItems[item] = quantity;
    }
  }

  void removeFromCart(RetailerInventory item) {
    cartItems.remove(item);
  }

  Map<RetailerInventory, int> getCartItems() {
    return cartItems;
  }

  int getQuantityOfItem(RetailerInventory item) {
    return cartItems[item]!;
  }

  void decrementItemQuantity(RetailerInventory inventroyItem) {
    if (cartItems.containsKey(inventroyItem)) {
      if (cartItems[inventroyItem]! > 1) {
        cartItems[inventroyItem] = cartItems[inventroyItem]! - 1;
      } else {
        cartItems.remove(inventroyItem);
      }
    }
  }

  void incrementItemQuantity(RetailerInventory inventroyItem) {
    if (cartItems.containsKey(inventroyItem)) {
      cartItems[inventroyItem] = cartItems[inventroyItem]! + 1;
      log.d(
          'incrementItemQuantity for ${inventroyItem.productVariants.variantName}: ${cartItems[inventroyItem]}');
    } else {
      cartItems[inventroyItem] = 1;
    }
  }
}
