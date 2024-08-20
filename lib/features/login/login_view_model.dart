import 'package:app/core/base_provider.dart';
import 'package:app/core/exceptions.dart';
import 'package:app/features/user_account/user_auth_repository.dart';
import 'package:app/services/service_locator.dart';

class LoginViewModel extends BaseProvider {
  final UserAuthRepository _userAuthRepository;

  LoginViewModel(this._userAuthRepository) {
    log.d('Creating LoginViewModel');
  }

  Future<void> login(String phoneNumber, String password) async {
    setState(ViewState.loading);

    try {
      await _userAuthRepository.login(password, phoneNumber: phoneNumber);
      setState(ViewState.done);
    } on AppException catch (e) {
      handleException(e);
    } catch (e, s) {
      log.e('Error: $e \n StackTrace: $s');
      setStateToErrorWithMessage('An unexpected error occurred.');
    }
  }
}
