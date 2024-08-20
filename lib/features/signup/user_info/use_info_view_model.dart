import 'package:app/core/base_provider.dart';
import 'package:app/core/exceptions.dart';
import 'package:app/features/user_account/user_auth_models.dart';
import 'package:app/features/user_account/user_auth_repository.dart';
import 'package:app/services/service_locator.dart';

class UserInfoViewmodel extends BaseProvider {
  final UserAuthRepository repository;
  bool _isChecked = false;

  UserInfoViewmodel(this.repository) {
    log.d('Creating UserInfoViewModel');
  }

  bool get isChecked => _isChecked;

  void setChecked(bool value) {
    _isChecked = value;
    notifyListeners();
  }

  Future<void> submitUserInfo(
    String name,
    String dob,
    String address,
    String email,
  ) async {
    setState(ViewState.loading);

    try {
      repository.saveUserDetails(UserDetails(
          fullName: name, dateOfBirth: dob, address1: address, email: email));
      setState(ViewState.done);
    } catch (e) {
      if (e is AppException) {
        handleException(e);
      } else {
        setStateToErrorWithMessage('Error in submitting user information');
      }
    }
  }
}
