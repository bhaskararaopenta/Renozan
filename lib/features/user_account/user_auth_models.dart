import 'package:app/features/user_account/account_type.dart';

class Pos {
  final String posRefId;
  final String businessName;
  final String? location;
  final String? contactNumber;
  final String? businessType;
  final String? contactEmail;
  final String posToken;
  final String? businessLogo; // Make businessLogo optional

  Pos({
    required this.posRefId,
    required this.businessName,
    this.location,
    this.contactNumber,
    this.businessType,
    this.contactEmail,
    required this.posToken,
    this.businessLogo,
  });

  factory Pos.fromJson(Map<String, dynamic> json, String posToken) {
    return Pos(
      posRefId: json['posRefId'],
      businessName: json['businessName'],
      location: json['location'],
      contactNumber: json['contactNumber'],
      businessType: json['businessType'],
      contactEmail: json['contactEmail'],
      posToken: posToken,
      businessLogo:
          json['businessLogo'], // This will be null if not present in JSON
    );
  }
}

class OtpResponse {
  final String otp;
  final String token;

  OtpResponse({required this.otp, required this.token});

  factory OtpResponse.fromJson(Map<String, dynamic> json) {
    return OtpResponse(
      otp: json['otp'],
      token: json['token'],
    );
  }
}

class AuthTokens {
  final String token;
  final String refreshToken;
  final int expiration;

  AuthTokens({
    required this.token,
    required this.refreshToken,
    required this.expiration,
  });

  factory AuthTokens.fromJson(Map<String, dynamic> json) {
    return AuthTokens(
      token: json['token'],
      refreshToken: json['refreshToken'],
      expiration: json['expiration'],
    );
  }
}

class Account {
  final String businessName;
  final String accountType;
  final String accountCode;
  final String? defaultCurrency;
  final Map<String, dynamic> settings;
  final Role role;

  Account({
    required this.businessName,
    required this.accountType,
    required this.accountCode,
    this.defaultCurrency,
    required this.settings,
    required this.role,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      businessName: json['businessName'],
      accountType: json['accountType'],
      accountCode: json['accountCode'],
      defaultCurrency: json['defaultCurrency'] ?? 'USD',
      settings: json['settings'] ?? {},
      role: Role.fromJson(json['role']),
    );
  }

  //add method to return accountType = retailer
  bool isRetailerAccount() {
    return accountType == AccountType.retailer.toString();
  }
}

class Role {
  final String name;
  final String description;
  final String roleType;
  final List<dynamic> permissions;
  final String accountUserRoleCode;

  Role({
    required this.name,
    required this.description,
    required this.roleType,
    required this.permissions,
    required this.accountUserRoleCode,
  });

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      name: json['name'],
      description: json['description'],
      roleType: json['roleType'],
      permissions: json['permissions'] ?? [],
      accountUserRoleCode: json['accountUserRoleCode'],
    );
  }
}

class UserDetails {
  final String fullName;
  final String dateOfBirth;
  final String email;
  final String userCode;
  final String address1;
  final String address2;
  final String city;
  final String state;
  final String country;
  final String postalCode;
  final List<Account> accounts;

  UserDetails({
    required this.fullName,
    this.dateOfBirth = "",
    required this.email,
    required this.address1,
    this.userCode = "",
    this.address2 = "N/A",
    this.city = "N/A",
    this.state = "N/A",
    this.country = "N/A",
    this.postalCode = "N/A",
    this.accounts = const [],
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      fullName: json['fullName'],
      //dateOfBirth: json['dateOfBirth'],
      email: json['email'],
      userCode: json['userCode'],
      address1: json['address']['address1'],
      address2: json['address']['address2'] ?? "N/A",
      city: json['address']['city'] ?? "N/A",
      state: json['address']['state'] ?? "N/A",
      country: json['address']['country'] ?? "N/A",
      postalCode: json['address']['postalCode'] ?? "N/A",
      accounts: (json['accounts'] as List<dynamic>)
          .map((accountJson) => Account.fromJson(accountJson))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'dateOfBirth': dateOfBirth,
      'country': country,
      'state': state,
      'city': city,
      'address1': address1,
      'address2': address2,
      'email': email,
      'postalCode': postalCode,
    };
  }

  //add method to return the retailer account
  Account getRetailerAccount() {
    return accounts.firstWhere((account) => account.isRetailerAccount());
  }
  
}
