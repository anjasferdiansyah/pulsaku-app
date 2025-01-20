import 'package:get_it/get_it.dart';
import 'package:testing_flutter/config/database_helper.dart';
import 'package:testing_flutter/data/data_sources/local/customer_local_storage.dart';
import 'package:testing_flutter/data/data_sources/local/transaction_local_storage.dart';
import 'package:testing_flutter/data/repository/customer_repository_impl.dart';
import 'package:testing_flutter/data/repository/transaction_repository_impl.dart';
import 'package:testing_flutter/domain/repository/customer_repository.dart';
import 'package:testing_flutter/domain/repository/transaction_repository.dart';
import 'package:testing_flutter/domain/usecases/customer/add_customers.dart';
import 'package:testing_flutter/domain/usecases/customer/delete_customers.dart';
import 'package:testing_flutter/domain/usecases/customer/get_all_customers.dart';
import 'package:testing_flutter/domain/usecases/customer/update_customers.dart';
import 'package:testing_flutter/domain/usecases/transaction/add_transaction.dart';
import 'package:testing_flutter/domain/usecases/transaction/get_total_to_be_settled.dart';
import 'package:testing_flutter/domain/usecases/transaction/get_total_transaction.dart';
import 'package:testing_flutter/domain/usecases/transaction/get_transaction.dart';

final getIt = GetIt.instance;

Future<void> setup() async {
  // Register Database
  getIt.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());

  // Register Data Source
  getIt.registerLazySingleton<CustomerLocalStorage>(() => CustomerLocalStorage(getIt()));
  getIt.registerLazySingleton<TransactionLocalStorage>(() => TransactionLocalStorage(getIt()));

  // Register Repository
  getIt.registerLazySingleton<CustomerRepository>(() => CustomerRepositoryImpl(getIt()));
  getIt.registerLazySingleton<TransactionRepository>(() => TransactionRepositoryImpl(getIt()) );

  // Register UseCase
  getIt.registerLazySingleton(() => GetAllCustomers());
  getIt.registerLazySingleton(() => AddCustomers(getIt()));
  getIt.registerLazySingleton(() => DeleteCustomer(getIt()));
  getIt.registerLazySingleton(() => UpdateCustomers(getIt()));

  getIt.registerLazySingleton(() => GetTotalTransaction(getIt()));
  getIt.registerLazySingleton(() => GetTotalToBeSettled(getIt()));
  getIt.registerLazySingleton(() => GetTransaction(getIt()));
  getIt.registerLazySingleton(() => AddTransaction(getIt()));

  
}