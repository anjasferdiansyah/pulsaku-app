import 'package:testing_flutter/domain/entities/transaction.dart';

abstract class TransactionRepository {
  Future<void> addTransaction(Transaction transaction);
  Future<List<Transaction>> getTransactions({DateTime? startDate, DateTime? endDate, bool? status});
  Future<double> getTotalTransactions({DateTime? startDate, DateTime? endDate});
  Future<double> getTotalToBeSettled({DateTime? startDate, DateTime? endDate});
  Future<void> updateTransaction(int id);
}