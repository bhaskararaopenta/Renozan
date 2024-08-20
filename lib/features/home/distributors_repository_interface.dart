import 'package:app/features/home/distributors_model.dart';

abstract class DistributorsRepository {
  Future<List<DistributorsData>> fetchDistributorsDetails();
}