import 'package:app/features/signup/verification/verification_model.dart';

abstract class VerificationRepository {
  Future<verificationResponse> verifyOtp(String otp, String otpToken);
}
