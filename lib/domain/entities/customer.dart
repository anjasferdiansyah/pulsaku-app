import 'package:equatable/equatable.dart';

class Customer extends Equatable {
  final int? id;
  final String? name;
  final String? phone;
  final bool? isDeleted;

const Customer({
    this.id,
    required this.name,
    required this.phone,
    this.isDeleted
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      isDeleted: json['isDeleted'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'isDeleted': isDeleted
    };
  }


  factory Customer.fromMap(Map<String, dynamic> map) {
    return Customer(
      id: map['id'] as int?,
      name: map['name'],
      phone: map['phone'],
      isDeleted: map['isDeleted'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'isDeleted': isDeleted
    };
  }

  @override
  List<Object?> get props => [id, name, phone, isDeleted];

  @override
  bool get stringify => true; // Optional: If you want object to print in readable format
}
