import 'package:app/features/wallet/wallet_model.dart';

abstract class CardRepository {
  Future<List<WalletInfo>> fetchCardDetails();
}
