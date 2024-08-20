import 'dart:async';

import 'package:app/core/base_provider.dart';
import 'package:app/core/exceptions.dart';
import 'package:app/features/home/recentActivity_model.dart';
import 'package:app/features/home/recentActivity_repository_interface.dart';
import 'package:app/features/product_service/product_service_repository.dart';
import 'package:app/features/user_account/user_auth_repository.dart';
import 'package:app/features/wallet/wallet_model.dart';
import 'package:app/features/wallet/wallet_repository.dart';
import 'package:app/services/service_locator.dart';

import '../product_service/business_connection_models.dart';

class HomeScreenViewModel extends BaseProvider {
  final UserAuthRepository userAuthRepository;
  final WalletRepository walletRepository;
  // final DistributorsRepository distributorsRepository;
  final RecentActivityRepository recentActivityRepository;
  final ProductServiceRepository productServiceRepository;

  HomeScreenViewModel(this.userAuthRepository, this.walletRepository,
      this.recentActivityRepository, this.productServiceRepository) {
    log.d('Creating HomeScreenViewModel');
  }

  final List<WalletInfo> _walletInfoList = [];
  List<WalletInfo> get walletInfoList => _walletInfoList;

  List<BusinessConnection> _distributors = [];
  List<BusinessConnection> get distributors => _distributors;

  List<RecentActivityData> _recentActivity = [];
  List<RecentActivityData> get recentActivity => _recentActivity;

  final Map<String, bool> _isTapped = {
    "Inventory": false,
    "Activity": false,
    "Credit": false,
    "Cash In/Out": false,
  };

  Map<String, bool> get isTapped => _isTapped;

  void handleTap(String title, Function callback) {
    _isTapped[title] = true;
    notifyListeners();

    Timer(const Duration(seconds: 2), () {
      _isTapped[title] = false;
      notifyListeners();
    });

    callback();
  }

  Future<void> loadHomeScreenData() async {
    setState(ViewState.loading);

    try {
      await userAuthRepository.fetchUserDetails();
      WalletInfo wallet = await walletRepository.getWalletInfo();
      _walletInfoList.add(wallet);
      _distributors = await productServiceRepository.getDistributors();

      _recentActivity =
          await recentActivityRepository.fetchRecentActivityDetails();

      setState(ViewState.done);
    } catch (e, s) {
      if (e is AppException) {
        handleException(e);
      } else {
        //set current screen specific error message or use a generic one
        setStateToErrorWithMessage('Failed to load details');
        log.e('Error: $e \n StackTrace: $s');
      }
    }
  }

}
