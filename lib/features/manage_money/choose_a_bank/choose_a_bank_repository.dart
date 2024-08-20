
import 'package:app/features/manage_money/choose_a_bank/choose_a_bank_model.dart';

abstract class GetBanksListRepository {
  Future<List<BankModel>?> getBanksList();
  
}