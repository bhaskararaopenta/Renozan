import 'package:app/features/manage_money/cash_in_out/bank_account_model.dart';

abstract class BankDetailsRepository {
  Future<List<BankDetailsData>> fetchBankDetails();
}

