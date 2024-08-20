import 'package:app/core/base_provider.dart';
import 'package:app/core/exceptions.dart';
import 'package:app/features/home/distributors_repository_interface.dart';
import 'package:app/features/product_service/brand.dart';
import 'package:app/features/product_service/category.dart';
import 'package:app/features/product_service/product_service_repository.dart';
import 'package:app/services/service_locator.dart';

import '../../product_service/business_connection_models.dart';

class DistributorViewModel extends BaseProvider {
  final DistributorsRepository distributorsRepository;
  final ProductServiceRepository productServiceRepository;

  DistributorViewModel(
      this.productServiceRepository, this.distributorsRepository) {
    log.d('Creating DistributorViewModel');
  }

  List<BusinessConnection> _distributors = [];
  List<BusinessConnection> get distributors => _distributors;

  late BusinessConnection _selectedDistributor;
  BusinessConnection get selectedDistributor => _selectedDistributor;

  List<Brand> _selectedDistributorBrands = [];
  List<Brand> get selectedDistributorBrands => _selectedDistributorBrands;

  bool _isSelected = false;
  bool get isSelected => _isSelected;

  bool _isBottomSheetOpen = false;
  bool get isBottomSheetOpen => _isBottomSheetOpen;

  final List<Category> _filtersData = [];
  List<Category> get filtersData => _filtersData;

  // late Distributor _selectedDistributor;
  // bool isSelected = false;

  // get selectedDistributor => null;

  Future<void> loadDistributorScreen() async {
    setState(ViewState.loading);
    try {
      _distributors = await productServiceRepository.getDistributors();
      //_filtersData = await productServiceRepository.getCategories();

      if (_filtersData.isNotEmpty) {
        _selectedCategory = _filtersData.first;
      }

      setState(ViewState.done);
    } catch (e, s) {
      log.e(s);
      if (e is AppException) {
        handleException(e);
      } else {
        //set current screen specific error message or use a generic one
        setStateToErrorWithMessage('Failed to load details');
      }
    }
  }

  void selectDistributor(BusinessConnection distributor) {
    _selectedDistributor = distributor;
    _isSelected = true;
    log.d('Distributor selected: $_selectedDistributor');
    log.d('isSelected set to: $_isSelected');
    notifyListeners();
    // Revert isSelected after 1 second
    // Future.delayed(const Duration(seconds: 1), () {
    //   deselectDistributor();
    // });

    _fetchBrandsForSelectedDistributor(distributor.accountCode);
  }

  Future<void> _fetchBrandsForSelectedDistributor(String distributorId) async {
    try {
      log.d('Fetching brands for distributor: $distributorId');
      _selectedDistributorBrands =
          await productServiceRepository.getBrandsOfDistributor(distributorId);
      log.d('Brands fetched: $_selectedDistributorBrands');
      notifyListeners();
    } catch (e, s) {
      if (e is AppException) {
        handleException(e);
      } else {
        setStateToErrorWithMessage('Failed to load brands');
      }
      log.e('error: $e \n stack trace: $s');
    }
  }

  void resetSelectedState() {
    if (!_isBottomSheetOpen) {
      _isSelected = false;
      log.d('isSelected reset to: $_isSelected');
      notifyListeners();
    }
  }

  void setBottomSheetOpenState(bool isOpen) {
    _isBottomSheetOpen = isOpen;
    log.d('Bottom sheet open state set to: $_isBottomSheetOpen');
    notifyListeners();
  }

  Category? _selectedCategory;
  Category? get selectedCategory => _selectedCategory;

  void selectCategory(Category category) {
    _selectedCategory = category;
    notifyListeners();
  }
}
