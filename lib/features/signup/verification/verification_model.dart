class verificationResponse {
  final String status;
  final String message;

  verificationResponse({required this.status, required this.message});

  factory verificationResponse.fromJson(Map<String, dynamic> json) {
    return verificationResponse(
      status: json['status'],
      message: json['message'],
    );
  }
}
