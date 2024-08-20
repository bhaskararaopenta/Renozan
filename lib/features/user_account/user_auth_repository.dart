import 'dart:convert';

import 'package:app/core/exceptions.dart';
import 'package:app/features/user_account/account_type.dart';
import 'package:app/features/user_account/retailer_role.dart';
import 'package:app/features/user_account/user_auth_models.dart';
import 'package:app/services/api_service.dart';
import 'package:app/services/secure_storage_service.dart';
import 'package:app/services/service_locator.dart';

abstract class UserAuthRepository {
  Future<OtpResponse> registerUser(String dialCode, String phoneNumber);
  Future<Pos> verifyBusiness(String posNumber, RetailerRole selectedRole);
  Future<void> verifyOtp(String otp);
  Future<OtpResponse> resendOtp(String token);
  void saveUserDetails(UserDetails userDetails);
  Future<void> submitDetails(String password);
  Future<bool> isLoggedIn();
  Future<AuthTokens> login(String password, {String? phoneNumber});
  Future<bool> verifyLoginPin(String pin);
  Future<OtpResponse> forgotPassword(String phoneNumber);
  Future<void> verifyForgotPasswordOtp(String otp, String token);
  Future<OtpResponse> resendForgotOtp(String token);
  Future<void> resetPassword(
      String newPassword, String confirmPassword, String token);
  Future<UserDetails> fetchUserDetails();
  Future<void> logout();
  String? getTestOtp();
}

class UserAuthRepositoryImpl implements UserAuthRepository {
  final ApiService apiService;
  final SecureStorageService secureStorageService;
  final bool isMockDataOn;

  //values that need to be saved temporarily during sign up flow
  //so that they are used in the final submitDetails call
  RetailerRole? retailerRole;
  String? posToken;
  String? otpToken;
  String? testOtp;
  UserDetails? userDetails;

  UserAuthRepositoryImpl({
    required this.apiService,
    required this.secureStorageService,
    this.isMockDataOn = false,
  });

  @override
  Future<OtpResponse> registerUser(String dialCode, String phoneNumber) async {
    final response = await apiService.performPostRequest(
      'users/auth/signup/register',
      {
        "dialCode": dialCode,
        "phoneNumber": phoneNumber,
        "accountType": getAccountType().toString(),
      },
    );

    testOtp = response['data']['otp'];
    otpToken = response['data']['token'];
    return OtpResponse.fromJson(response['data']);
  }

  @override
  Future<Pos> verifyBusiness(
      String posNumber, RetailerRole retailerRole) async {
    // Reset posToken
    posToken = null;
    this.retailerRole = retailerRole;

    final response = await apiService.performPostRequest(
      'users/auth/signup/verify-business',
      {"posNumber": posNumber},
    );

    // Set posToken
    posToken = response['data']['posToken'];

    // Extract the POS details directly from the response
    final Map<String, dynamic> posData = response['data']['pos'];
    if (posToken == null) {
      throw AppException("posToken not received");
    } else if (posData.isNotEmpty) {
      return Pos.fromJson(posData, posToken!);
    } else {
      throw AppException("No POS data found");
    }
  }

  @override
  Future<void> verifyOtp(String otp) async {
    await apiService.performPostRequest(
      'users/auth/signup/verify-otp',
      {
        "otp": otp,
        "token": otpToken,
      },
    );
  }

  @override
  Future<OtpResponse> resendOtp(String token) async {
    final response = await apiService.performGetRequest(
      'users/auth/signup/resend-otp',
      {
        "token": token,
      },
    );
    return OtpResponse.fromJson(response['data']);
  }

  @override
  void saveUserDetails(UserDetails userDetails) {
    this.userDetails = userDetails;
  }

  @override
  Future<void> submitDetails(String password) async {
    final Map<String, dynamic> requestBody = {
      ...userDetails!.toJson(),
      "token": otpToken,
      "password": int.parse(password),
    };

    // Conditionally add posToken if account type is business
    if (getAccountType() == AccountType.retailer) {
      requestBody["posToken"] = posToken;
      requestBody["retailerRole"] = retailerRole.toString();
    }

    final response = await apiService.performPostRequest(
      'users/auth/signup/submit',
      requestBody,
    );

    // save phoneNumber from the response
    String phoneNumber = response['data']['user']['phone'];
    secureStorageService.writeKeyValue(
        SecureStorageKey.phoneNumber, phoneNumber);

    //make login api call
    await login(password);
  }

  @override
  Future<AuthTokens> login(String password, {String? phoneNumber}) async {
    phoneNumber ??=
        await secureStorageService.readKeyValue(SecureStorageKey.phoneNumber);

    if (phoneNumber == null) {
      throw AppException("Cannot login without phone number");
    }
    final response = await apiService.performPostRequest(
      'users/auth/login',
      {
        "phone": phoneNumber,
        "password": password,
      },
    );

    String? accessToken = response['data']['token'];
    String? refreshToken = response['data']['refreshToken'];
    log.d('received access token: $accessToken, refresh token: $refreshToken');
    //save accessToken to secure storage
    secureStorageService.writeKeyValue(
        SecureStorageKey.userAuthToken, accessToken!);
    //save password to secure storage
    secureStorageService.writeKeyValue(SecureStorageKey.password, password);

    return AuthTokens.fromJson(response['data']);
  }

  @override
  Future<OtpResponse> forgotPassword(String phoneNumber) async {
    final response = await apiService.performPostRequest(
      'users/auth/forgot-password',
      {"phoneNumber": phoneNumber},
    );
    return OtpResponse.fromJson(response['data']);
  }

  @override
  Future<void> verifyForgotPasswordOtp(String otp, String token) async {
    await apiService.performPostRequest(
      'users/auth/verify-forgot-password-otp',
      {
        "otp": otp,
        "token": token,
      },
    );
  }

  @override
  Future<OtpResponse> resendForgotOtp(String token) async {
    final response = await apiService.performGetRequest(
      'users/auth/resend-forgot-otp',
      {
        "token": token,
      },
    );
    return OtpResponse.fromJson(response['data']);
  }

  @override
  Future<void> resetPassword(
      String newPassword, String confirmPassword, String token) async {
    await apiService.performPostRequest(
      'users/auth/reset-password',
      {
        "newPassword": newPassword,
        "confirmPassword": confirmPassword,
        "token": token,
      },
    );
  }

  @override
  Future<UserDetails> fetchUserDetails() async {
    final response = await apiService.performGetRequest(
      'users/auth/me',
      {},
    );

    secureStorageService.writeKeyValue(
        SecureStorageKey.userDetails, jsonEncode(response['data']));

    return UserDetails.fromJson(response['data']);
  }

  AccountType getAccountType() {
    return posToken != null ? AccountType.retailer : AccountType.personal;
  }

  @override
  Future<bool> isLoggedIn() async {
    final accessTokenFromSecureStorage =
        await secureStorageService.readKeyValue(SecureStorageKey.userAuthToken);
    if (accessTokenFromSecureStorage != null &&
        accessTokenFromSecureStorage.isNotEmpty) {
      return true;
    }
    return false;
  }

  @override
  Future<bool> verifyLoginPin(String password) async {
    // make login api call only if not isLoggedIn()
    if (await isLoggedIn()) {
      final passwordFromSecureStorage =
          await secureStorageService.readKeyValue(SecureStorageKey.password);

      //remove this later
      String? token = await secureStorageService
          .readKeyValue(SecureStorageKey.userAuthToken);
      log.d('token from secure storage: $token');

      //match the password
      if (passwordFromSecureStorage == password) {
        return true;
      }
      throw AppException("Pin entered is incorrect");
    } else {
      await login(password);
      return true;
    }
  }

  @override
  Future<void> logout() async {
    //clear all the secure storage values
    await secureStorageService.writeKeyValue(
        SecureStorageKey.userAuthToken, null);
    await secureStorageService.writeKeyValue(SecureStorageKey.password, null);
    await secureStorageService.writeKeyValue(
        SecureStorageKey.phoneNumber, null);
    await secureStorageService.writeKeyValue(
        SecureStorageKey.userDetails, null);
    log.d('cleared all the secure storage values. \n Logged out');
  }

  //clear all the temporary values if submitDetails is not called
  void _clearTempValues() async {
    retailerRole = null;
    posToken = null;
    otpToken = null;
    userDetails = null;
    await secureStorageService.writeKeyValue(
        SecureStorageKey.phoneNumber, null);
  }

  @override
  String? getTestOtp() {
    return testOtp;
  }
}
