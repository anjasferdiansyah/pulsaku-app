import 'package:testing_flutter/core/usecase/use_case.dart';
import 'package:testing_flutter/domain/entities/transaction.dart';
import 'package:testing_flutter/domain/repository/transaction_repository.dart';

class GetTransaction implements UseCase<List<Transaction>, TransactionFilter> {
  final TransactionRepository repository;

  GetTransaction(this.repository);

  @override
  Future<List<Transaction>> call({TransactionFilter? params}) async {
    final list = await repository.getTransactions(
      startDate: params?.startDate,
      endDate: params?.endDate,
      status: params?.status
    );
    return list;
  }
}

class TransactionFilter {
  final DateTime? startDate;
  final DateTime? endDate;
  final bool? status;

  TransactionFilter({this.startDate, this.endDate, this.status});
}