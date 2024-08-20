class BusinessConnection {
  final String? id;
  final String businessEmail;
  final String businessName;
  final bool isActive; // Ensure this is handled correctly
  final String businessType;
  final String accountCode;
  final String logo;
  final String connectionStatus;

  BusinessConnection({
    required this.id,
    required this.businessEmail,
    required this.businessName,
    required this.isActive,
    required this.businessType,
    required this.accountCode,
    required this.logo,
    required this.connectionStatus,
  });

  factory BusinessConnection.fromJson(Map<String, dynamic> json) {
    return BusinessConnection(
      id: json['_id'] ?? "", // Safely handle null with an empty string
      businessEmail: json['businessEmail'],
      businessName: json['businessName'],
      isActive: json['isActive'] ??
          false, // Safely handle null by providing a default value
      businessType: json['businessType'] ?? "", // Safely handle null
      accountCode: json['accountCode'],
      logo: json['logo'] ?? "", // Safely handle null with an empty string
      connectionStatus: json['connectionStatus'] ??
          "Unknown", // Safely handle null with a default value
    );
  }
}
