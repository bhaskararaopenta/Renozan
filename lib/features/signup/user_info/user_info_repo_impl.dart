import 'dart:convert';

import 'package:app/features/signup/user_info/user_info_repository_interface.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class UserInfoRepositoryImpl implements UserInfoRepository {
  final http.Client client;

  UserInfoRepositoryImpl(this.client);

  @override
  Future<String> submitUserDetails(
    String name,
    String dob,
    String address,
    String email,
  ) async {
    try {
      // Load the JSON file from the assets
      final String response = await rootBundle
          .loadString('lib/features/signup/user_info/mock_res.json');
      final Map<String, dynamic> responseData = json.decode(response);

      // Simulate a network delay
      await Future.delayed(Duration(seconds: 2));

      // Check the status field in the JSON response
      if (responseData['status'] == 'success') {
        // Return the success message
        return responseData['message'] ?? 'Success';
      } else {
        // Throw an exception with the error message from the response
        throw Exception(
            'Failed to submit user details: ${responseData['message']}');
      }
    } catch (e) {
      // Log the exception and stack trace for debugging
      print('Exception occurred: $e');

      throw Exception('Failed to submit user details: $e');
    }
  }
}
