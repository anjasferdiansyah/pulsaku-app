import 'package:testing_flutter/domain/entities/customer.dart';

class CustomerModel extends Customer {
  const CustomerModel({
    super.id,
    required super.name,
    required super.phone,
    super.isDeleted = false,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      isDeleted: json['isDeleted'],
    );
  }

  factory CustomerModel.fromMap(Map<String, dynamic> map) {
    return CustomerModel(
      id: map['id'],
      name: map['name'],
      phone: map['phone'],
      isDeleted: map['isDeleted'] == 1,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'isDeleted': isDeleted
    };
  }
}