class PhoneNumberModel {
  final String otp;
  final String token;
  final String status;

  PhoneNumberModel({
    required this.otp,
    required this.token,
    required this.status,
  });

  factory PhoneNumberModel.fromJson(Map<String, dynamic> json) {
    return PhoneNumberModel(
      otp: json['otp'],
      token: json['token'],
      status: json['status'],
    );
  }
}
