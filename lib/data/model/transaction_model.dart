import 'package:testing_flutter/domain/entities/transaction.dart';

class TransactionModel extends Transaction {
  const TransactionModel({
    required super.id,
    required super.customerId,
    required super.date,
    required super.amount,
    required super.sellingPrice,
    required super.status
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      customerId: json['customerId'],
      date: DateTime.parse(json['date']),
      amount: json['amount'],
      sellingPrice: json['sellingPrice'],
      status: json['status'],
    );
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'],
      customerId: map['customerId'],
      date: DateTime.parse(map['date']),
      amount: map['amount'],
      sellingPrice: map['sellingPrice'],
      status: map['status'],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customerId': customerId,
      'date': date.toIso8601String(),
      'amount': amount,
      'sellingPrice': sellingPrice,
      'status': status
    };
  }
}