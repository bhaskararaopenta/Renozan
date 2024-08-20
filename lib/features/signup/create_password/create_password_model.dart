class CreatePasswordModel {
  final String status;
  final String message;

  CreatePasswordModel({required this.status, required this.message});

  factory CreatePasswordModel.fromJson(Map<String, dynamic> json) {
    return CreatePasswordModel(
      status: json['status'],
      message: json['message'],
    );
  }
}
