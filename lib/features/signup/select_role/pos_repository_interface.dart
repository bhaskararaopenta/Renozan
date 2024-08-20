// lib/features/signup/position_interface.dart

abstract class PosRepository {
  Future<Map<String, String>> sendPosNumber(String posNumber);
  Future<bool> validatePosNumber(String posNumber);
}
