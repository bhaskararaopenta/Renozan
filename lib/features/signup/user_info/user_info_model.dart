// class UserInfoModel {
//   final String message;

//   UserInfoModel({
//     required this.message,
//   });

//   factory UserInfoModel.fromJson(Map<String, dynamic> json) {
//     return UserInfoModel(
//       message: json['message'],
//     );
//   }
// }

class UserInfoModel {
  final String name;
  final String dob;
  final String address;
  final String email;

  UserInfoModel({
    required this.name,
    required this.dob,
    required this.address,
    required this.email,
  });

  factory UserInfoModel.fromJson(Map<String, dynamic> json) {
    return UserInfoModel(
      name: json['name'],
      dob: json['dob'],
      address: json['address'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'dob': dob,
      'address': address,
      'email': email,
    };
  }
}
