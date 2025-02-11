
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/planeta.dart';

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
    String path = join(await getDatabasesPath(), 'planetas.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE planetas(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        distanciaSol REAL NOT NULL,
        tamanho REAL NOT NULL,
        apelido TEXT
      )
    ''');
  }

  Future<int> insertPlaneta(Planeta planeta) async {
    Database db = await database;
    return await db.insert('planetas', planeta.toMap());
  }

  Future<List<Planeta>> getPlanetas() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('planetas');
    return List.generate(maps.length, (i) {
      return Planeta.fromMap(maps[i]);
    });
  }

  Future<int> updatePlaneta(Planeta planeta) async {
    Database db = await database;
    return await db.update(
      'planetas',
      planeta.toMap(),
      where: 'id = ?',
      whereArgs: [planeta.id],
    );
  }

  Future<int> deletePlaneta(int id) async {
    Database db = await database;
    return await db.delete(
      'planetas',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
