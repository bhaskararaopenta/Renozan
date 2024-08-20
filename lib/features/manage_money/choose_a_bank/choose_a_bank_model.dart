class BankAccountModel {
  bool? success;
  String? message;
  Data? data;

  BankAccountModel({this.success, this.message, this.data});

  BankAccountModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
}

class Data {
  List<BankModel>? list;

  Data({this.list});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      list = <BankModel>[];
      json['list'].forEach((v) {
        list!.add(BankModel.fromJson(v));
      });
    }
  }
}

class BankModel {
  int? id;
  String? name;
  String? branch;
  String? address;
  String? city;
  String? country;
  String? postalCode;
  String? ifscCode;
  String? createdAt;
  String? updatedAt;

  BankModel({
    this.id,
    this.name,
    this.branch,
    this.address,
    this.city,
    this.country,
    this.postalCode,
    this.ifscCode,
    this.createdAt,
    this.updatedAt,
  });

  BankModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    branch = json['branch'];
    address = json['address'];
    city = json['city'];
    country = json['country'];
    postalCode = json['postalCode'];
    ifscCode = json['ifscCode'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }
}
