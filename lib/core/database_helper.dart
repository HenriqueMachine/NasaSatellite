import 'package:nasa_satellite/core/app_config.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../domain/nasa_planetary_entity.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String databasesPath = await getDatabasesPath();
    String dbPath = join(databasesPath, '${AppConfig.nasaDatabaseName}.db');
    return await openDatabase(dbPath, version: 1, onCreate: _createDb);
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE ${AppConfig.nasaDatabaseName} (id INTEGER PRIMARY KEY, title TEXT, url TEXT, explanation TEXT, date TEXT)');
  }

  Future insertData(Map<String, dynamic> data,
      {String tableName = AppConfig.nasaDatabaseName}) async {
    Database db = await database;
    return await db.insert(tableName, data,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<NasaPlanetaryEntity>> getNasaPlanetaryEntities() async {
    final List<Map<String, dynamic>> data = await getData();

    return List.generate(data.length, (i) {
      return NasaPlanetaryEntity(
        explanation: data[i]['explanation'],
        title: data[i]['title'],
        url: data[i]['url'],
        date: data[i]['date'],
      );
    });
  }

  Future<List<Map<String, dynamic>>> getData(
      {String tableName = AppConfig.nasaDatabaseName}) async {
    Database db = await database;
    return await db.query(tableName);
  }

  Future clearTable(
      {String tableName = AppConfig.nasaDatabaseName}) async {
    final Database db = await database;
    await db.delete(tableName);
  }
}
