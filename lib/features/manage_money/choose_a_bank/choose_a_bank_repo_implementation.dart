import 'dart:convert';

import 'package:app/core/exceptions.dart';
import 'package:app/features/manage_money/choose_a_bank/choose_a_bank_model.dart';
import 'package:app/features/manage_money/choose_a_bank/choose_a_bank_repository.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class ImplementationChooseBankRepository implements GetBanksListRepository {
  final http.Client client;
//final UserBankAccountModel
  ImplementationChooseBankRepository(this.client);

  @override
  Future<List<BankModel>?> getBanksList() async {
    try {
      String mockData = await rootBundle.loadString(
          'lib/features/manage_money/choose_a_bank/choose_a_bank.json');
      Map<String, dynamic> jsonData = json.decode(mockData);

      if (jsonData.containsKey('data') && jsonData['data'] != null) {
        BankAccountModel bankAccountModel = BankAccountModel.fromJson(jsonData);
        return bankAccountModel.data?.list; // Return a list of BankAccountModel
      } else {
        throw AppException('Data field not found or is null');
      }
    } catch (e) {
      throw AppException('Failed to load bank details: $e');
    }
  }
}
