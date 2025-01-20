import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testing_flutter/core/di/app_container.dart';
import 'package:testing_flutter/domain/entities/customer.dart';
import 'package:testing_flutter/domain/usecases/customer/add_customers.dart';
import 'package:testing_flutter/domain/usecases/customer/delete_customers.dart';
import 'package:testing_flutter/domain/usecases/customer/get_all_customers.dart';
import 'package:testing_flutter/domain/usecases/customer/update_customers.dart';

class CustomerNotifier extends StateNotifier<AsyncValue<List<Customer>>> {
  final GetAllCustomers getAllCustomers;
  final AddCustomers addCustomer;
  final DeleteCustomer deleteCustomer;
  final UpdateCustomers updateCustomer;

  List<Customer> _allCustomers = [];
  

  CustomerNotifier({
    required this.deleteCustomer,
    required this.getAllCustomers,
    required this.addCustomer,
    required this.updateCustomer
  }) : super(const AsyncValue.loading()) {
    _fetchCustomers();
  }

  // Fetch pelanggan
   // Fetch pelanggan
  Future<void> _fetchCustomers() async {
    try {
      state = AsyncValue.loading();
      final customers = await getAllCustomers.call();
      _allCustomers = customers;
      debugPrint(_allCustomers.toString());
      state = AsyncValue.data(customers);

    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> removeCustomer(int id) async {
    try {
      await deleteCustomer.call(params: id);
      await _fetchCustomers(); // Refresh data setelah menghapus pelanggan
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
    
  }

  void searchCustomerByName (String name) {
    if(name.isEmpty) {
      state = AsyncValue.data(_allCustomers);
    } else {
        final filtered = _allCustomers
          .where((customer) =>
              (customer.name ?? '').toLowerCase().contains(name.toLowerCase()))
          .toList();
      state = AsyncValue.data(filtered);
    }
  }

  // Tambahkan pelanggan
  Future<void> add(Customer customer) async {
    try {
      await addCustomer.call(params: customer);
      await _fetchCustomers(); // Refresh data setelah menambahkan pelanggan
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  // Update pelanggan
  Future<void> update(Customer customer) async {
    try {
      await updateCustomer.call(params: customer);
      await _fetchCustomers(); // Refresh data setelah menambahkan pelanggan
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}



// Mengambil instance dari service locator
final customerNotifierProvider =
    StateNotifierProvider<CustomerNotifier, AsyncValue<List<Customer>>>(
  (ref) {
    return CustomerNotifier(
      deleteCustomer: getIt<DeleteCustomer>(),
      getAllCustomers: getIt<GetAllCustomers>(),
      addCustomer: getIt<AddCustomers>(),
      updateCustomer : getIt<UpdateCustomers>(),
    );
  },
);
