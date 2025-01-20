import 'package:testing_flutter/core/usecase/use_case.dart';
import 'package:testing_flutter/domain/entities/customer.dart';
import 'package:testing_flutter/domain/repository/customer_repository.dart';

class UpdateCustomers implements UseCase<void, Customer> {
  final CustomerRepository _customerRepository;


  UpdateCustomers(this._customerRepository);

  @override
  Future<void> call({Customer ? params}) {
    return _customerRepository.updateCustomer(params!);
  }

}