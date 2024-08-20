import 'package:app/features/signup/create_password/create_password_model.dart';

abstract class CreatePasswordRepository {
  Future<CreatePasswordModel> saveCreatePassword(String Password);
}
