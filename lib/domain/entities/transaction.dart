import 'package:equatable/equatable.dart';

class Transaction extends Equatable {
  
  final int? id;
  final int customerId;
  final double sellingPrice;
  final double amount;
  final DateTime date;
  final bool status;
  final String? note;

  const Transaction({
    this.id,
    required this.sellingPrice,
    required this.customerId,
    required this.amount,
    required this.date,
    this.note,
    this.status = false
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      customerId: json['customerId'],
      sellingPrice: json['sellingPrice'],
      amount: json['amount'],
      date: DateTime.parse(json['date']),
      status: json['status'],
    );
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'] as int?,
      customerId: map['customerId'],
      sellingPrice: map['sellingPrice'],
      amount: map['amount'],
      date: DateTime.parse(map['date']),
      status: map['status'],
      note: map['note'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customerId': customerId,
      'sellingPrice': sellingPrice,
      'amount': amount,
      'date': date.toIso8601String(),
      'status': status,
      'note': note
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerId': customerId,
      'sellingPrice': sellingPrice,
      'amount': amount,
      'date': date.toIso8601String(),
      'status': status
    };
  }

  @override
  List<Object?> get props => [id, customerId, sellingPrice, amount, date];

}