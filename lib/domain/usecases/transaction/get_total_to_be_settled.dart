import 'package:testing_flutter/core/usecase/use_case.dart';
import 'package:testing_flutter/domain/entities/transaction.dart';

class GetTotalToBeSettled implements UseCase<double, List<Transaction>> {
  
  // Tidak ada repository yang digunakan
  GetTotalToBeSettled();

  @override
  Future<double> call({List<Transaction>? params}) async {
    if (params == null || params.isEmpty) {
      return 0; // Kembalikan 0 jika tidak ada transaksi
    }

    // Hitung total transaksi yang belum dibayar
    double totalToBeSettled = params
        .where((transaction) => !transaction.status) // Hanya transaksi yang belum dibayar
        .fold(0, (sum, transaction) => sum + transaction.sellingPrice);

    return totalToBeSettled;
  }
}
