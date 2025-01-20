import 'package:testing_flutter/core/usecase/use_case.dart';
import 'package:testing_flutter/domain/entities/transaction.dart';
import 'package:testing_flutter/domain/repository/transaction_repository.dart';

class AddTransaction implements UseCase<void, Transaction> {
  final TransactionRepository repository;

  AddTransaction(this.repository);


  @override
  Future<void> call({Transaction? params}) async {
    await repository.addTransaction(params as Transaction);
  }

}