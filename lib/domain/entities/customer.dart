import 'package:equatable/equatable.dart';

class Customer extends Equatable {
  final int? id;
  final String? name;
  final String? phone;

const Customer({
    this.id,
    required this.name,
    required this.phone,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
    };
  }


  factory Customer.fromMap(Map<String, dynamic> map) {
    return Customer(
      id: map['id'] as int?,
      name: map['name'],
      phone: map['phone'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
    };
  }

  @override
  List<Object?> get props => [id, name, phone];

  @override
  bool get stringify => true; // Optional: If you want object to print in readable format
}
