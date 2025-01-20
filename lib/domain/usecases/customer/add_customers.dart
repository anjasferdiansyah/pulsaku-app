import 'package:testing_flutter/core/usecase/use_case.dart';
import 'package:testing_flutter/domain/entities/customer.dart';
import 'package:testing_flutter/domain/repository/customer_repository.dart';

class AddCustomers implements UseCase<void, Customer> {

  final CustomerRepository repository;

  AddCustomers(this.repository);

  @override
  Future<void> call({Customer ? params }) async {
    return await repository.addCustomer(params!);
  }

}