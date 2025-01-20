import 'package:testing_flutter/domain/entities/customer.dart';

abstract class CustomerRepository {
  Future<List<Customer>> getCustomers();
  Future<Customer> getCustomer(int id);
  Future<void> addCustomer(Customer customer);
    Future<void> updateCustomer(Customer customer);
  Future<void> deleteCustomer(int id);
}