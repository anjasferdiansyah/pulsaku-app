import 'package:sqflite/sqflite.dart';
import 'package:testing_flutter/config/database_helper.dart';
import 'package:testing_flutter/data/model/transaction_model.dart';
import 'package:testing_flutter/domain/entities/transaction.dart' as domain;

class TransactionLocalStorage  {
  final DatabaseHelper _dbHelper;

  TransactionLocalStorage(this._dbHelper);



Future<void> seedTransactions() async {
    // Sample transactions for seeding
    final transactions = [
      domain.Transaction(
        customerId: 1,
        date: DateTime.now().subtract(const Duration(days: 1)),
        amount: 100.0,
        sellingPrice: 120.0,
        status: true, // Paid
      )
    ];

    // Insert all transactions
    for (final transaction in transactions) {
      await addTransaction(transaction);
    }
  }

  Future<void> addTransaction(domain.Transaction transaction) async {
    final db = await _dbHelper.database;

    await db.insert(
      "transactions",
      transaction.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<double> getTotalToBeSettled({DateTime? startDate, DateTime? endDate}) async {
    final db = await _dbHelper.database;

    final whereClause = _buildWhereClause(startDate, endDate, isPaid: false);
    final result = await db.rawQuery('''
      SELECT SUM amount as total
      FROM transactions
      $whereClause
    ''');

    return (result.first['total'] as num?)?.toDouble() ?? 0.0;
  }

  Future<double> getTotalTransactions({DateTime? startDate, DateTime? endDate}) async {
    final db = await _dbHelper.database;

    final whereClause = _buildWhereClause(startDate, endDate);
    final result = await db.rawQuery('''
      SELECT SUM amount as total
      FROM transactions
      $whereClause
    ''');

    return (result.first['total'] as num?)?.toDouble() ?? 0.0;
  }


  Future<List<domain.Transaction>> getTransactions({DateTime? startDate, DateTime? endDate, bool? status}) async {
    final db = await _dbHelper.database;

    final whereClause = _buildWhereClause(startDate, endDate, isPaid: status);
    final result = await db.rawQuery('''
      SELECT *
      FROM transactions
      $whereClause
      ORDER BY date DESC
    ''');

    return result.map((e) => TransactionModel.fromMap(e)).toList();
  }

  String _buildWhereClause(DateTime? startDate, DateTime? endDate, {bool? isPaid}) {
    final whereConditions = <String>[];

    if (startDate != null) {
      whereConditions.add('date >= "${startDate.toIso8601String()}"');
    }
    if (endDate != null) {
      whereConditions.add('date <= "${endDate.toIso8601String()}"');
    }
    if (isPaid != null) {
      whereConditions.add('status = ${isPaid ? 1 : 0}');
    }

    if (whereConditions.isNotEmpty) {
      return 'WHERE ${whereConditions.join(' AND ')}';
    }

    return '';
  }

  Future<void> updateTransaction(int id) async {
  final db = await _dbHelper.database;

  // First, get the current transaction status
  final result = await db.query(
    'transactions', // Table name
    columns: ['status'], // Only fetch the 'status' column
    where: 'id = ?', // Find the transaction by ID
    whereArgs: [id], // Provide the ID as parameter
  );

  if (result.isNotEmpty) {
    // Get the current status (assuming 'status' is a boolean)
    bool currentStatus = result.first['status'] == 1; // Assuming 1 for 'Lunas', 0 for 'Belum Lunas'

    // Toggle the status (from true to false or false to true)
    bool newStatus = !currentStatus;

    // Update the transaction status in the database
    await db.update(
      'transactions', // Table name
      {'status': newStatus ? 1 : 0}, // Set the new status (1 for 'Lunas', 0 for 'Belum Lunas')
      where: 'id = ?', // Find the transaction by ID
      whereArgs: [id], // Provide the ID as parameter
    );
  }
}

}
