import 'package:testing_flutter/core/usecase/use_case.dart';
import 'package:testing_flutter/domain/repository/transaction_repository.dart';
import 'package:testing_flutter/domain/usecases/transaction/get_transaction.dart';

class GetTotalToBeSettled implements UseCase<double, TransactionFilter> {
  final TransactionRepository repository;

  GetTotalToBeSettled(this.repository);

  @override
  Future<double> call({TransactionFilter? params}) {
    return repository.getTotalToBeSettled(
      startDate: params?.startDate,
      endDate: params?.endDate,
    );
  }
}