class RecentActivityData {
  String image;
  String text;
  String amount;
  String date;

  RecentActivityData(
      {required this.image,
      required this.text,
      required this.amount,
      required this.date});

  factory RecentActivityData.fromJson(Map<String, dynamic> json) {
    return RecentActivityData(
      image: json['image'],
      text: json['text'],
      amount: json['amount'],
      date: json['date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'image': image, 'text': text, 'amount': amount, 'date': date};
  }
}
