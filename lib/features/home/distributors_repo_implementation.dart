
import 'dart:convert';

import 'package:app/core/exceptions.dart';
import 'package:app/features/home/distributors_model.dart';
import 'package:app/features/home/distributors_repository_interface.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class MockDistributorsRepository implements DistributorsRepository {
  final http.Client client;

  MockDistributorsRepository(this.client);

  @override
  Future<List<DistributorsData>> fetchDistributorsDetails() async {
    //add 3 secs delay
    await Future.delayed(const Duration(seconds: 1));
    try {
      String mockData =
          await rootBundle.loadString('lib/features/home/mock_distributors_data.json');
      List<dynamic> jsonData = json.decode(mockData);
       List<DistributorsData> distributors =jsonData.map((item) => DistributorsData.fromJson(item)).toList();
      return distributors;
    } catch (e) {
      throw AppException('Failed to load card details: $e');
    }
  }
}
