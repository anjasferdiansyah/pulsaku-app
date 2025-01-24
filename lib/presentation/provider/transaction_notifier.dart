import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:testing_flutter/domain/entities/transaction.dart';
import 'package:testing_flutter/domain/usecases/transaction/add_transaction.dart';
import 'package:testing_flutter/domain/usecases/transaction/get_total_to_be_settled.dart';
import 'package:testing_flutter/domain/usecases/transaction/get_total_transaction.dart';
import 'package:testing_flutter/domain/usecases/transaction/get_transaction.dart';
import 'package:testing_flutter/domain/usecases/transaction/update_transaction.dart';

class TransactionNotifier extends StateNotifier<AsyncValue<List<Transaction>>> {
  // Usecases injected via constructor
  final GetTransaction getTransactions;
  final AddTransaction addTransaction;
  final GetTotalTransaction getTotalTransaction;
  final GetTotalToBeSettled getTotalToBeSettled;
  final UpdateTransaction updateTransaction;

  // State variables
  double _totalTransaction = 0.0; // Total transaction value
  double _totalToBeSettled = 0.0; // Total to-be-settled value

  // Filter variables
  bool? _filterStatus; // Filter by transaction status
  DateTime? _filterStartDate;
  DateTime? _filterEndDate;

  // Constructor
  TransactionNotifier({
    required this.getTransactions,
    required this.addTransaction,
    required this.getTotalTransaction,
    required this.getTotalToBeSettled,
    required this.updateTransaction,
  }) : super(const AsyncValue.loading()) {
    _initializeTransactions();
  }

  // Fetch initial data
  Future<void> _initializeTransactions() async {
    await fetchTransactions();
  }

  // Public method to fetch transactions with optional filters
  Future<void> fetchTransactions({
    DateTime? startDate,
    DateTime? endDate,
    bool? status,
  }) async {
    state = const AsyncValue.loading(); // Set state to loading
    try {
      final transactions = await getTransactions.call(
        params: TransactionFilter(
          startDate: startDate ?? _filterStartDate,
          endDate: endDate ?? _filterEndDate,
          status: status ?? _filterStatus,
        ),
      );

      // Update local state
      state = AsyncValue.data(transactions);

      // Update totals
      await _updateTotals(transactions); // Update total values after fetching transactions
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace); // Set error state
    }
  }

  // Private method to update totals
  Future<void> _updateTotals(List<Transaction> transactions) async {
    try {
      // Hit the use cases to calculate totals
      _totalTransaction = await getTotalTransaction.call(params: transactions);
      _totalToBeSettled = await getTotalToBeSettled.call(params: transactions);

      // Log the totals for debugging
      Logger().i("Total Transaction: $_totalTransaction");
      Logger().i("Total To Be Settled: $_totalToBeSettled");
    } catch (e) {
      Logger().e("Error updating totals: $e");
    }
  }

  // Method to add a new transaction
  Future<void> addNewTransaction(Transaction transaction) async {
    try {
      await addTransaction.call(params: transaction);
      await fetchTransactions(); // Refresh transactions after adding
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  // Public getters for totals
  double get totalTransaction => _totalTransaction;
  double get totalToBeSettled => _totalToBeSettled;

  // Filter setter for status
  void setFilterStatus(bool? status) {
    _filterStatus = status;
    fetchTransactions(status: status); // Refresh transactions with new status filter
  }

  // Filter setter for date range
  void setDateFilter(DateTime? startDate, DateTime? endDate) {
    _filterStartDate = startDate;
    _filterEndDate = endDate;
    fetchTransactions(startDate: startDate, endDate: endDate);
  }

  // Method to update transaction status
  Future<void> changeTransactionStatus(int id) async {
    try {
      await updateTransaction.call(params: id);
      Logger().i("Status updated for transaction ID $id");
      await fetchTransactions(); // Refresh transactions after status change
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}

// Riverpod provider for TransactionNotifier
final transactionProvider = StateNotifierProvider<TransactionNotifier, AsyncValue<List<Transaction>>>(
  (ref) => TransactionNotifier(
    getTransactions: GetIt.I.get<GetTransaction>(),
    addTransaction: GetIt.I.get<AddTransaction>(),
    getTotalTransaction: GetIt.I.get<GetTotalTransaction>(),
    getTotalToBeSettled: GetIt.I.get<GetTotalToBeSettled>(),
    updateTransaction: GetIt.I.get<UpdateTransaction>(),
  ),
);
