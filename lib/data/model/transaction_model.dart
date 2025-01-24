import 'package:testing_flutter/domain/entities/transaction.dart';

class TransactionModel extends Transaction {
  const TransactionModel({
    super.id,
    required super.customerId,
    required super.date,
    required super.amount,
    required super.sellingPrice,
    required super.status,
    super.note
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      customerId: json['customerId'],
      date: DateTime.parse(json['date']),
      amount: json['amount'],
      sellingPrice: json['sellingPrice'],
      status: json['status'],
      note: json['note'],
    );
  }

  // Mengonversi data dari Map (database) ke objek model
  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'],
      customerId: map['customerId'],
      date: DateTime.parse(map['date']),
      amount: map['amount'],
      sellingPrice: map['sellingPrice'],
      note: map['note'],
      status: map['status'] == 1, // Mengonversi integer ke boolean
    );
  }

  // Mengonversi objek model ke Map (untuk disimpan ke database)
  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customerId': customerId,
      'date': date.toIso8601String(),
      'amount': amount,
      'sellingPrice': sellingPrice,
      'status': status ? 1 : 0, // Mengonversi boolean ke integer
      'note': note
    };
  }

}