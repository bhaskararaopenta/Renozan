import 'package:app/core/base_provider.dart';
import 'package:app/core/exceptions.dart';
import 'package:app/services/service_locator.dart';

import '../../user_account/user_auth_repository.dart';

class VerifyOtpViewModel extends BaseProvider {
  final UserAuthRepository repository;
  String? _testOtp;
  String? get getTestOtp => _testOtp;

  VerifyOtpViewModel(this.repository) {
    log.d('Creating  verifyOtpViewModel ');
    _testOtp = repository.getTestOtp();
  }

  Future<void> submitOtp(String otp) async {
    setState(ViewState.loading);
    try {
      await repository.verifyOtp(otp);
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
