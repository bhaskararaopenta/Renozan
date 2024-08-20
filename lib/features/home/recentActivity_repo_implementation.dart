import 'dart:convert';

import 'package:app/core/exceptions.dart';
import 'package:app/features/home/recentActivity_model.dart';
import 'package:app/features/home/recentActivity_repository_interface.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

//recentActivityrepositoryimpl
class MockRecentActivityRepository implements RecentActivityRepository {
  final http.Client client;

  MockRecentActivityRepository(this.client);

  @override
  Future<List<RecentActivityData>> fetchRecentActivityDetails() async {
    //add 3 secs delay
    await Future.delayed(const Duration(seconds: 1));
    try {
      String mockData =
          await rootBundle.loadString('lib/features/home/mock_recentActivity_data.json');
      List<dynamic> jsonData = json.decode(mockData);
       List<RecentActivityData> distributors =jsonData.map((item) => RecentActivityData.fromJson(item)).toList();
      return distributors;
    } catch (e) {
      throw AppException('Failed to load card details: $e');
    }
  }
}