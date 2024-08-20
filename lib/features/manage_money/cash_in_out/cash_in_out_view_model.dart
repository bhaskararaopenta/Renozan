import 'package:app/core/base_provider.dart';
import 'package:app/core/exceptions.dart';
import 'package:app/features/wallet/wallet_model.dart';
import 'package:app/mocks/card_repository_interface.dart';
import 'package:app/features/manage_money/cash_in_out/bank_account_model.dart';
import 'package:app/features/manage_money/cash_in_out/bank_account_repository.dart';
import 'package:app/services/service_locator.dart';

class CashInOutViewModel extends BaseProvider {
  final CardRepository repository;
  final BankDetailsRepository bankDetailsRepository;

  CashInOutViewModel(this.repository, this.bankDetailsRepository) {
    log.d('Creating CashIn/Out_ScreenViewModel');
  }

  List<WalletInfo> _cardDetails = [];
  List<WalletInfo> get cardDetails => _cardDetails;

  List<BankDetailsData> _bankDetails = [];
  List<BankDetailsData> get bankDetails => _bankDetails;

  int _currentTabIndex = 0;
  int get currentTabIndex => _currentTabIndex;

  set currentTabIndex(int index) {
    _currentTabIndex = index;
    notifyListeners(); // Notify listeners when the tab index changes
  }

  Future<void> loadCashInOutScreen() async {
    setState(ViewState.loading);
    try {
      _cardDetails = await repository.fetchCardDetails();
      _bankDetails = await bankDetailsRepository.fetchBankDetails();
      setState(ViewState.done);
    } catch (e) {
      if (e is AppException) {
        handleException(e);
      } else {
        //set current screen specific error message or use a generic one
        setStateToErrorWithMessage('Failed to load card details');
      }
    }
  }
}
