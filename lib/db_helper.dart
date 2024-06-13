import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'dictionary.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE dictionary (
        id INTEGER PRIMARY KEY,
        english TEXT,
        turkish TEXT
      )
    ''');
  }

  Future<void> insertWord(Map<String, dynamic> word) async {
    final db = await database;
    await db.insert('dictionary', word);
  }

  Future<List<Map<String, dynamic>>> queryAllWords() async {
    final db = await database;
    return await db.query('dictionary');
  }
}
