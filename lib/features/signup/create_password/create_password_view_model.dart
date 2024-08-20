import 'package:app/core/base_provider.dart';
import 'package:app/core/exceptions.dart';
import 'package:app/features/user_account/user_auth_repository.dart';
import 'package:app/services/service_locator.dart';

class CreatePasswordViewModel extends BaseProvider {
  final UserAuthRepository repository;

  CreatePasswordViewModel(this.repository) {
    log.d('Creating CreatePasswordViewModel');
  }

  Future<void> submitCreatePassword(String password) async {
    setState(ViewState.loading);
    try {
      await repository.submitDetails(password);
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
