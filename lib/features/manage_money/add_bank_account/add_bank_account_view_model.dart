import 'package:app/core/base_provider.dart';
import 'package:app/core/exceptions.dart';
import 'package:app/features/manage_money/add_bank_account/add_bankaccount_repository.dart';
import 'package:app/features/manage_money/add_bank_account/user_bank_account_model.dart';
import 'package:app/features/manage_money/choose_a_bank/choose_a_bank_model.dart';

class AddBankAccountViewModel extends BaseProvider {
  final AddBankAccountRepository _repository;
  UserBankAccountModel? _userBankAccountModel;

  AddBankAccountViewModel(this._repository) {
    _userBankAccountModel = _repository.getUserBankAccount();
    print("Bank details: $_userBankAccountModel");
  }

  BankModel? get bankDetails => _userBankAccountModel?.bank;

  bool _hasShownBottomSheet = false;
  bool get hasShownBottomSheet => _hasShownBottomSheet;

  String? _selectedAccountType;
  String? _selectedBranch;
  final List<String> _accountTypes = ['Saving', 'Current'];
  final List<String> _branchList = ['Head office', 'Down st'];

  String? get selectedAccountType => _selectedAccountType;
  String? get selectedBranch => _selectedBranch;
  List<String> get accountTypes => _accountTypes;
  List<String> get branchList => _branchList;

  void setSelectedAccountType(String? value) {
    _selectedAccountType = value;
     _userBankAccountModel?.setSelectedAccountType(value ?? '');
    _repository.saveSelectedAccountType(value ?? '');
    notifyListeners();
  }

  void setSelectedBranch(String? value) {
    _selectedBranch = value;
     _userBankAccountModel?.setSelectedBranch(value ?? '');
    _repository.saveSelectedBranch(value ?? '');
    notifyListeners();
  }

  Future<void> submitUserDetails(
      String firstName, String lastName, String accountNumber) async {
    //pass details from ui
    setState(ViewState.loading);
     print("Bank details: $_userBankAccountModel");
    try {
      bool success = await _repository.submitUserAccountDetails(
          accountNumber, firstName, lastName);
      if (success) {
        _hasShownBottomSheet = true; // Set flag to true on success
        setState(ViewState.done);
      } else {
        setState(ViewState.error);
      }
    } catch (e) {
      if (e is AppException) {
        handleException(e);
      } else {
        //set current screen specific error message or use a generic one
        setStateToErrorWithMessage('Failed to load card details');
      }
    }
  }

  void resetBottomSheetFlag() {
    _hasShownBottomSheet = false;
    notifyListeners();
  }
}
