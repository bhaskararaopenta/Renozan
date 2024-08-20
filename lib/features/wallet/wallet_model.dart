class WalletInfo {
  int id;
  String walletCode;
  double balance;
  String accountCode;
  String accountType;
  String walletStatus;
  bool isActive;
  String currency;
  String currentStatus;
  String walletType;
  String cardNumber;
  String expiryDate;

  WalletInfo({
    required this.id,
    required this.walletCode,
    required this.balance,
    required this.accountCode,
    required this.accountType,
    required this.walletStatus,
    required this.isActive,
    required this.currency,
    required this.currentStatus,
    required this.walletType,
    this.cardNumber = '*** *** **** 5025', // Default value for cardNumber
    this.expiryDate = '11/24',               // Default value for expiryDate
  });

  factory WalletInfo.fromJson(Map<String, dynamic> json) {
    return WalletInfo(
      id: json['id'],
      walletCode: json['walletCode'],
      balance: json['balance'].toDouble(),
      accountCode: json['accountCode'],
      accountType: json['accountType'],
      walletStatus: json['walletStatus'],
      isActive: json['isActive'],
      currency: json['currency'],
      currentStatus: json['currentStatus'],
      walletType: json['walletType'],
      cardNumber: json['cardNumber'] ?? '*** *** **** 5025', // Fallback to default if not present
      expiryDate: json['expiryDate'] ?? '11/24',               // Fallback to default if not present
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'walletCode': walletCode,
      'balance': balance,
      'accountCode': accountCode,
      'accountType': accountType,
      'walletStatus': walletStatus,
      'isActive': isActive,
      'currency': currency,
      'currentStatus': currentStatus,
      'walletType': walletType,
      'cardNumber': cardNumber,
      'expiryDate': expiryDate,
    };
  }
}
