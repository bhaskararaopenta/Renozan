import 'package:app/core/base_provider.dart';
import 'package:app/core/exceptions.dart';
import 'package:app/features/user_account/user_auth_repository.dart';
import 'package:app/services/service_locator.dart';

class AppViewModel extends BaseProvider {
  final UserAuthRepository userAuthRepository;

  AppViewModel(this.userAuthRepository) {
    log.d('Creating AppViewModel');
  }

  Future<void> checkUserLoginStatus() async {
    setState(ViewState.loading);
    try {
      bool isLoggedIn = await userAuthRepository.isLoggedIn();
      log.d('userAuthRepository.isLoggedIn(): $isLoggedIn');
      if (isLoggedIn) {
        setState(ViewState.done);
      } else {
        setState(ViewState.empty); // Assume empty state means not logged in
      }
    } on AppException catch (e) {
      handleException(e);
    } catch (e, s) {
      log.e('Error: $e \n StackTrace: $s');
      setStateToErrorWithMessage('An unexpected error occurred.');
    }
  }

  Future<void> logoutUser() async {
    try {
      await userAuthRepository.logout();
    } on AppException catch (e) {
      handleException(e);
    } catch (e, s) {
      log.e('Error: $e \n StackTrace: $s');
      setStateToErrorWithMessage('An unexpected error occurred.');
    }
  }
}
