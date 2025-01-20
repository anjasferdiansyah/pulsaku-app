import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testing_flutter/domain/entities/transaction.dart';
import 'package:testing_flutter/domain/usecases/transaction/add_transaction.dart';
import 'package:testing_flutter/domain/usecases/transaction/get_transaction.dart';

class TransactionNotifier extends StateNotifier<AsyncValue<List<Transaction>>> {
  final GetTransaction getTransactions;
  final AddTransaction addTransaction;

  TransactionNotifier({
    required this.getTransactions,
    required this.addTransaction,
  }) : super(const AsyncValue.loading());

  // Fetch all transactions with optional filters
  Future<void> fetchTransactions({DateTime? startDate, DateTime? endDate, bool? status}) async {
    try {
      state = const AsyncValue.loading();
      final transactions = await getTransactions.call(params: TransactionFilter(startDate: startDate, endDate: endDate, status: status));
      state = AsyncValue.data(transactions);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  // Add a new transaction
  Future<void> addNewTransaction(Transaction transaction) async {
    try {
      await addTransaction.call(params: transaction);
      // Refresh transactions after adding
      await fetchTransactions();
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}
