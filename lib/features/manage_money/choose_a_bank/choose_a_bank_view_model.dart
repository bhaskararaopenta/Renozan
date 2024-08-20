import 'package:app/core/base_provider.dart';
import 'package:app/core/exceptions.dart';
import 'package:app/features/manage_money/add_bank_account/add_bankaccount_repository.dart';
import 'package:app/features/manage_money/choose_a_bank/choose_a_bank_model.dart';
import 'package:app/features/manage_money/choose_a_bank/choose_a_bank_repository.dart';
import 'package:app/services/service_locator.dart';

enum AccountType {
  Personal,
  Business,
}

class ChooseBankViewModel extends BaseProvider {
  final GetBanksListRepository chooseBankRepository;
  final AddBankAccountRepository addBankAccountRepository;
  List<BankModel>? _bankList;
  List<BankModel>? get bankList => _bankList;

  ChooseBankViewModel(
      this.chooseBankRepository, this.addBankAccountRepository) {
    log.d('Creating choose_a_bank_ScreenViewModel');
  }

  String _bankName = '';

  AccountType _accountType = AccountType.Personal;
  AccountType get accountType => _accountType;

  void setAccountType(AccountType value) {
    _accountType = value;
// here only update to repository
    addBankAccountRepository.saveAccountType(_accountType);
    notifyListeners();
  }

  String get bankName => _bankName;

  void setBankDetails(String bankName, int position) {
    _bankName = bankName;
    //
    addBankAccountRepository.saveBankDetails(bankList?.elementAt(position));
    notifyListeners();
  }

  void addBeneficiary(String bankName) {
    // Add your logic to add beneficiary here
  }

  Future<void> loadChooseBankScreen() async {
    setState(ViewState.loading);
    try {
      _bankList = await chooseBankRepository.getBanksList();
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
