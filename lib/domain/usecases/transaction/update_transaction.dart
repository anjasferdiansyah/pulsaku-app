import 'package:testing_flutter/core/usecase/use_case.dart';
import 'package:testing_flutter/domain/repository/transaction_repository.dart';

class UpdateTransaction implements UseCase<void, int> {

  final TransactionRepository repository;

  UpdateTransaction(this.repository);

  @override
  Future<void> call({int? params}) async {
    await repository.updateTransaction(params!);
  }

}