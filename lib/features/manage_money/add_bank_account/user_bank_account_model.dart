import 'package:app/features/manage_money/choose_a_bank/choose_a_bank_model.dart';
import 'package:app/features/manage_money/choose_a_bank/choose_a_bank_view_model.dart';

class UserBankAccountModel {
  BankModel? bank;
  AccountType accountType = AccountType.Personal;
  String firstName;
  String lastName;
  String accountNumber;
  String? selectedAccountType;
  String? selectedBranch;

  UserBankAccountModel({
    this.firstName = '',
    this.lastName = '',
    this.accountNumber = '',
    this.selectedAccountType,
    this.selectedBranch,
  });

  void setFirstName(String firstName) {
    this.firstName = firstName;
  }

  void setLastName(String lastName) {
    this.lastName = lastName;
  }

  void setAccountNumber(String accountNumber) {
    this.accountNumber = accountNumber;
  }

  void setSelectedAccountType(String accountType) {
    this.selectedAccountType = accountType;
  }

  void setSelectedBranch(String branch) {
    this.selectedBranch = branch;
  }

   @override
  String toString() {
    return 'UserBankAccountModel(\n'
        '  bank: ${bank != null ? bank.toString() : 'null'},\n'
        '  accountType: $accountType,\n'
        '  firstName: $firstName,\n'
        '  lastName: $lastName,\n'
        '  accountNumber: $accountNumber,\n'
        '  selectedAccountType: $selectedAccountType,\n'
        '  selectedBranch: $selectedBranch\n'
        ')';
  }
}
