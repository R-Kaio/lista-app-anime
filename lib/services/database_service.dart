import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/anime_model.dart';

class DatabaseService {
  // Singleton
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;

  DatabaseService._init();

  // Cria um banco novo caso não exista um
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('anime_manager.db');
    return _database!;
  }

  // Inicializa banco no armazenamento seguro
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  // Criação de Tabela SQL
  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE animes (
      id INTEGER PRIMARY KEY,
      title TEXT NOT NULL,
      image_url TEXT NOT NULL,
      synopsis TEXT,
      score REAL,
      watched_episodes INTEGER NOT NULL,
      total_episodes INTEGER,
      status TEXT NOT NULL)
      ''');
  }

  // CRUD
  Future<void> insertAnime(Anime anime) async {
    final db = await instance.database;
    await db.insert(
      'animes',
      anime.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Anime>> getAnimes() async {
    final db = await instance.database;
    final result = await db.query('animes');
    return result.map((json) => Anime.fromMap(json)).toList();
  }

  Future<bool> isSaved(int id) async {
    final db = await instance.database;
    final result = await db.query('animes', where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty;
  }

  Future<void> deleteAnime(int id) async {
    final db = await instance.database;
    await db.delete('animes', where: 'id = ?', whereArgs: [id]);
  }
}
