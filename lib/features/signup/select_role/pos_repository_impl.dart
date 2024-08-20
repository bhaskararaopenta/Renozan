// lib/features/signup/repository_impl.dart

import 'dart:convert';

import 'package:app/core/exceptions.dart';
import 'package:app/features/signup/select_role/pos_repository_interface.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class PosRepositoryImpl implements PosRepository {
  final http.Client client;

  PosRepositoryImpl(this.client);

  @override
  Future<bool> validatePosNumber(String posNumber) async {
    try {
      // Simulate a delay for the API response
      await Future.delayed(const Duration(seconds: 1));

      // Load the local JSON file
      final jsonString = await rootBundle
          .loadString('lib/features/signup/select_role/mock_company_info.json');
      final data = json.decode(jsonString) as Map<String, dynamic>;

      // Check if the POS number exists in the data
      return data.containsKey(posNumber);
    } catch (e) {
      throw AppException('Failed to read local JSON file: $e');
    }
  }

  @override
  Future<Map<String, String>> sendPosNumber(String posNumber) async {
    try {
      // Simulate a delay for the API response
      await Future.delayed(const Duration(seconds: 3));

      // Load the local JSON file
      final jsonString = await rootBundle
          .loadString('lib/features/signup/select_role/mock_company_info.json');
      final data = json.decode(jsonString) as Map<String, dynamic>;

      // Extract the image and text based on posNumber
      final imageUrl = data[posNumber]['image'] as String;
      final name = data[posNumber]['text'] as String;

      return {'image': imageUrl, 'name': name};
    } catch (e) {
      throw AppException('Failed to read local JSON file: $e');
    }
  }
}
