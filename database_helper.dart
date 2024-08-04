import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final _databaseName = "stopwatch.db";
  static final _databaseVersion = 1;

  static final table = 'records';

  static final columnId = '_id';
  static final columnLabel = 'label';
  static final columnTime = 'time'; // Store as milliseconds

  // Singleton pattern
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (
        $columnId INTEGER PRIMARY KEY,
        $columnLabel TEXT NOT NULL,
        $columnTime INTEGER NOT NULL
      )
    ''');
  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    // Order by columnId in descending order
    return await db.query(table, orderBy: '$columnId DESC');
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }
}
