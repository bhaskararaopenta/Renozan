class BankDetailsData {
  String image;
  String bank;
  String accountNumber;

  BankDetailsData({
    required this.image,
    required this.bank,
    required this.accountNumber,
  });

  factory BankDetailsData.fromJson(Map<String, dynamic> json) {
    return BankDetailsData(
      image: json['image'],
      bank: json['bank'],
      accountNumber: json['account number'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'image': image,
      'bank': bank,
      'account number': accountNumber,
    };
  }
}
