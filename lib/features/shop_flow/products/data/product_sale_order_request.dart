import 'package:app/features/product_service/product.dart';

class SaleOrderRequestForProducts {
  final Map<Product, int> cartItems;

  SaleOrderRequestForProducts({required this.cartItems});

  // Get all cart items method
  Map<Product, int> getCartItems() {
    return cartItems;
  }

  // Calculate subtotal method
  double getSubTotal() {
    // Calculate by going through each cart item and summing up the price * quantity
    return cartItems.entries.fold(
        0,
        (previousValue, element) =>
            previousValue + element.key.price * element.value);
  }

  // Calculate tax method
  double getTax() {
    return getSubTotal() * 0.1;
  }

  // Calculate admin fee method
  double getAdminFee() {
    return getSubTotal() * 0.1;
  }

  // Calculate discount method
  double getDiscount() {
    return getSubTotal() * 0.1;
  }

  // Calculate total method
  double getTotal() {
    return getSubTotal() + getTax() + getAdminFee() - getDiscount();
  }
}
