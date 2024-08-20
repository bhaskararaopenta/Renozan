import 'package:app/features/manage_money/add_bank_account/user_bank_account_model.dart';
import 'package:app/features/manage_money/choose_a_bank/choose_a_bank_model.dart';
import 'package:app/features/manage_money/choose_a_bank/choose_a_bank_view_model.dart';
import 'package:app/services/service_locator.dart';

class AddBankAccountRepository {
  late UserBankAccountModel userBankAccount;

  AddBankAccountRepository({required this.userBankAccount});

  void saveBankDetails(BankModel? bank) {
    userBankAccount.bank = bank;
  }

  BankModel? getBankDetails() {
    return userBankAccount.bank;
  }

  void saveAccountType(AccountType accountType) {
    userBankAccount.accountType = accountType;
  }

   void saveSelectedAccountType(String accountType) {
    userBankAccount.selectedAccountType = accountType;
  }

  void saveSelectedBranch(String branch) {
    userBankAccount.selectedBranch = branch;
  }


  Future<bool> submitUserAccountDetails(
      String accountNumber, String firstName, String lastName) async {
    //1,2,3,4,5
    userBankAccount.accountNumber = accountNumber;
    userBankAccount.firstName = firstName;
    userBankAccount.lastName = lastName;
     

    log.d('submitUserAccountDetails begin');
    log.d('bank details: ${userBankAccount.bank?.name}');
    log.d('account type : ${userBankAccount.accountType.toString()}');
    log.d('selected account type : ${userBankAccount.selectedAccountType}');
    log.d('selected account type : ${userBankAccount.selectedBranch}');
    log.d(
        'accountNumber: $accountNumber, firstName: $firstName, lastName: $lastName');

    //update other fields 4

    if (userBankAccount.bank != null &&
        userBankAccount.accountNumber.isNotEmpty &&
        userBankAccount.firstName.isNotEmpty &&
        userBankAccount.lastName.isNotEmpty &&
        userBankAccount.selectedAccountType != null &&
        userBankAccount.selectedBranch != null) {
      // Perform further operations, such as saving the user details to a backend or local storage
      return true;
    } else {
      return false;
    }
  }

  UserBankAccountModel? getUserBankAccount() {
    return userBankAccount;
  }
}
