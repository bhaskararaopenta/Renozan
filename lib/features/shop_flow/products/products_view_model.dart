import 'package:app/core/base_provider.dart';
import 'package:app/core/exceptions.dart';
import 'package:app/features/product_service/brand.dart';
import 'package:app/features/product_service/category.dart';
import 'package:app/features/product_service/product.dart';
import 'package:app/features/product_service/product_service_repository.dart';
import 'package:app/features/shop_flow/products/data/product_sale_order_request.dart';
import 'package:app/features/shop_flow/products/data/products_cart_model.dart';
import 'package:app/services/service_locator.dart';

enum PaymentType {
  Cash,
  Credit,
}

class BrandProductsViewModel extends BaseProvider {
  BrandProductsViewModel(this.productServiceRepository) {
    log.d('Creating ProductsViewModel');
  }

  final ProductsCart productsCart = ProductsCart();
  late SaleOrderRequestForProducts _saleOrderRequestForProducts;

  final ProductServiceRepository productServiceRepository;

  late Brand _brand;
  List<Product> _products = [];

  Brand get brand => _brand;
  List<Product> get products => _products;

  late Product _selectedProduct;
  Product get selectedProduct => _selectedProduct;

  List<Category> _filtersData = [];
  List<Category> get filtersData => _filtersData;

  void selectProduct(Product product) {
    _selectedProduct = product;
    notifyListeners();
  }

  bool _isChecked = false;

  PaymentType _paymentType = PaymentType.Cash;
  PaymentType get paymentType => _paymentType;
  bool get isChecked => _isChecked;

  void setPaymentType(PaymentType value) {
    _paymentType = value;
    notifyListeners();
  }

  void setDefaultCurrency(bool value) {
    _isChecked = value;
    notifyListeners();
  }

  Future<void> fetchBrandDetailsAndProducts(int brandId) async {
    setState(ViewState.loading);
    try {
      //get categories
      _products = await productServiceRepository.getProductsOfBrand(brandId);
      // Assuming getBrandDetails is a method that fetches brand details
      _brand = await productServiceRepository.getBrand(brandId);
      _filtersData = await productServiceRepository.getCategories();

      if (_filtersData.isNotEmpty) {
        _selectedCategory = _filtersData.first;
      }

      setState(ViewState.done);
    } catch (e, s) {
      if (e is AppException) {
        handleException(e);
      } else {
        setStateToErrorWithMessage('Failed to load brands');
      }
      log.e('error: $e \n stack trace: $s');
    }
  }

  int getQuantity(Product product) {
    return productsCart.getQuantityOfItem(product);
  }

  int _totalItems = 0;
  double _totalAmount = 0.0;

  int get totalItems => _totalItems;
  double get totalAmount => _totalAmount;

  void _updateTotals() {
    _totalItems =
        productsCart.getCartItems().values.fold(0, (sum, item) => sum + item);
    _totalAmount = productsCart.getCartItems().keys.fold(0.0, (sum, product) {
      return sum + (product.price * productsCart.getQuantityOfItem(product));
    });
    notifyListeners();
  }

  Category? _selectedCategory;
  Category? get selectedCategory => _selectedCategory;

  void selectCategory(Category category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void addItemToCart(Product product, int quantity) {
    productsCart.addItemQuantity(product, quantity);
    notifyListeners();
  }

  void addAllItemsToCart(Map<Product, int> itemsWithQuantities) {
    itemsWithQuantities.forEach((product, quantity) {
      addItemToCart(product, quantity);
    });
    notifyListeners();
  }

  bool isItemInCart(Product product) {
    if (getCartItems().isEmpty) {
      return false;
    }
    return getCartItems().keys.contains(product);
  }

  void removeItemFromCart(Product product) {
    productsCart.removeFromCart(product);
    notifyListeners();
  }

  Map<Product, int> getCartItems() {
    return productsCart.getCartItems();
  }

  int getQuantityOfItem(Product product) {
    return productsCart.getQuantityOfItem(product);
  }

  void decrementQuantity(Product product) {
    productsCart.decrementItemQuantity(product);
    _updateTotals();
    notifyListeners();
  }

  void incrementQuantity(Product product) {
    productsCart.incrementItemQuantity(product);
    _updateTotals();
    notifyListeners();
  }

  void createSaleOrderRequest() {
    _saleOrderRequestForProducts =
        SaleOrderRequestForProducts(cartItems: productsCart.getCartItems());
  }

  SaleOrderRequestForProducts? getSaleOrderRequest() {
    return _saleOrderRequestForProducts;
  }
}
