import 'dart:convert';

import 'package:app/features/user_account/user_auth_models.dart';
import 'package:app/features/wallet/wallet_model.dart';
import 'package:app/services/api_service.dart';
import 'package:app/services/secure_storage_service.dart';

abstract class WalletRepository {
  Future<WalletInfo> getWalletInfo();
}

class WalletRepositoryImpl implements WalletRepository {
  final ApiService apiService;
  final SecureStorageService secureStorageService;

  WalletRepositoryImpl(
      {required this.apiService, required this.secureStorageService});

  @override
  Future<WalletInfo> getWalletInfo() async {
    //read userDetails from secure storage
    String? savedUserDetails =
        await secureStorageService.readKeyValue(SecureStorageKey.userDetails);
    UserDetails userDetails =
        UserDetails.fromJson(jsonDecode(savedUserDetails!) as Map<String, dynamic>);
    Account account = userDetails.getRetailerAccount();

    final response = await apiService.performGetRequest(
      'wallets/wallet/info',
      {
        'accountType': account.accountType,
        'accountCode': account.accountCode,
      },
    );

    return WalletInfo.fromJson(response['data']);
  }
}
