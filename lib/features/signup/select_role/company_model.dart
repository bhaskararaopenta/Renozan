class Company {
  final String image;
  final String text;

  Company({required this.image, required this.text});

  // Convert JSON data to a Company object
  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      image: json['image'],
      text: json['text'],
    );
  }

  // Convert a Company object to JSON data
  Map<String, dynamic> toJson() {
    return {
      'image': image,
      'text': text,
    };
  }
}
