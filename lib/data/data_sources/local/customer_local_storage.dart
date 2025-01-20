import 'package:sqflite/sqflite.dart';
import 'package:testing_flutter/config/database_helper.dart';
import 'package:testing_flutter/data/model/customer_model.dart';
import 'package:testing_flutter/domain/entities/customer.dart';

class CustomerLocalStorage {
  
  final DatabaseHelper databaseHelper;

  CustomerLocalStorage(this.databaseHelper);

  Future<List<Customer>> getCustomers() async {
    final db = await databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('customers');
    return List.generate(maps.length, (index) => CustomerModel.fromMap(maps[index]));
  }

  Future<Customer> getCustomer(int id) async {
    final db = await databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('customers', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return CustomerModel.fromMap(maps.first);
    } else {
      throw Exception('Customer not found');
    }
  }

  Future<void> addCustomer(Customer customer) async {
    final db = await databaseHelper.database;
    await db.insert('customers', customer.toMap());
  }

  Future<void> updateCustomer(Customer customer) async {
    final db = await databaseHelper.database;
    await db.update('customers', customer.toMap(), where: 'id = ?', whereArgs: [customer.id]);
  }

  Future<void> deleteCustomer(int id) async {
    final db = await databaseHelper.database;
    await db.delete('customers', where: 'id = ?', whereArgs: [id]);
  }

   Future<void> seedData() async {
    final db = await databaseHelper.database;

    // Check if there are already records in the 'customers' table
    final count = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM customers')) ?? 0;

    if (count == 0) {
      // List of initial customers to seed
      final initialCustomers = [
        CustomerModel(id: 1, name: "John Doe", phone: "1234567890"),
        CustomerModel(id: 2, name: "Jane Smith", phone: "0987654321"),
        CustomerModel(id: 3, name: "Alice Johnson", phone: "5555555555"),
      ];

      // Insert each customer into the database
      for (var customer in initialCustomers) {
        await db.insert('customers', customer.toMap());
      }
    }
  }


  Future<void> close() async {
    final db = await databaseHelper.database;
    await db.close();
  }

  Future<void> clearDataCustomer() async {
    final db = await databaseHelper.database;
    await db.delete('customers');
  }
}