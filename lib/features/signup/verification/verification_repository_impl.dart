import 'package:app/core/exceptions.dart';
import 'package:app/features/signup/verification/verification_model.dart';
import 'package:app/features/signup/verification/verification_repository_interface.dart';
import 'package:http/http.dart' as http;

class VerificationRepositoryImpl implements VerificationRepository {
  final http.Client client;

  VerificationRepositoryImpl(this.client);

  @override
  Future<verificationResponse> verifyOtp(String otp, String otpToken) async {
    try {
      // Simulate a delay for the API response
      await Future.delayed(const Duration(seconds: 1));

      // Return a hardcoded response
      return verificationResponse(
        status: "success",
        message: "OTP Verified.",
      );
    } catch (e) {
      throw AppException('Failed to verify OTP: $e');
    }
  }
}
