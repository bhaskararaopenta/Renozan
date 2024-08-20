import 'dart:convert';

import 'package:app/core/exceptions.dart';
import 'package:app/features/signup/select_phone_number/phone_number_model.dart';
import 'package:app/features/signup/select_phone_number/phone_repository_interface.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class PhoneRepositoryImpl implements PhoneRepository {
  final http.Client client;

  PhoneRepositoryImpl(this.client);

  @override
  Future<PhoneNumberModel> submitPhoneNumber(
      String dialCode, String phoneNumber, String accountType) async {
    try {
      // Simulate a delay for the API response
      await Future.delayed(const Duration(seconds: 1));

      // Prepare the request payload
      final payload = {
        'dialCode': dialCode,
        'phoneNumber': phoneNumber,
        'accountType': accountType,
      };

      // Load the local JSON file to simulate the API response
      final jsonString = await rootBundle.loadString(
          'lib/features/signup/select_phone_number/mock_mobile_info.json');
      final data = json.decode(jsonString) as Map<String, dynamic>;

      // Convert data into PhoneNumberModel
      final phoneNumberModel = PhoneNumberModel.fromJson(data);

      // Return the PhoneNumberModel instance
      return phoneNumberModel;
    } catch (e) {
      throw AppException('Failed to submit phone number: $e');
    }
  }
}
