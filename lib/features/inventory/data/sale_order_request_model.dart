import 'package:app/features/inventory/data/retailer_inventory_models.dart';

class SaleOrderRequest {
  final Map<RetailerInventory, int> cartItems;

  SaleOrderRequest({required this.cartItems});

  //get all cart items method
  Map<RetailerInventory, int> getCartItems() {
    return cartItems;
  }

  //calculate sub total method
  double getSubTotal() {
    //calculate by going through each cart item and summing up the price * quantity
    return cartItems.entries.fold(
        0,
        (previousValue, cartItem) =>
            previousValue +
            cartItem.key.productVariants.sellPrice * cartItem.value);
  }

  //calculate tax method
  double getTax() {
    return getSubTotal() * 0.1;
  }

  //calculate admin fee method
  double getAdminFee() {
    return getSubTotal() * 0.1;
  }

  //calculate discount method
  double getDiscount() {
    return getSubTotal() * 0.1;
  }

  //calculate total method
  double getTotal() {
    return getSubTotal() + getTax() + getAdminFee() - getDiscount();
  }
}
