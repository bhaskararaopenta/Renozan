import 'package:app/core/exceptions.dart';
import 'package:app/features/signup/create_password/create_password_model.dart';
import 'package:app/features/signup/create_password/create_password_repository_interface.dart';

import 'package:http/http.dart' as http;

class CreatePasswordRepositoryImpl implements CreatePasswordRepository {
  final http.Client client;

  CreatePasswordRepositoryImpl(this.client);

  @override
  Future<CreatePasswordModel> saveCreatePassword(String Password) async {
    try {
      // Simulate a delay for the API response
      await Future.delayed(const Duration(seconds: 1));

      // Return a hardcoded response
      return CreatePasswordModel(
        status: "success",
        message: "Password Updated",
      );
    } catch (e) {
      throw AppException('Failed to Save password: $e');
    }
  }
}
