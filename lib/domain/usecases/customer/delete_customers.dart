import 'package:testing_flutter/core/usecase/use_case.dart';
import 'package:testing_flutter/domain/repository/customer_repository.dart';

class DeleteCustomer implements UseCase<void, int> {
  final CustomerRepository repository;

  DeleteCustomer(this.repository);

  @override
  Future<void> call({int ? params}) async {
    // Memanggil metode deleteCustomer di repository dengan ID sebagai parameter
    await repository.deleteCustomer(params!);
  }
}
