import 'package:app/core/exceptions.dart';
import 'package:app/core/base_provider.dart';
import 'package:app/features/user_account/user_auth_repository.dart';
import 'package:app/services/service_locator.dart';

class SelectPhoneNumberViewModel extends BaseProvider {
  final UserAuthRepository repository;

  SelectPhoneNumberViewModel(this.repository) {
    log.d('Creating SelectPhoneNumberViewModel');
  }

  Future<void> submitPhoneNumber(String dialCode, String phoneNumber) async {
    setState(ViewState.loading);

    try {
      await repository.registerUser(
          dialCode, phoneNumber);

      setState(ViewState.done);
    } catch (e) {
      if (e is AppException) {
        handleException(e);
      } else {
        setStateToErrorWithMessage('An unexpected error occurred.');
      }
    }
  }
}
