import 'package:app/features/product_service/product.dart';

class ProductsCart {
  final Map<Product, int> _cartItems = {};

  // Add or update item quantity in the cart
  void addItemQuantity(Product product, int quantity) {
    if (_cartItems.containsKey(product)) {
      _cartItems[product] = _cartItems[product]! + quantity;
    } else {
      _cartItems[product] = quantity;
    }
  }

  // Remove item from the cart
  void removeFromCart(Product product) {
    _cartItems.remove(product);
  }

  // Get all items in the cart
  Map<Product, int> getCartItems() {
    return _cartItems;
  }


  // Get quantity of a specific item
  int getQuantityOfItem(Product product) {
    return _cartItems[product] ?? 0;
  }

  // Decrement item quantity in the cart
  void decrementItemQuantity(Product product) {
    if (_cartItems.containsKey(product)) {
      if (_cartItems[product]! > 1) {
        _cartItems[product] = _cartItems[product]! - 1;
      } else {
        _cartItems.remove(product);
      }
    }
  }

  // Increment item quantity in the cart
  void incrementItemQuantity(Product product) {
    if (_cartItems.containsKey(product)) {
      _cartItems[product] = _cartItems[product]! + 1;
    } else {
      _cartItems[product] = 1;
    }
  }
}
