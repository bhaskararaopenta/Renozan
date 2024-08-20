import 'dart:convert';

import 'package:app/core/exceptions.dart';
import 'package:app/features/wallet/wallet_model.dart';
import 'package:app/mocks/card_repository_interface.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class MockCardRepository implements CardRepository {
  final http.Client client;

  MockCardRepository(this.client);

  @override
  Future<List<WalletInfo>> fetchCardDetails() async {
    //add 3 secs delay
    await Future.delayed(const Duration(seconds: 3));
    try {
      String mockData =
          await rootBundle.loadString('assets/mock_data/mock_card_data.json');
      // Map<String, dynamic> jsonData = json.decode(mockData);
      // CardData cardData = CardData.fromJson(jsonData);
      // return [cardData];
      List<dynamic> jsonData = json.decode(mockData);
      List<WalletInfo> cardData =
          jsonData.map((item) => WalletInfo.fromJson(item)).toList();
      return cardData;
    } catch (e) {
      throw AppException('Failed to load card details: $e');
    }
  }
}
