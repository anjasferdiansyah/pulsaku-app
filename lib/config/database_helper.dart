import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


class DatabaseHelper {
  static Database? _database;

  // Singleton pattern untuk mendapatkan instance database
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Fungsi untuk menginisialisasi database
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath(); // Lokasi penyimpanan database
    final path = join(dbPath, 'pulsaku_app.db'); // Nama database
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  // Fungsi untuk membuat tabel saat pertama kali aplikasi dijalankan
  Future<void> _onCreate(Database db, int version) async {

    await db.execute('''DROP TABLE IF EXISTS customers;
    ''');

    await db.execute('''DROP TABLE IF EXISTS transactions;
    ''');


    await db.execute('''
      CREATE TABLE customers(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        phone TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE transactions(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        customerId INTEGER,
        amount REAL,
        sellingPrice REAL,
        date TEXT,
        status INTEGER,
      )
    ''');
  }
}
