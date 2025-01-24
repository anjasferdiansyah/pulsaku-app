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
    return await openDatabase(
      path,
      version: 1, 
      onCreate: _onCreate, 
      onUpgrade: _onUpgrade, // Handle upgrade if needed
    );
  }

  // Fungsi untuk membuat tabel saat pertama kali aplikasi dijalankan
  Future<void> _onCreate(Database db, int version) async {

    await db.execute('''
  DROP TABLE IF EXISTS customers;
''');

await db.execute('''
  DROP TABLE IF EXISTS transactions;
''');


 await db.execute('''
    CREATE TABLE IF NOT EXISTS customers(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      phone TEXT,
      isDeleted INTEGER DEFAULT 0
    )
  ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS transactions(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        customerId INTEGER,
        amount REAL,
        sellingPrice REAL,
        date TEXT,
        status INTEGER,
        note TEXT,
        FOREIGN KEY(customerId) REFERENCES customers(id)
      )
    ''');

    // Insert seed data if needed
    // await db.insert('customers', {'name': 'John Doe', 'phone': '123456789'});
  }

  // Handle database version upgrades
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle schema changes here
  }

  Future<void> deleteExistingDatabase() async {
  // Mendapatkan path database
  final dbPath = await getDatabasesPath();
  final path = join(dbPath, 'pulsaku_app.db'); // Ganti dengan nama database Anda

  // Menghapus database
  await deleteDatabase(path);
}
}
