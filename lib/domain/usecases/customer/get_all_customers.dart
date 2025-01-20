import 'package:testing_flutter/core/di/app_container.dart';
import 'package:testing_flutter/core/usecase/use_case.dart';
import 'package:testing_flutter/domain/entities/customer.dart';
import 'package:testing_flutter/domain/repository/customer_repository.dart';

class GetAllCustomers implements UseCase<List<Customer>, void> {

  final CustomerRepository repository = getIt<CustomerRepository>();

  @override
   Future<List<Customer>> call({void params}) async {
    final list = await repository.getCustomers();
    return list;
  }

}