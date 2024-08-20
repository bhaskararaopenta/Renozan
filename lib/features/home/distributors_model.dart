class DistributorsData {
   String image;
   String text;

  DistributorsData({required this.image, required this.text});

  factory DistributorsData.fromJson(Map<String, dynamic> json) {
    return DistributorsData(
      image: json['image'],
      text: json['text'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'image': image,
      'text': text,
    };
  }
}