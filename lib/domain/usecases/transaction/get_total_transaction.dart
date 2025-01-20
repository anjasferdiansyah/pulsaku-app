import 'package:testing_flutter/core/usecase/use_case.dart';
import 'package:testing_flutter/domain/repository/transaction_repository.dart';
import 'package:testing_flutter/domain/usecases/transaction/get_transaction.dart';

class GetTotalTransaction implements UseCase<double, TransactionFilter> {
 
  final TransactionRepository transactionRepository;

  GetTotalTransaction(this.transactionRepository);

  @override
  Future<double> call({TransactionFilter? params}) async {
    return await transactionRepository.getTotalTransactions(
      startDate: params?.startDate,
      endDate: params?.endDate
    );
  }

}