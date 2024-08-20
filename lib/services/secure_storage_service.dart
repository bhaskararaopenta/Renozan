import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  Future<void> writeKeyValue(String key, String? value) async {
    await secureStorage.write(key: key, value: value);
  }

  Future<String?> readKeyValue(String key) async {
    return await secureStorage.read(key: key);
  }
}

class SecureStorageKey {
  static const String userAuthToken = 'userAuthToken';
  static const String phoneNumber = 'phoneNumber';
  static const String password = 'password';
  static const String userDetails = 'userDetails';
}