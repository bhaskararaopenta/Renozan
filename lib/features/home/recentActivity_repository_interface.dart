import 'package:app/features/home/recentActivity_model.dart';

abstract class RecentActivityRepository {
  Future<List<RecentActivityData>> fetchRecentActivityDetails();
}