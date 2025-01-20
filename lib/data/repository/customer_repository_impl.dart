import 'package:testing_flutter/data/data_sources/local/customer_local_storage.dart';
import 'package:testing_flutter/domain/entities/customer.dart';
import 'package:testing_flutter/domain/repository/customer_repository.dart';

class CustomerRepositoryImpl implements CustomerRepository {


final CustomerLocalStorage localDataSource;

  CustomerRepositoryImpl(this.localDataSource);

  @override
  Future<List<Customer>> getCustomers() async {
    final customerModels = await localDataSource.getCustomers();
    return customerModels;
  }

  @override
  Future<Customer> getCustomer(int id) async {
    final customerModel = await localDataSource.getCustomer(id);
    return customerModel;
  }

  @override
  Future<void> addCustomer(Customer customer) async {
    localDataSource.addCustomer(customer);
  }

  @override
  Future<void> updateCustomer(Customer customer) async {
    localDataSource.updateCustomer(customer);
  }

  @override
  Future<void> deleteCustomer(int id) async {
    localDataSource.deleteCustomer(id);
  }

}