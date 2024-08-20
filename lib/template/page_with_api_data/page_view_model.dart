import 'package:app/core/exceptions.dart';
import 'package:app/core/base_provider.dart';
import 'package:app/services/service_locator.dart';
import 'package:app/template/page_with_api_data/model.dart';
import 'package:app/template/page_with_api_data/repository_interface.dart';

class ProductsViewModel extends BaseProvider {
  final ProductsRepository repository;

  ProductsViewModel(this.repository) {
    log.d('Creating ProductsViewModel');
  }

  List<Product> _products = [];
  List<Product> get products => _products;

  Future<void> fetchProducts() async {
    setState(ViewState.loading);

    try {
      _products = await repository.fetchProducts();
      setState(ViewState.done);
    } on AppException catch (e) {
      handleException(e);
    } catch (e, s) {
      log.e('Error: $e \n StackTrace: $s');
      setStateToErrorWithMessage('An unexpected error occurred.');
    }
  }
}
