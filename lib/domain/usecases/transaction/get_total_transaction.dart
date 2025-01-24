import 'package:testing_flutter/core/usecase/use_case.dart';
import 'package:testing_flutter/domain/entities/transaction.dart';

class GetTotalTransaction implements UseCase<double, List<Transaction>> {
  @override
  Future<double> call({List<Transaction>? params}) async {
    if (params == null || params.isEmpty) {
      return 0;
    }

    // Hitung total transaksi dan total yang harus disetor
    double totalTransaksi = params.fold(0, (sum, transaction) => sum + transaction.amount);

    return totalTransaksi;
  }
}
