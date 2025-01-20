import 'package:testing_flutter/data/data_sources/local/transaction_local_storage.dart';
import 'package:testing_flutter/domain/entities/transaction.dart';
import 'package:testing_flutter/domain/repository/transaction_repository.dart';

class TransactionRepositoryImpl implements TransactionRepository {

  final TransactionLocalStorage localStorage;

  TransactionRepositoryImpl(this.localStorage);



  @override
  Future<void> addTransaction(Transaction transaction) async {
   
   try {
     await localStorage.addTransaction(transaction);
   } catch (e) {
     rethrow;
   }

  }

  @override
  Future<double> getTotalToBeSettled({DateTime? startDate, DateTime? endDate}) {
    try {
      return localStorage.getTotalToBeSettled(startDate: startDate, endDate: endDate);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<double> getTotalTransactions({DateTime? startDate, DateTime? endDate}) {
    try {
      return localStorage.getTotalTransactions(startDate: startDate, endDate: endDate);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Transaction>> getTransactions({DateTime? startDate, DateTime? endDate, bool? status}) {
    try {
      return localStorage.getTransactions(startDate: startDate, endDate: endDate, status: status);
    } catch (e) {
      rethrow;
    }
  }
  
}