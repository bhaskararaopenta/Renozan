import 'package:app/features/signup/select_phone_number/phone_number_model.dart';

abstract class PhoneRepository {
  Future<PhoneNumberModel> submitPhoneNumber(
      String dialCode, String phoneNumber, String accountType);
}
